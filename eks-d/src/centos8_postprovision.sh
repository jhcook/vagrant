#!/usr/bin/env bash
# 
# Configure a minimal CentOS8 host to run EKS Distro
#
# References: https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
#             https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
#
# Author: Justin Cook <jhcook@secnix.com>

set -o errexit
set -o xtrace

TMPDIR="/vagrant/tmp/"

# Wait for CoreDNS
kubectl wait --for=condition=available --timeout=600s deployment/coredns -n kube-system

# Install Traefik
kubectl create ns traefik
/usr/local/bin/helm install traefik --namespace=traefik traefik/traefik
kubectl wait --for=condition=available --timeout=600s deployment/traefik -n traefik

# Install Kyverno
kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/release-1.5/definitions/release/install.yaml
kubectl wait --for=condition=available --timeout=600s deployment/kyverno -n kyverno

# Install Kubernetes metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deploy metrics-server -n kube-system \
  --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
kubectl delete po -n kube-system -l=k8s-app=metrics-server
kubectl wait --for=condition=available --timeout=600s deployment/metrics-server -n kube-system

# Deploy the Kubernetes dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
cat << __EOF__ > ${TMPDIR}eks-admin-service-account.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system
__EOF__
kubectl apply -f ${TMPDIR}eks-admin-service-account.yaml