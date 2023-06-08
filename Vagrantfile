# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "generic/rhel8"

    if Vagrant.has_plugin?('vagrant-registration')
      config.registration.username = ENV['rhn_username']
      config.registration.password = ENV['rhn_password']
      config.registration.auto_attach = true
      config.registration.force = true
    end

    # https://github.com/dotless-de/vagrant-vbguest
    config.vbguest.auto_update = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 8192
        v.cpus = 2
    end

    #config.vm.provision "file", source: "cls_prerequisites.yaml", destination: "cls_prerequisites.yaml"
    #config.vm.provision "file", source: "cls_postinstall.yaml", destination: "cls_postinstall.yaml"
    #config.vm.provision "file", source: "nagiosls-install.sh", destination: "nagiosls-install.sh"

    config.vm.provision "shell", inline: <<-SHELL
        echo "root:vagrant" | chpasswd
        sed -i '/^session    optional     pam_motd\.so/s/^/#/' /etc/pam.d/sshd
        sed -i 's/^#PrintLastLog yes$/PrintLastLog no/' /etc/ssh/sshd_config
        systemctl restart sshd
        timedatectl set-timezone UTC
        cat << __EOF__ >> /etc/hosts
192.168.123.211\tmaster
192.168.123.212\tmaster2
192.168.123.213\tmaster3
192.168.123.221\tnode1
192.168.123.222\tnode2
192.168.123.223\tnode3
__EOF__
    SHELL

    config.vm.define "master" do |master|
        master.vm.hostname = "master"
        master.vm.network "private_network", ip: "192.168.123.211"
        master.vm.network "forwarded_port", guest: 80, host: 8081
        master.vm.provision "shell", path: "bootstrap_cls.sh"
    end

    config.vm.define "master2" do |master|
        #master.vm.box = "nagiosls-rhel8"
        master.vm.hostname = "master2"
        master.vm.network "private_network", ip: "192.168.123.212"
        master.vm.network "forwarded_port", guest: 80, host: 8082
        master.vm.provision "shell", path: "bootstrap_cls.sh"
    end

    # config.vm.define "master3" do |master|
    #     master.vm.box = "nagiosls-rhel8"
    #     master.vm.hostname = "master3"
    #     master.vm.network "private_network", ip: "192.168.123.213"
    #     master.vm.network "forwarded_port", guest: 80, host: 8083
    #     master.vm.provision "shell", path: "bootstrap_cls.sh"
    # end

    config.vm.define "node1" do |node1|
        node1.vm.hostname = "node1"
        node1.vm.network "private_network", ip: "192.168.123.221"
    end

    # config.vm.define "node2" do |node2|
    #     node2.vm.hostname = "node2"
    #     node2.vm.network "private_network", ip: "192.168.123.222"
    # end

    # config.vm.define "node3" do |node3|
    #     node3.vm.hostname = "node3"
    #     node3.vm.network "private_network", ip: "192.168.123.223"
    # end
end
