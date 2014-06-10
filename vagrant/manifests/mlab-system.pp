import 'config'
import 'apache2'

class mlab_packages {

  package { "php5-intl":
      ensure => present,
  } 

}

include mlab_packages

class config_mlab {
  file {"${config::system_src}/src/config/autoload/local.php":
       ensure => file,
       owner  => $config::user,
       group  => $config::user,
       content=> template("${config::setup_src_folder}/manifests/files/local.php.erb"),
       ;"${config::system_src}/src/config/autoload/mlabcore.local.php":
       ensure => file,
       owner  => $config::user,
       group  => $config::user,
       content=> template("${config::setup_src_folder}/manifests/files/mlabcore.local.php.erb"),
       ;

  }
}
include config_mlab

class apache2_config {
  file {"/etc/apache2/sites-available/${config::system_name}":
       ensure => file,
       content=> template("${config::setup_src_folder}/manifests/files/mlab-base.virtual-server.erb"),
       require => Package["apache2"],
       ;
   }
   file {"/etc/apache2/sites-enabled/001-${config::system_name}":
       ensure => link,
       target => "/etc/apache2/sites-available/${config::system_name}",
       force  => true,
       require => File["/etc/apache2/sites-available/${config::system_name}"]
       ;
  }

}
include apache2_config


class setup_mlab_folders {
  file { "${config::working_folder}/compiled":
      ensure => "directory",
      ;
      "${config::working_folder}/queue":
      ensure => "directory",
      ;
      "${config::working_folder}/working":
      ensure => "directory",
      ;
      "${config::working_folder}/trash":
      ensure => "directory",
      ;
      "${config::working_folder}/market-queue":
      ensure => "directory",
      ;
      "${config::working_folder}/market-queue/queue":
      ensure => "directory",
      ;
      "${config::working_folder}/market-queue/error":
      ensure => "directory",
      ;
      "${config::working_folder}/market-queue/trash":
      ensure => "directory",
      ;
      "${config::working_folder}/market-repository":
      ensure => "directory",
      ;
      "${config::system_src}/src/module/Builder/public/temp":
      ensure => "directory",
      ;    
      "${config::working_folder}/compile-queue":
      ensure => "directory",
      ;    
  }
}

include setup_mlab_folders
