This is a post-build box of centos7-devstack-bootstrap. In order to use, perform the following:

```bash
$ vagrant init jhcook/centos7-devstack
$ vagrant up
=> default: Box 'jhcook/centos7-devstack' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'jhcook/centos7-devstack'
    default: URL: https://atlas.hashicorp.com/jhcook/centos7-devstack
==> default: Adding box 'jhcook/centos7-devstack' (v2015.06.16) for provider: virtualbox
    default: Downloading: https://atlas.hashicorp.com/jhcook/boxes/centos7-devstack/versions/2015.06.16/providers/virtualbox.box
==> default: Successfully added box 'jhcook/centos7-devstack' (v2015.06.16) for 'virtualbox'!
==> default: Importing base box 'jhcook/centos7-devstack'...
...
$ vagrant ssh
Last login: Tue Jun 16 17:14:13 2015 from 10.0.2.2
[vagrant@centos7-devstack ~]$ sudo su - stack
[stack@centos7-devstack ~]$ cd devstack/
[stack@centos7-devstack devstack]$ ./rejoin-stack.sh
```
