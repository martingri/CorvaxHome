import 'config'

class compiler-cron {
      cron { 'run_compiler':
        command => "php ${config::system_src}/src/public/index.php compile android --verbose >> /var/log/cron-mlab-compiler",
        user => $config::user,
        hour => '*',
        minute => '*/5',
      }

      file { '/var/log/cron-mlab-compiler':
        ensure => present,
        owner  => $config::user,
        group  => $config::user,
        force  => true
        ;
      }
}

include compiler-cron
