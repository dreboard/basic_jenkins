#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
# variables
DBNAME='development'
PASSWORD='1234'
PROJECTFOLDER='./'
PROJECTNAME='my_dev'
DBUSER='root'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 7
sudo apt-get install -y apache2

##########################################################
#				Install PHP
##########################################################
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php

sudo apt-get update

echo -e "\n--- Install PHP ---\n"
sudo apt-get install -y php7.1 php7.1-opcache php7.1-phpdbg php7.1-mbstring php7.1-cli php7.1-imap php7.1-ldap php7.1-pgsql php7.1-pspell php7.1-recode php7.1-snmp php7.1-tidy php7.1-dev php7.1-intl php7.1-gd php7.1-zip php7.1-xml php7.1-curl php7.1-json php7.1-mcrypt
sudo apt-get install php7.1-intl php7.1-xsl
sudo apt-get install -y php7.1-mysql

##########################################################
#				Install Xdebug
##########################################################
echo -e "\n--- Installing Xdebug ---\n"
sudo apt-get install -y php-xdebug
cat << EOF | sudo tee -a /etc/php/7.0/cli/conf.d/xdebug.ini
zend_extension="/usr/lib/php/20160303/xdebug.so"
xdebug.remote_enable=on
xdebug.remote_connect_back=on
EOF

##########################################################
#				Apache Vhosts
##########################################################

# create project folder
sudo chmod -R 755 /var/www
sudo mkdir "/var/www/$PROJECTNAME"
sudo mkdir "/var/www/$PROJECTNAME/logs"
sudo mkdir "/var/www/$PROJECTNAME/logs/apache"
sudo mkdir "/var/www/$PROJECTNAME/logs/php"
# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName $PROJECTNAME.dev
    DocumentRoot /var/www/$PROJECTNAME/public
    ErrorLog /var/www/$PROJECTNAME/logs/apache/apache.error.log
    CustomLog /var/www/$PROJECTNAME/logs/apache/apache.access.log common
    php_flag log_errors on
    php_flag display_errors on
    php_value error_reporting 2147483647
    php_value error_log /var/www/$PROJECTNAME/logs/php/php.error.log
   <Directory "/var/www/$PROJECTNAME">
        AllowOverride All
        Require all granted
   </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$PROJECTNAME.conf

echo "${VHOST}" | sudo tee /etc/apache2/sites-available/$PROJECTNAME.conf

sudo a2ensite $PROJECTNAME.conf

# enable mod_rewrite
sudo a2enmod rewrite

##########################################################
#				Install Extras
##########################################################

sudo apt-get -y install curl git nano
sudo apt-get install snmp

# restart apache
sudo apt-get -y install libapache2-mod-php7.1
sudo a2dismod php5
sudo a2enmod php7.1

sudo apt-get -y autoremove

#service apache2 restart

# install Composer
echo "------------------------------------------ Installing Composer"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
