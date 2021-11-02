# EKS-D

This is a Vagrant box currently using CentOS8 that provisions [EKS Distro](https://aws.amazon.com/eks/eks-distro/).

## Usage

Ensure Virtualbox and Vagrant are installed. Install the [Vagrant Reload](https://github.com/aidanns/vagrant-reload) plugin.
Clone this repo to your favourite directory, `cd vagrant/eks-d`, and issue
`vagrant up`. Several minutes later, hopefully, you will see the tail end which
indicates the box is successfully provisioned:
```
...
    default: ⌛ Waiting for Cilium to be installed and ready...
    default: ✅ Cilium was successfully installed! Run 'cilium status' to view installation health
    default: + kubectl patch clusterrole system:coredns -n kube-system --type=json '-p=[{"op": "add", "path": "/rules/0", "value":{ "apiGroups": ["discovery.k8s.io"], "resources": ["endpointslices"], "verbs": ["list","watch"]}}]'
    default: clusterrole.rbac.authorization.k8s.io/system:coredns patched
==> default: Running provisioner: reload...
==> default: Attempting graceful shutdown of VM...
==> default: Checking if box 'jhcook/centos8' version '4.18.0.305.12.1' is up to date...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 6443 (guest) => 6443 (host) (adapter 1)
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /Users/jcook/repo/vagrant/eks-d
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.
```

## EKS

You are now free to use `kubectl` as normal using the KUBECONFIG file --
`eks-d.kubeconfig` -- available in the `tmp` directory. 

```
$ export KUBECONFIG=$(pwd)/tmp/eks-d.kubeconfig 
$ kubectl get po -A
NAMESPACE     NAME                                                  READY   STATUS    RESTARTS   AGE
kube-system   cilium-42l5q                                          1/1     Running   1          3m34s
kube-system   cilium-operator-8dd4dc946-9mj87                       1/1     Running   1          3m34s
kube-system   coredns-6f99cf666b-8qpwz                              1/1     Running   1          3m34s
kube-system   coredns-6f99cf666b-ckb6h                              1/1     Running   1          3m34s
kube-system   etcd-centos8-vagrant.localdomain                      1/1     Running   1          3m38s
kube-system   kube-apiserver-centos8-vagrant.localdomain            1/1     Running   1          3m38s
kube-system   kube-controller-manager-centos8-vagrant.localdomain   1/1     Running   1          3m38s
kube-system   kube-proxy-7kmb5                                      1/1     Running   1          3m34s
kube-system   kube-scheduler-centos8-vagrant.localdomain            1/1     Running   1          3m41s
$ kubectl get ns
NAME              STATUS   AGE
default           Active   3m47s
kube-node-lease   Active   3m48s
kube-public       Active   3m48s
kube-system       Active   3m48s
```

## Cilium

Cilium provides the CNI in this cluster. 

```
$ vagrant ssh
[vagrant@centos8-vagrant ~]$ cilium status
    /¯¯\
 /¯¯\__/¯¯\    Cilium:         OK
 \__/¯¯\__/    Operator:       OK
 /¯¯\__/¯¯\    Hubble:         disabled
 \__/¯¯\__/    ClusterMesh:    disabled
    \__/

DaemonSet         cilium             Desired: 1, Ready: 1/1, Available: 1/1
Deployment        cilium-operator    Desired: 1, Ready: 1/1, Available: 1/1
Containers:       cilium             Running: 1
                  cilium-operator    Running: 1
Cluster Pods:     2/2 managed by Cilium
Image versions    cilium             quay.io/cilium/cilium:v1.10.5: 1
                  cilium-operator    quay.io/cilium/operator-generic:v1.10.5: 1
```