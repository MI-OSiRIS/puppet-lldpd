<h1> puppet-lldpd</h1>

<p>
	Puppet module to manage lldp implementation by Vincent Bernat:  http://vincentbernat.github.io/lldpd/
</p>

<b>Class params with defaults:</b>

`$ensure = 'present'`
  
`$package_name = 'lldpd'`

`$service_ensure = 'running'`
 
`$service_name = 'lldpd'`
  
`$autoupgrade = true`

Package ensure present or latest
  
`$service_enable = true`

`$manage_repo = true`   
  
Define package repository.  Currently only supports RHEL 6/7 yum repo.  Other repos available at http://software.opensuse.org/download.html?project=home:vbernat&package=lldpd

`$purge_configs = false`
  
Purge configuration files from /etc/lldpd.d.  Does not purge /etc/lldpd.conf (packages also do not install this config file).

<b>Defined types with params:</b>

`lldpd::config`   
	
Resource defining config files placed in /etc/lldpd.d containing snippets that will be passed to lldpcli at startup.  Snippet can be either name of resource or config param.  Filename will be set from the resource name with spaces replaced by underscore.  

lldpd::config takes the following params:

`$config = ${name}` 

Snippet to be put into file, defaults to resource name.

`$order = 10`

Order prefixed to each filename.

`$ensure = 'present'`

<p>Example usage:</p>

<pre>
class { 'lldpd':
	purge_configs => true
}

lldpd::config { 'hostname':
	config => "configure system hostname 'specialsnowflake.example.com'"
}
</pre>

Results in file /etc/lldpd.d/10_hostname.conf with contents of config param.  At every startup lldpd will execute: lldpcli configure system hostname 'specialsnowflake.example.com'</pre> 
