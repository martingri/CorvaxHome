import 'config'
import 'install-mysql'

class load_database_0_1 {
    # Todo: Make database a variable
  exec {'create_database':
    command => "/usr/bin/mysql -uroot -e \"create database ${config::database} CHARACTER SET utf8 COLLATE utf8_general_ci;\"",
    require => Package["mysql-server"],
    unless => "/usr/bin/mysql -uroot ${config::database}", # The database already exists
  }

  exec {'build_database_0_1':
    command => "/usr/bin/mysql -uroot ${config::database} < ${config::system_src}/scripts/install/0.1/create.sql",
    require => Exec["create_database"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep user"
  }
}
include load_database_0_1

class load_database_0_2 {
  exec {'build_database_0_2':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/scripts/install/0.2/create.sql",
    require => Exec["build_database_0_1"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep watchdog"
  }
}
include load_database_0_2

class load_database_0_3 {

  exec {'build_database_0_3':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/scripts/install/0.3/create.sql",
    require => Exec["build_database_0_2"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep user_role"
  }
  
}
include load_database_0_3

class load_database_0_4 {

  exec {'build_database_0_4':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/scripts/install/0.4/create.sql",
    require => Exec["build_database_0_3"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep user_group"
  }
  
}
include load_database_0_4

class load_database_0_5 {

  exec {'alter_database_0_5':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/scripts/install/0.5/alter.sql",
    require => Exec["build_database_0_4"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"desc user_group\" | grep state" 
  }
  
  exec {'update_database_0_5':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/scripts/install/0.5/update.sql",
    require => Exec["alter_database_0_5"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select max(state) from user_group\" | grep 1"
  }

}
include load_database_0_5

class load_database_0_6 {

}


class load_database_0_7 {

  exec {'alter_database_0_7':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/scripts/install/0.7/alter.sql",
    require => Exec["update_database_0_5"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"desc user_group\" | grep is_default" 
  }
  
  exec {'update_database_0_7':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/scripts/install/0.7/update.sql",
    require => Exec["alter_database_0_7"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select group_id from user_group\" | grep 1"
  }

  exec {'build_builder_database':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Builder/scripts/0.7/install/schema.mysql.sql",
    require => Exec["update_database_0_7"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep builder_application"
  }

  exec {'alter_builder_application':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Builder/scripts/0.7/update/alter_application.sql",
    require => Exec["build_builder_database"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"desc builder_application\" | grep name | grep -v application_name"
  }

  exec {'alter_builder_template':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Builder/scripts/0.7/update/alter_template.sql",
    require => Exec["build_builder_database"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"desc builder_template\" | grep name | grep -v template_name"
  }
  
  exec {'build_market_application':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Market/scripts/0.7/install/market_application.sql",
    require => Exec["update_database_0_7"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep market_application"
  }

  exec {'build_market_rating':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Market/scripts/0.7/install/market_rating.sql",
    require => Exec["update_database_0_7"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep market_rating"
  }

  exec {'build_market_comment':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Market/scripts/0.7/install/market_comments.sql",
    require => Exec["update_database_0_7"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"show tables\" | grep market_comment"
  }

  exec {'alter_market_application':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Market/scripts/0.7/update/market_application.sql",
    require => Exec["build_market_application"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"desc market_application\" | grep main_image" 
  }

  exec {'alter_market_application_2':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Market/scripts/0.7/update/market_application_2.sql",
    require => Exec["alter_market_application"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"desc market_application\" | grep download" 
  }

  exec {'alter_market_application_3':
    command => "/usr/bin/mysql -uroot  ${config::database} < ${config::system_src}/src/module/Market/scripts/0.7/update/market_application_3.sql",
    require => Exec["alter_market_application_2"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"desc market_application\" | grep update_date"
  }  
  
}
include load_database_0_7

class load_database_0_8 {
        exec {'market_install_0_8':
    command => "/bin/cat ${config::system_src}/src/module/Market/scripts/0.8/install/*.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["alter_market_application_3"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select name from system_version\" | grep 0.8"
  }  
 
  exec {'market_update_0_8':
    command => "/bin/cat ${config::system_src}/src/module/Market/scripts/0.8/update/*.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["market_install_0_8"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select name from system_version\" | grep 0.8"
  } 

  exec {'base_install_0_8':
    command => "/bin/cat ${config::system_src}/scripts/install/0.8/create.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["market_install_0_8"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select name from system_version\" | grep 0.8"
  }  
 
  exec {'base_update_0_8':
    command => "/bin/cat ${config::system_src}/scripts/install/0.8/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_install_0_8"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select name from system_version\" | grep 0.8"
  } 

}
include load_database_0_8

class load_database_0_9 {

  exec {'market_install_0_9':
    command => "/bin/cat ${config::system_src}/src/module/Market/scripts/0.9/install/*.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_8"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select max(name) from system_version\" | grep 0.9"
  }  
 
  exec {'market_update_0_9':
    command => "/bin/cat ${config::system_src}/src/module/Market/scripts/0.9/update/*.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["market_install_0_9"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select max(name) from system_version\" | grep 0.9"
  }

  exec {'base_update_0_9':
    command => "/bin/cat ${config::system_src}/scripts/install/0.9/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["market_update_0_9"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e \"select max(name) from system_version\" | grep 0.9"
  } 


      
}
include load_database_0_9

class load_database_0_10 {

  exec {'base_update_0_10':
    command => "/bin/cat ${config::system_src}/scripts/install/0.10/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_9"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.10"
  } 


      
}
include load_database_0_10

class load_database_0_11 {

  exec {'base_update_0_11':
    command => "/bin/cat ${config::system_src}/scripts/install/0.11/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_10"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.11"
  } 


      
}
include load_database_0_11

class load_database_0_12 {

  exec {'market_update_0_12':
    command => "/bin/cat ${config::system_src}/src/module/Market/scripts/0.12/update/market_application_dates.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_11"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.12"
  } 
      
  exec {'base_update_0_12':
    command => "/bin/cat ${config::system_src}/scripts/install/0.12/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["market_update_0_12"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.12"
  } 
      
}
include load_database_0_12

class load_database_0_13 {

  exec {'base_update_0_13':
    command => "/bin/cat ${config::system_src}/scripts/install/0.13/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_12"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.13"
  } 
      
}
include load_database_0_13


class load_database_0_14 {

  exec {'market_install_0_14':
    command => "/bin/cat ${config::system_src}/src/module/Market/scripts/0.14/install/* | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_13"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.14"
  }
 
  exec {'base_update_0_14':
    command => "/bin/cat ${config::system_src}/scripts/install/0.14/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["market_install_0_14"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.14"
  } 
      
}
include load_database_0_14

class load_database_0_15 {

  exec {'base_update_0_15':
    command => "/bin/cat ${config::system_src}/scripts/install/0.15/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_14"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.15"
  } 
      
}
include load_database_0_15

class load_database_0_16 {

  exec {'base_update_0_16':
    command => "/bin/cat ${config::system_src}/scripts/install/0.16/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_15"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.16"
  } 
      
}
include load_database_0_16

class load_database_0_17 {

  exec {'base_create_0_17':
    command => "/bin/cat ${config::system_src}/scripts/install/0.17/create.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_update_0_16"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.17"
  }
 
  exec {'base_update_0_17':
    command => "/bin/cat ${config::system_src}/scripts/install/0.17/bump-version.sql | /usr/bin/mysql -uroot  ${config::database}",
    require => Exec["base_create_0_17"],
    unless => "/usr/bin/mysql -uroot ${config::database} -e 'select name from system_version' | grep 0.17"
  } 
      
}
include load_database_0_17

