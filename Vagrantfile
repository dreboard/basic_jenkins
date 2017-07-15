# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.network "forwarded_port", guest: 80, host: 1234

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine for troubleshooting
    vb.gui = true
    vb.memory = "512"
  end

  config.push.define "staging", strategy: "ftp" do |push|
    push.host = "localhost:1234"
    push.username = "vagrant"
    push.password = "vagrant"
    push.destination = "./staging"
  end

  config.push.define "qa", strategy: "ftp" do |push|
    push.host = "localhost:1235"
    push.username = "vagrant"
    push.password = "vagrant"
    push.destination = "./vagrant"
  end

  #config.vm.provision "bootstrap", type: "shell", path: "./dev_ops/vagrant_conf/all_in_one.sh"

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get -y upgrade

    # install apache 2.5 and php 7
    sudo apt-get install -y apache2
    sudo a2enmod rewrite
    sudo cp /vagrant/dev_ops/apache/api.conf /etc/apache2/sites-available
    sudo a2ensite api

    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:ondrej/php

    sudo apt-get update

    echo -e "\n--- Install PHP ---\n"
    sudo apt-get install -y php7.1 php7.1-opcache php7.1-phpdbg php7.1-mbstring php7.1-cli php7.1-imap php7.1-ldap php7.1-pgsql php7.1-pspell php7.1-recode php7.1-snmp php7.1-tidy php7.1-dev php7.1-intl php7.1-gd php7.1-zip php7.1-xml php7.1-curl php7.1-json php7.1-mcrypt
    sudo apt-get install php7.1-intl php7.1-xsl
    sudo apt-get install -y php7.1-mysql

    echo -e "\n--- Installing Xdebug ---\n"
    sudo apt-get install -y php-xdebug

    sudo apt-get -y install curl git nano tofrodos
    sudo apt-get install snmp

    sudo apt-get -y install libapache2-mod-php7.1
    sudo apt-get -y autoremove
    #sudo service apache2 restart
  SHELL

  config.vm.provision "shell", inline: <<-SHELL2
  echo -e "\n------------------------------------------- Installing Composer\n"
  fromdos /vagrant/composer.sh
  curl -s https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
  cd /vagrant && php composer.phar install
  SHELL2

  config.vm.provision "bootstrap", type: "shell", path: "./dev_ops/vagrant_conf/run_always.sh", run: "always"

end