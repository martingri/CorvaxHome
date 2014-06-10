# Basic Puppet PHP manifest
import 'init'

class php {
  package { "php5-cli":
    ensure => present,
    require => Exec["apt-get update"],
  }
}

include php