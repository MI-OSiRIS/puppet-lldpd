class lldpd::params {

  $ensure ='present'
  $package_name = 'lldpd'
  $service_ensure = 'running'
  $service_name = 'lldpd'
  $autoupgrade = true
  $service_enable = true
  $manage_repo = true
  $purge_configs = false
   
  case $::osfamily {

    'RedHat': {
      case $::operatingsystemmajrelease {
        '7': {
          $repo_baseurl = 'http://download.opensuse.org/repositories/home:/vbernat/RHEL_7/'
          $repo_gpg = 'http://download.opensuse.org/repositories/home:/vbernat/RHEL_7//repodata/repomd.xml.key'
        }
        '6': {
          $repo_baseurl = 'http://download.opensuse.org/repositories/home:/vbernat/RedHat_RHEL-6/'
          $repo_gpg = 'http://download.opensuse.org/repositories/home:/vbernat/RedHat_RHEL-6//repodata/repomd.xml.key'
        }
      }
    }

    'Debian': { }
    'Suse': { }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}