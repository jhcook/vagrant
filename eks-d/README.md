# EKS-D

This is a Vagrant box currently using CentOS8 that provisions [EKS Distro](https://aws.amazon.com/eks/eks-distro/).

## Usage

Ensure Virtualbox and Vagrant are installed. Install the [Vagrant Reload](https://github.com/aidanns/vagrant-reload) plugin.
Clone this repo to your favourite directory, `cd vagrant/eks-d`, and issue
`vagrant up`. Several minutes later, hopefully, you will see the tail end which
indicates the box is successfully provisioned:
```
...
    default: + cat
    default: + kubectl apply -f /vagrant/tmp/eks-admin-service-account.yaml
    default: serviceaccount/eks-admin created
    default: Warning: rbac.authorization.k8s.io/v1beta1 ClusterRoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRoleBinding
    default: clusterrolebinding.rbac.authorization.k8s.io/eks-admin created
```

## EKS

You are now free to use `kubectl` as normal using the KUBECONFIG file --
`eks-d.kubeconfig` -- available in the `tmp` directory. 

```
$ export KUBECONFIG=$(pwd)/tmp/eks-d.kubeconfig 
$ kubectl get po -A
NAMESPACE              NAME                                                  READY   STATUS    RESTARTS   AGE
kube-system            cilium-operator-8dd4dc946-szz4z                       1/1     Running   0          3m41s
kube-system            cilium-vcmjz                                          1/1     Running   0          3m41s
kube-system            coredns-6f99cf666b-kl7n7                              1/1     Running   0          3m41s
kube-system            coredns-6f99cf666b-l2fdr                              1/1     Running   0          3m41s
kube-system            etcd-centos8-vagrant.localdomain                      1/1     Running   1          3m46s
kube-system            kube-apiserver-centos8-vagrant.localdomain            1/1     Running   1          3m46s
kube-system            kube-controller-manager-centos8-vagrant.localdomain   1/1     Running   1          3m46s
kube-system            kube-proxy-ssf8l                                      1/1     Running   0          3m41s
kube-system            kube-scheduler-centos8-vagrant.localdomain            1/1     Running   1          3m46s
kube-system            metrics-server-559f9dc594-fbnw6                       1/1     Running   0          81s
kubernetes-dashboard   dashboard-metrics-scraper-856586f554-qs7jw            1/1     Running   0          50s
kubernetes-dashboard   kubernetes-dashboard-7979bc45d5-c622k                 1/1     Running   0          50s
kyverno                kyverno-5964b65f77-7p8ql                              1/1     Running   0          102s
traefik                traefik-676b85dd4d-td72p                              1/1     Running   0          105s
```

## Kubernetes Dashboard

The Kubernetes Dashboard is installed and ready for use. Simply follow [the instructions in step three](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html)
to connect.

```
$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
Name:         eks-admin-token-6jp5z
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: eks-admin
              kubernetes.io/service-account.uid: 6863326e-bf7d-4262-a5b5-8d403021376b

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1099 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6InpmQlpsSGtZeVFYc0lHOTYyRnNRcWxudXc4ZkJqckV4czc4T2FfNEFQd2cifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJla3MtYWRtaW4tdG9rZW4tNmpwNXoiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZWtzLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNjg2MzMyNmUtYmY3ZC00MjYyLWE1YjUtOGQ0MDMwMjEzNzZiIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmVrcy1hZG1pbiJ9.jSRLA4GS3TmKNgAPQ6-fpoRt2nbUeMqVuEm8yY9Ox1LkGcZ6JkIF7B_HEdbfGurKeAlFPSfFHBCwtz5oh4cew_pXpPnW3xEwXw24_cAEOjWDb2e_263C100j40wk_yi2IccWL4FNuzucKnMyk9BQPCCio5C-q8GL9nOjAyip9Zqkq6noI5QYMGoRoQC36yZHNtG0AMbQL9-Wnj1TCoGG_rTqFEdYWg2M8Hfl6iQQpKvaRH1-cq4_Oa53XZjOG-IdJ9ONxSTm5Bj6EbS-ByMRE0DDsD7Q3oolae_UMGEPABumUaWikHhSLyE8XmBXwoubwA5ibZ8J1RnuDUrcaD0ULw
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

Open a browser and connect to [the dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login) and enter the token provided above using token authentication. 

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