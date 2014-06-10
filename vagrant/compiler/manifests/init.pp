import 'config'

class init {
  exec { 'apt-get update':
      command => '/usr/bin/apt-get update'
  }

  file { "${config::setup_src_folder}/bin/zipped":
      ensure => "directory",
      ;
  }
 
}

include init
