class php_myadmin_install {
  Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin:/MLab-Base/vagrant/mlab-base/scripts/' }
  exec {'setup_php_admin':
    command => "sh /MLab-Base/vagrant/mlab-base/scripts/install-phpmyadmin.sh",
    require => Service["apache2"],
    unless => "ls /home/vagrant/phpmyadmin/"
  }
}
include php_myadmin_install