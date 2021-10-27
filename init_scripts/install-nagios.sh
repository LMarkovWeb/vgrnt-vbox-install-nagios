#!/usr/bin/bash

# @see: https://linuxhint.com/install_nagios_ubuntu/

# vars
NAGIOS_USER=nagiosadmin
NAGIOS_PASS=nagios

#Install

echo '--- [STEP 1]: Update and upgrade'
apt update && apt upgrade -y

echo '--- [STEP 2]: Install packages'
apt install -y build-essential apache2 php openssl \
               perl make php-gd libgd-dev libapache2-mod-php libperl-dev \
               libssl-dev daemon wget apache2-utils unzip

echo '--- [STEP 3]: ADD USERS AND GROUPS'
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd www-data


echo '--- [STEP 4]: Compile Nagios with Ubuntu 20.04'
cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.5.tar.gz
tar -zxvf /tmp/nagios-4.4.5.tar.gz
cd /tmp/nagios-4.4.5/
./configure --with-nagios-group=nagios --with-command-group=nagcmd --with-httpd_conf=/etc/apache2/sites-enabled/
make all
make install
make install-init
make install-config
make install-commandmode

echo '--- [STEP 5]: Update your email address'
# gedit /usr/local/nagios/etc/objects/contacts.cfg
# email     nagios@localhost ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******

echo '--- [STEP 6]: Fire up the web interface installer'
make install-webconf
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users $NAGIOS_USER $NAGIOS_PASS
a2enmod cgi
systemctl restart apache2

echo '--- [STEP 7]: Install Nagios Plugins'
cd /tmp
wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
tar -zxvf /tmp/nagios-plugins-2.3.3.tar.gz
cd /tmp/nagios-plugins-2.3.3/
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install

echo '--- [STEP 8]: Using Nagios on Ubuntu'
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
systemctl enable nagios
systemctl start nagios

echo '--- [STEP 9]: Get to know the web interface'
echo "Go to http://192.168.10.40/nagios/ "


 