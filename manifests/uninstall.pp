class veritas_infoscale::uninstall (
	$responsefile = '/tmp/uninstall.response',
	$install_script = '/opt/VRTS/install/installer',
	$prod = 'AVAILABILITY72',
	$systems =  [ $::hostname ], 
) {

	file { $responsefile:
		ensure => file,
		content => template('veritas_infoscale/uninstall.response.erb'),
	}
	->
	exec { 'veritas_infoscale::uninstall':
		command => "${install_script} -responsefile ${responsefile}",
		timeout => 0,
		logoutput => true,
		onlyif => '/usr/bin/test -f /opt/VRTS/install/installer',
	}

}
