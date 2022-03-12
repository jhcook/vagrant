# Ubuntu Multipass

This is a Ubuntu Focal instance configured with a Multipass Snap ready for use.

## Usage

```
$ vagrant up
...
$ vagrant ssh
...
vagrant@ubuntu-focal:~$ multipass launch -n test
vagrant@ubuntu-focal:~$ multipass shell test
...
ubuntu@test:~$
```

## Kubernetes

To install a Kubernetes cluster in Multipass, execute `k8s.sh` as follows:
* Please note timeouts are not necessarily an error as cloud-init will continue
to provision the host.
```
vagrant@ubuntu-focal:~$ sh /vagrant/k8s.sh
Launching control
Launching node1
Launching node2
Launching host1
Disabling oom-killer for 2841
Disabling oom-killer for 3312
Disabling oom-killer for 3896
Disabling oom-killer for 4438
```

## Calico

In order to install the Calico CNI, copy the `install_calico.sh` from
`/vagrant` to $HOME and then copy to host1.

```
vagrant@ubuntu-focal:~$ cp /vagrant/install_* .
vagrant@ubuntu-focal:~$ multipass transfer install_* host1:
```

Access host1 shell and execute `install_calico.sh`.

```
vagrant@ubuntu-focal:~$ multipass shell host1
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-104-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Mar 11 23:52:37 UTC 2022

  System load:  0.28              Processes:             103
  Usage of /:   33.9% of 4.67GB   Users logged in:       0
  Memory usage: 8%                IPv4 address for ens3: 198.19.15.254
  Swap usage:   0%                IPv4 address for ens3: 10.40.177.159


15 updates can be applied immediately.
3 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@host1:~$ sh install_calico.sh
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/imagesets.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/installations.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/tigerastatuses.operator.tigera.io created
namespace/tigera-operator created
podsecuritypolicy.policy/tigera-operator created
serviceaccount/tigera-operator created
clusterrole.rbac.authorization.k8s.io/tigera-operator created
clusterrolebinding.rbac.authorization.k8s.io/tigera-operator created
deployment.apps/tigera-operator created
Waiting for deployment spec update to be observed...
Waiting for deployment "tigera-operator" rollout to finish: 0 out of 1 new replicas have been updated...
Waiting for deployment "tigera-operator" rollout to finish: 0 of 1 updated replicas are available...
deployment "tigera-operator" successfully rolled out
installation.operator.tigera.io/default created
NAME     AVAILABLE   PROGRESSING   DEGRADED   SINCE
calico               True
Waiting for deployment "calico-kube-controllers" rollout to finish: 0 of 1 updated replicas are available...
NAMESPACE         NAME                                       READY   STATUS              RESTARTS   AGE
kube-system       helm-install-traefik-b4256                 0/1     Pending             0          27m
kube-system       local-path-provisioner-6d59f47c7-gnvwb     0/1     Pending             0          27m
kube-system       metrics-server-7566d596c8-m8qf4            0/1     Pending             0          27m
kube-system       coredns-7944c66d8d-vtpmh                   0/1     Pending             0          27m
tigera-operator   tigera-operator-5b6bb45b84-54xf9           1/1     Running             0          31s
calico-system     calico-typha-5c8845b6bf-jlsxn              0/1     ContainerCreating   0          11s
calico-system     calico-node-vl7q2                          0/1     Init:0/2            0          9s
calico-system     calico-node-wtmrg                          0/1     Init:0/2            0          9s
calico-system     calico-node-p4wk5                          0/1     Init:0/2            0          9s
calico-system     calico-kube-controllers-5ddc4b84bd-mfjdd   0/1     Pending             0          8s
calico-system     calico-typha-5c8845b6bf-sldvr              0/1     Pending             0          2s
calico-system     calico-typha-5c8845b6bf-68x8f              0/1     Pending             0          3s
calico-system     calico-typha-5c8845b6bf-sldvr              0/1     Pending             0          2s
calico-system     calico-typha-5c8845b6bf-68x8f              0/1     ContainerCreating   0          3s
calico-system     calico-typha-5c8845b6bf-sldvr              0/1     ContainerCreating   0          3s
Waiting for deployment "calico-kube-controllers" rollout to finish: 0 of 1 updated replicas are available...
calico-system     calico-node-p4wk5                          0/1     Init:0/2            0          26s
calico-system     calico-node-wtmrg                          0/1     Init:0/2            0          27s
calico-system     calico-node-p4wk5                          0/1     Init:1/2            0          28s
calico-system     calico-node-wtmrg                          0/1     Init:1/2            0          30s
calico-system     calico-node-vl7q2                          0/1     Init:0/2            0          30s
calico-system     calico-node-vl7q2                          0/1     Init:1/2            0          32s
calico-system     calico-typha-5c8845b6bf-jlsxn              0/1     Running             0          35s
calico-system     calico-typha-5c8845b6bf-68x8f              0/1     Running             0          31s
calico-system     calico-typha-5c8845b6bf-jlsxn              1/1     Running             0          45s
calico-system     calico-typha-5c8845b6bf-68x8f              1/1     Running             0          39s
calico-system     calico-typha-5c8845b6bf-sldvr              0/1     Running             0          48s
calico-system     calico-node-p4wk5                          0/1     Init:1/2            0          60s
calico-system     calico-typha-5c8845b6bf-sldvr              1/1     Running             0          53s
calico-system     calico-node-p4wk5                          0/1     PodInitializing     0          62s
calico-system     calico-node-wtmrg                          0/1     Init:1/2            0          63s
calico-system     calico-node-wtmrg                          0/1     PodInitializing     0          66s
kube-system       metrics-server-7566d596c8-m8qf4            0/1     Pending             0          28m
kube-system       local-path-provisioner-6d59f47c7-gnvwb     0/1     Pending             0          28m
kube-system       metrics-server-7566d596c8-m8qf4            0/1     ContainerCreating   0          28m
kube-system       local-path-provisioner-6d59f47c7-gnvwb     0/1     ContainerCreating   0          28m
calico-system     calico-kube-controllers-5ddc4b84bd-mfjdd   0/1     Pending             0          70s
calico-system     calico-kube-controllers-5ddc4b84bd-mfjdd   0/1     ContainerCreating   0          70s
calico-system     calico-node-vl7q2                          0/1     Init:1/2            0          79s
kube-system       helm-install-traefik-b4256                 0/1     Pending             0          28m
kube-system       coredns-7944c66d8d-vtpmh                   0/1     Pending             0          28m
kube-system       helm-install-traefik-b4256                 0/1     ContainerCreating   0          28m
kube-system       coredns-7944c66d8d-vtpmh                   0/1     ContainerCreating   0          28m
calico-system     calico-node-vl7q2                          0/1     PodInitializing     0          85s
calico-system     calico-node-p4wk5                          0/1     Running             0          2m2s
calico-system     calico-node-wtmrg                          0/1     Running             0          2m10s
kube-system       local-path-provisioner-6d59f47c7-gnvwb     0/1     ContainerCreating   0          29m
calico-system     calico-kube-controllers-5ddc4b84bd-mfjdd   0/1     ContainerCreating   0          2m19s
kube-system       helm-install-traefik-b4256                 0/1     ContainerCreating   0          29m
calico-system     calico-node-vl7q2                          0/1     Running             0          2m41s
kube-system       metrics-server-7566d596c8-m8qf4            0/1     ContainerCreating   0          29m
kube-system       coredns-7944c66d8d-vtpmh                   0/1     ContainerCreating   0          29m
calico-system     calico-node-p4wk5                          1/1     Running             0          2m49s
calico-system     calico-node-wtmrg                          1/1     Running             0          3m3s
calico-system     calico-node-vl7q2                          1/1     Running             0          3m18s
kube-system       local-path-provisioner-6d59f47c7-gnvwb     1/1     Running             0          30m
calico-system     calico-kube-controllers-5ddc4b84bd-mfjdd   0/1     Running             0          3m20s
calico-system     calico-kube-controllers-5ddc4b84bd-mfjdd   1/1     Running             0          3m26s
deployment "calico-kube-controllers" successfully rolled out
```

