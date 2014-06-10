import 'config'

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

