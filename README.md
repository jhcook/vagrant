These are my Vagrant files such as Vagrantfile, provisioning scripts and other
associated files. At this time the following are present:

- rhel8-snap
This uses RHEL8 to create a box with nested virtualization and snap on board
with multipass. It works well for a mini Kubernetes cluster or prototyping.

- centos7-devstack-bootstrap  
This is a box that is a minimal CentOS7 installation that in provision installs
GIT, clones Devstack and then builds. This should be used for anything needing
a fresh clone and build automated.

- centos7-devstack  
This is a box that is a minimal CentOS7 installation with GIT, cloned Devstack
repository and post build. This should be used in order to get up and running
quickly. 
