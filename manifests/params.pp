
class module_template::params {

  $package_ensure     = 'present'
  $service_ensure     = 'running'

  #---

  case $::operatingsystem {
    debian, ubuntu: {

    }
    default: {
      $common_package_names = []
      $build_package_names  = []

      $config_file          = ''
      $config_template      = 'module_template/config.erb'
      $configurations       = { port => false }

      $service_name         = ''
    }
  }
}
