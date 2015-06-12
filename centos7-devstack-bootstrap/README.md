centos7-devstack-bootstrap
==========================

This is a Vagrant box that implements a single Openstack Devstack machine you can see here:

http://docs.openstack.org/developer/devstack/guides/single-machine.html

Before you run this, you need to add a 'devstack' network in Virtualbox of 10.2.3.0/24.

This is named bootstrap; because, it takes a minimal CentOS7 guest in Virtualbox and builds
the entire stack from git clone to end. All you have to do is `vagrant init jhcook/centos7-devstack-bootstrap`, `vagrant up` and then open your browser to http://localhost:8080.

Upon successful completion of the provisioning, you should see this:

```bash
==> default: This is your host ip: 10.0.2.15
==> default: Horizon is now available at http://10.0.2.15/
==> default: Keystone is serving at http://10.0.2.15:5000/
==> default: The default users are: admin and demo
==> default: The password: admin
==> default: ++ systemctl stop iptables.service
==> default: ++ systemctl disable iptables.service
==> default: rm '/etc/systemd/system/basic.target.wants/iptables.service'
==> default: ++ systemctl enable mariadb
==> default: ln -s '/usr/lib/systemd/system/mariadb.service' '/etc/systemd/system/multi-user.target.wants/mariadb.service'
==> default: ++ systemctl enable httpd
==> default: ln -s '/usr/lib/systemd/system/httpd.service' '/etc/systemd/system/multi-user.target.wants/httpd.service'
==> default: ++ systemctl enable rabbitmq-server
==> default: ln -s '/usr/lib/systemd/system/rabbitmq-server.service' '/etc/systemd/system/multi-user.target.wants/rabbitmq-server.service'
==> default: ++ systemctl enable tgtd
==> default: ln -s '/usr/lib/systemd/system/tgtd.service' '/etc/systemd/system/multi-user.target.wants/tgtd.service'
==> default: ++ grep -q SELINUX=enforcing /etc/selinux/config
==> default: ++ sed -i s/SELINUX=enforcing/SELINUX=permissive/ /etc/selinux/config
```
