define lldpd::config 
(
	$config = "${name}",
	$order = 10,
	$ensure = 'present'

){

	validate_string($config)
	validate_numeric($order)
	validate_re($ensure, ['^present$', '^absent$'] )

	$filename =  regsubst($name, ' ', '_', 'G')

	file { "/etc/lldpd.d/${order}_${filename}.conf":
		content => "$config\n",  # newline is important, will not work without it
		ensure => $ensure,
		notify => Service["$lldpd::service_name"]
	}

}