## Yao Bank

The Yao Bank application is used to test the operation of Kubernetes and is
installed with the `install_sampleapp.sh` script. 

```
ubuntu@host1:~$ sh install_sampleapp.sh
namespace/yaobank created
service/database created
serviceaccount/database created
deployment.apps/database created
service/summary created
serviceaccount/summary created
deployment.apps/summary created
service/customer created
serviceaccount/customer created
deployment.apps/customer created
Waiting for deployment spec update to be observed...
Waiting for deployment spec update to be observed...
Waiting for deployment "customer" rollout to finish: 0 out of 1 new replicas have been updated...
Waiting for deployment "customer" rollout to finish: 0 of 1 updated replicas are available...
deployment "customer" successfully rolled out
deployment "summary" successfully rolled out
deployment "database" successfully rolled out
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>YAO Bank</title>
    <style>
    h2 {
      font-family: Arial, Helvetica, sans-serif;
    }
    h1 {
      font-family: Arial, Helvetica, sans-serif;
    }
    p {
      font-family: Arial, Helvetica, sans-serif;
    }
    </style>
  </head>
  <body>
  	<h1>Welcome to YAO Bank</h1>
  	<h2>Name: Spike Curtis</h2>
  	<h2>Balance: 2389.45</h2>
  	<p><a href="/logout">Log Out >></a></p>
  </body>
</html>ubuntu@host1:~$
```

