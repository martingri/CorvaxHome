import 'config'

class distribute-cron {
      cron { 'distribute':
        command => "php ${config::system_src}/src/public/index.php distribute --verbose >> /var/log/cron-mlab-distribute",
        user => $config::user,
        hour => '*',
        minute => '*/5',
      }

      file { '/var/log/cron-mlab-distribute':
        ensure => present,
        owner  => $config::user,
        group  => $config::user,
        force  => true
        ;
      }
}

include distribute-cron