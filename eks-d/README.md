# EKS-D

This is a Vagrant box currently using CentOS8 that provisions [EKS Distro](https://aws.amazon.com/eks/eks-distro/).

## Usage

Ensure Virtualbox and Vagrant are installed. Install the [Vagrant Reload](https://github.com/aidanns/vagrant-reload) plugin.
Copy the `Vagrantfile` to your favourite directory and issue a `vagrant up`.
Several minutes later, you will see something like the following which means
the box has been successfully completed:

```
    default: ✅ Cilium was successfully installed! Run 'cilium status' to view installation health
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
    default: /vagrant => /Users/jcook/play/vagrant/eks-d
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.
```

## EKS

You are now free to use `kubectl` as normal using the `eks-d.kubeconfig` file
you will now see in your favourite directory. 

```
$ kubectl get po -A
NAMESPACE     NAME                                                  READY   STATUS    RESTARTS   AGE
kube-system   cilium-29mh2                                          1/1     Running   0          2m35s
kube-system   cilium-operator-8dd4dc946-6bcg7                       1/1     Running   0          2m35s
kube-system   coredns-c45d95c94-fwxv8                               0/1     Running   0          2m35s
kube-system   coredns-c45d95c94-k7x9z                               0/1     Running   0          2m35s
kube-system   etcd-centos8-vagrant.localdomain                      1/1     Running   1          3m48s
kube-system   kube-apiserver-centos8-vagrant.localdomain            1/1     Running   1          3m48s
kube-system   kube-controller-manager-centos8-vagrant.localdomain   1/1     Running   1          3m48s
kube-system   kube-proxy-7swg6                                      1/1     Running   0          2m35s
kube-system   kube-scheduler-centos8-vagrant.localdomain            1/1     Running   1          3m49s
$ kubectl get ns
NAME              STATUS   AGE
default           Active   4m25s
kube-node-lease   Active   4m25s
kube-public       Active   4m25s
kube-system       Active   4m25s
```