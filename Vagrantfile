# -*- mode: ruby -*-
# vi: set ft=ruby :

class FixGuestAdditions < VagrantVbguest::Installers::Linux
    def install(opts=nil, &block)
        communicate.sudo("yum install -y gcc binutils make perl bzip2 http://mirror.centos.org/centos/7.8.2003/updates/x86_64/Packages/kernel-headers-3.10.0-1127.19.1.el7.x86_64.rpm http://mirror.centos.org/centos/7.8.2003/updates/x86_64/Packages/kernel-devel-3.10.0-1127.19.1.el7.x86_64.rpm", opts, &block)
        super
    end
end

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vbguest.installer = FixGuestAdditions

#  config.vm.provision "ansible" do |ansible|
#    ansible.verbose = "vvv"
#    ansible.playbook = "playbook.yml"
#    ansible.become = "true"
#  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 256
    v.cpus = 1
  end
  config.vm.define "kerberos" do |nfss|
    nfss.vm.network "private_network", ip: "192.168.50.12", virtualbox__intnet: "net1"
    nfss.vm.hostname = "kerberos"
    nfss.vm.provision "shell", path: "kerberos_script.sh"
  end

  config.vm.define "nfss" do |nfss|
    nfss.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: "net1"
    nfss.vm.hostname = "nfss"
    nfss.vm.provision "shell", path: "nfss_script.sh"
  end

  config.vm.define "nfsc" do |nfsc|
    nfsc.vm.network "private_network", ip: "192.168.50.11", virtualbox__intnet: "net1"
    nfsc.vm.hostname = "nfsc"
    nfsc.vm.provision "shell", path: "nfsc_script.sh"
  end
  


end
