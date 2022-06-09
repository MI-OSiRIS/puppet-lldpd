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
      $repo_baseurl = "http://download.opensuse.org/repositories/home:/vbernat/CentOS_$::operatingsystemmajrelease/"
      $repo_gpg =     "http://download.opensuse.org/repositories/home:/vbernat/CentOS_$::operatingsystemmajrelease/repodata/repomd.xml.key"
    }

    'Debian': { }
    'Suse': { }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
