#!/bin/bash
cp /MLab-Base/vagrant/mlab-base/packages/phpMyAdmin-latest.tar.gz /home/vagrant/phpMyAdmin-latest.tar.gz
cd /home/vagrant/
tar xzf phpMyAdmin-latest.tar.gz
mv phpMyAdmin-4.0.4.1-english phpmyadmin
sudo cp /MLab-Base/vagrant/mlab-base/manifests/files/php-admin.virtual-host /etc/apache2/sites-available/phpmyadmin
cp /MLab-Base/vagrant/mlab-base/manifests/files/php-admin.config.inc.php /home/vagrant/phpmyadmin/config.inc.php
cd /etc/apache2/sites-available/
sudo a2ensite phpmyadmin
sudo sed -i '$ a\Listen 8080' /etc/apache2/ports.conf
sudo service apache2 restart