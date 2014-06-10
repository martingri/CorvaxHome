import 'init'

class mysql {
  package { "mysql-server":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package { "php5-mysql":
    ensure => present,
    require => Exec["apt-get update"],
  }

}

include mysql