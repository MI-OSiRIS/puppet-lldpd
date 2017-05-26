class lldpd (
  $ensure              = $lldpd::params::ensure,
  $package_name        = $lldpd::params::package_name,
  $service_name        = $lldpd::params::service_name,
  $manage_repo         = $lldpd::params::manage_repo,
  $service_ensure      = $lldpd::params::service_ensure,
  $service_enable      = $lldpd::params::service_enable,
  $autoupgrade         = $lldpd::params::autoupgrade,
  $purge_configs       = $lldpd::params::purge_configs

) inherits lldpd::params {

  validate_bool($service_enable)
  validate_bool($manage_repo)
  validate_bool($purge_configs)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { $package_name :
    ensure  => $package_ensure,
  }

  service { $service_name :
    ensure     => $service_ensure_real,
    enable     => $service_enable_real,
    require    => Package[$package_name],
  }

  file { '/etc/lldpd.d':
    ensure  => directory,
    recurse => true,
    purge   => $purge_configs,
    force   => $purge_configs,
    require => Package[$package_name],
  }

  if $manage_repo {
    case $::osfamily {
      'RedHat': { 
          case $::operatingsystemmajrelease {
            '6','7': {
              yumrepo { "vbernat-home-rhel${::operatingsystemmajrelease}":
                descr     => "vbernat-lldpd-Rhel${::operatingsystemmajrelease}",
                baseurl   => $lldpd::params::repo_baseurl,
                gpgcheck  => 1,
                gpgkey    => $lldpd::params::repo_gpg,
                ensure    => $ensure,
                before    => Package[$package_name]
              }
            }
            default: { fail("Unsupported release, cannot manage repo") }
          }
        }
      #'Debian': { }
      #'Suse': { }
      default: {
        fail("Unsupported platform, cannot manage repo: ${::osfamily}")
      }
    }
  } 

}