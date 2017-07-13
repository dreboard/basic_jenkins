# -*- mode: ruby -*-
# vi: set ft=ruby :

config_fqdn = 'jenkins.example.dev'
config_ip   = '10.10.10.100'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8090
  config.vm.network :private_network, ip: config_ip
  config.vm.provision :shell, inline: "echo '#{config_ip} #{config_fqdn}' | Out-File -Encoding ASCII -Append c:/Windows/System32/drivers/etc/hosts"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine for troubleshooting
    #vb.gui = true
    vb.memory = "512"
  end

  config.vm.synced_folder "./", "/var/www/my_dev", owner: "root", group: "root"
  config.vm.provision "bootstrap", type: "shell", path: "./dev_ops/vagrant_conf/all_in_one.sh"
  config.vm.provision "bootstrap", type: "shell", path: "./dev_ops/vagrant_conf/run_always.sh", run: "always"

end