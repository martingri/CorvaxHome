import 'config'

class setup_compiler_folders {
  file { "${config::app_working_folder}/compiled":
      ensure => "directory",
      ;
      "${config::app_working_folder}/queue":
      ensure => "directory",
      ;
      "${config::app_working_folder}/compiler-working":
      ensure => "directory",
      ;
      "${config::app_working_folder}/compiler-working/working":
      ensure => "directory",
      ;
      "${config::app_working_folder}/compiler-working/trash":
      ensure => "directory",
      ;
      "${config::app_working_folder}/compiler-working/error":
      ensure => "directory",
      ;
  }
}
include setup_compiler_folders

class config_compiler {
  file {"${config::system_src}/src/module/Compiler/config/compiler.local.php":
       ensure => file,
       owner  => $config::user,
       group  => $config::user,
       content=> template("${config::setup_src_folder}/manifests/files/compiler.local.php.erb"),
       ;
  }
}


include config_compiler