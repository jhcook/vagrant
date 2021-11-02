#!/usr/bin/env bash
# 
# Configure a minimal CentOS8 host to run EKS Distro
#
# References: https://distro.eks.amazonaws.com/users/install/kubeadm-onsite/
#             https://medium.com/@sjhuang93/在地端安裝eks-d-eeaaabb1bbca
#             https://docs.fedoraproject.org/en-US/epel/
#             https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/
#             https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/
#             https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html#updating-coredns-add-on
#             
# Author: Justin Cook <jhcook@secnix.com>

set -o errexit
set -o xtrace

K8SV="$1"
DSHV="$2"

# A temporary directory for transient artefacts and ignored by Git
# Use trailing slash on path or leave nil
TMPDIR="/vagrant/tmp/"
test -d ${TMPDIR} || mkdir ${TMPDIR}

# Disable SELinux and swap
setenforce 0 || /bin/true
sed -i.orig 's|^SELINUX=.*|SELINUX=disabled|' /etc/selinux/config
swapoff -a
sed -i.orig 's|^/swapfile|#/swapfile|' /etc/fstab

# Install EPEL and Yum Utilities
yum install -y epel-release yum-utils

# Configure yum repositories
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
cat << '__EOF__' > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
__EOF__

# EKS 1.20+ uses containerd
yum install -y iproute-tc socat conntrack-tools docker-ce-cli docker-ce \
  containerd.io kubelet-${K8SV} kubeadm kubectl-${K8SV} \
  --disableexcludes=kubernetes

# We need to configure docker to use the same cgroup driver as Kubelet
test -d /etc/docker || mkdir /etc/docker
cat << __EOF__ > /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
__EOF__
systemctl enable --now docker

# Configure the kubelet
test -d /var/lib/kubelet || mkdir /var/lib/kubelet
cat << __EOF__ > /var/lib/kubelet/kubeadm-flags.env
KUBELET_KUBEADM_ARGS="--cgroup-driver=systemd --network-plugin=cni --pod-infra-container-image=public.ecr.aws/eks-distro/kubernetes/pause:3.4.1"
__EOF__
systemctl enable --now kubelet

# Download and tag the relevant images for the specific K8s version as
# kubeadm associates specific values.
docker pull \
  public.ecr.aws/eks-distro/kubernetes/pause:v1.21.2-eks-${DSHV}
docker pull \
  public.ecr.aws/eks-distro/coredns/coredns:v1.8.3-eks-${DSHV}
docker pull \
  public.ecr.aws/eks-distro/etcd-io/etcd:v3.4.16-eks-${DSHV}

docker tag \
  public.ecr.aws/eks-distro/kubernetes/pause:v1.21.2-eks-${DSHV} \
  public.ecr.aws/eks-distro/kubernetes/pause:3.4.1
docker tag \
  public.ecr.aws/eks-distro/coredns/coredns:v1.8.3-eks-${DSHV} \
  public.ecr.aws/eks-distro/kubernetes/coredns:v1.8.4
docker tag \
  public.ecr.aws/eks-distro/etcd-io/etcd:v3.4.16-eks-${DSHV} \
  public.ecr.aws/eks-distro/kubernetes/etcd:3.4.13-0

cat << __EOF__ > /etc/modules-load.d/k8s.conf
br_netfilter
__EOF__
cat << __EOF__ > /etc/sysctl.d/99-k8s.conf 
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
__EOF__

modprobe br_netfilter
sysctl -p /etc/sysctl.d/99-k8s.conf
firewall-cmd --zone=public --permanent --add-port=6443/tcp \
  --add-port=2379-2380/tcp --add-port=10250-10252/tcp

cat << __EOF__ >> /etc/hosts
10.0.2.15   centos8-vbox centos7-vbox.localdomain
__EOF__

# Configure and exexute kubeadm
cat << __EOF__ > ${TMPDIR}kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
clusterName: "eks-distro"
kubernetesVersion: "v${K8SV}-eks-${DSHV}"
imageRepository: public.ecr.aws/eks-distro/kubernetes
controlPlaneEndpoint: "10.0.2.15:6443"
apiServer:
  certSANs:
    - "localhost"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
__EOF__

# Build the cluster
kubeadm init --config ${TMPDIR}kubeadm-config.yaml

# Configure the client
mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf "$HOME"/.kube/config
mkdir ~vagrant/.kube && cp /etc/kubernetes/admin.conf ~vagrant/.kube/config && \
  chown -R "$(id -u vagrant)":"$(id -g vagrant)" ~vagrant/.kube
cp "$HOME"/.kube/config ${TMPDIR}eks-d.kubeconfig
sed -i 's|server:.*|server: https://localhost:6443|g' \
  ${TMPDIR}eks-d.kubeconfig

# Untaint master NoSchedule
kubectl taint nodes --all node-role.kubernetes.io/master-

# Install CNI
# https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
curl -L --silent --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}
# https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
/usr/local/bin/cilium install

# Patch coredns clusterrole
kubectl patch clusterrole system:coredns -n kube-system \
  --type='json' \
  -p='[{"op": "add", "path": "/rules/0", "value":{ "apiGroups": ["discovery.k8s.io"], "resources": ["endpointslices"], "verbs": ["list","watch"]}}]'