# RHEL8 Snap

This box uses a RHEL8 minimal build and installs Snap, Libvirt, QEMU, and
associated utilities for Multipass. It enables nested virtualization in
Virtualbox. You are then able to install images for use locally. 

One needs a Red Hat login to use this box. Otherwise the provision will
fail.

```
$ vagrant up
Vagrant has detected project local plugins configured for this
project which are not installed.

  vagrant-registration
Install local plugins (Y/N) [N]: Y
Installing the 'vagrant-registration' plugin. This can take a few minutes...
Fetching vagrant-registration-1.3.4.gem
Installed the plugin 'vagrant-registration (1.3.4)'!


Vagrant has completed installing local plugins for the current Vagrant
project directory. Please run the requested command again.

...

Vagrant is currently configured to create VirtualBox synced folders with
the `SharedFoldersEnableSymlinksCreate` option enabled. If the Vagrant
guest is not trusted, you may want to disable this option. For more
information on this option, please refer to the VirtualBox manual:

  https://www.virtualbox.org/manual/ch04.html#sharedfolders

This option can be disabled globally with an environment variable:

  VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

or on a per folder basis within the Vagrantfile:

  config.vm.synced_folder '/host/path', '/guest/path', SharedFoldersEnableSymlinksCreate: false
```
