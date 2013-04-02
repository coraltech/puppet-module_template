# Class: module_template
#
#   Basic Puppet module template built on the Coral framework.
#
#   This module provides a starter module for developing Coral compatible Puppet
#   modules.  It is minimal but it should still function out of the box.
#
#   See:
#
#   http://github.com/coraltech/puppet-coral.git
#
#
#   Adrian Webb <adrian.webb@coraltech.net>
#   2013-04-02
#
#   Tested platforms:
#    - Ubuntu 12.04
#
#
# Parameters: (see <examples/params.json> for Hiera configurations)
#
#
# Actions:
#
#   - ??
#
#
# Requires:
#
#   coraltech/coral
#
#
# Sample Usage:
#
#   include module_template
#
#      or
#
#   class { 'module_template':
#     ...
#   }
#
class module_template (

  $build_package_names  = $module_template::params::build_package_names,
  $common_package_names = $module_template::params::common_package_names,
  $package_ensure       = $module_template::params::package_ensure,
  $config_file          = $module_template::params::config_file,
  $config_template      = $module_template::params::config_template,
  $configurations       = {},
  $service_name         = $module_template::params::service_name,
  $service_ensure       = $module_template::params::service_ensure

) inherits module_template::params {

  $base_name         = 'module'
  $config_port_var   = 'port'
  $firewall_priority = '200'

  $config = render(normalize($module_template::params::configurations, $configurations))

  #-----------------------------------------------------------------------------
  # Installation

  coral::packages { $base_name:
    resources => {
      'build-packages' => {
        name => $build_package_names
      },
      'common-packages' => {
        name    => $common_package_names,
        require => 'build-packages'
      }
    },
    defaults  => [
      { ensure => $package_ensure },
      "${base_name}::package_defaults"
    ]
  }

  #-----------------------------------------------------------------------------
  # Configuration

  coral::files { $base_name:
    resources => {
      "${base_name}" => {
        path    => $config_file,
        content => template($config_template)
      }
    },
    require => Coral::Packages[$base_name]
  }

  coral::repos { $base_name:
    resources => {},
    require   => Coral::Files[$base_name]
  }

  coral::firewall { $base_name:
    resources => {
      module_template => {
        name   => value($config[$config_port_var]) ? {
          false   => '',
          default => "${firewall_priority} INPUT Allow new Module_template connections"
        },
        chain  => 'INPUT',
        state  => 'NEW',
        proto  => 'tcp',
        action => 'accept',
        dport  => $config[$config_port_var]
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $base_name:
    resources => {}
  }

  #-----------------------------------------------------------------------------
  # Services

  coral::services { $base_name:
    resources => {
      "${base_name}" => {
        service => $service_name,
        ensure  => $service_ensure
      }
    },
    require => [ Coral::Repos[$base_name], Coral::Firewall[$base_name] ]
  }

  coral::cron { $base_name:
    resources => {},
    require   => Coral::Services[$base_name]
  }

  #-----------------------------------------------------------------------------
  # Resources


}
