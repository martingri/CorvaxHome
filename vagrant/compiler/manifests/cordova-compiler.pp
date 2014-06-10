import 'config'
import 'androidSDK'

class cordova-install {

 exec {'download-cordova-src':
    command => "/usr/bin/curl https://archive.apache.org/dist/cordova/cordova-${config::cordovaVersion}-src.zip -o ${config::setup_src_folder}/bin/zipped/cordova-${config::cordovaVersion}-src.zip",
    creates => "${config::setup_src_folder}/bin/zipped/cordova-${config::cordovaVersion}-src.zip",
    timeout => 2200,
    require => File["${config::setup_src_folder}/bin/zipped"]
  }

  exec { 'unpack-cordova':
       require => Exec["download-cordova-src"],
       creates => "${config::setup_src_folder}/bin/cordova-${config::cordovaVersion}",
       command => "/usr/bin/unzip ${config::setup_src_folder}/bin/zipped/cordova-${config::cordovaVersion}-src.zip -d ${config::setup_src_folder}/bin",
  }

  exec { 'unpack-cordova-android':
       require => Exec["unpack-cordova"],
       creates => "${config::setup_src_folder}/bin/cordova-${config::cordovaVersion}/android-library",
       command => "/usr/bin/unzip ${config::setup_src_folder}/bin/cordova-${config::cordovaVersion}/cordova-android.zip -d ${config::setup_src_folder}/bin/cordova-${config::cordovaVersion}/android-library",
  }

}

include cordova-install
