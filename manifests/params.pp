
class module_template::params {

  $package_ensure     = 'present'
  $service_ensure     = 'running'

  #---

  case $::operatingsystem {
    #debian, ubuntu: {

    #}
    #centos, redhat, fedora, scientific: {

    #}
    default: {
      $build_package_names  = []
      $common_package_names = []
      $extra_package_names  = []

      $env_file             = '/etc/profile.d/module_template.sh'
      $env_template         = 'module_template/environment.erb'
      $variables            = {}

      $config_file          = ''
      $config_template      = 'module_template/config.erb'
      $configurations       = { port => false }

      $service_name         = ''

      #fail("The module_template module is not currently supported on ${::operatingsystem}")
    }
  }
}
