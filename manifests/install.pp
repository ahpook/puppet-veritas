class veritas_infoscale::install (
	$responsefile = '/tmp/install.response',
	$install_script = undef,
	$prod = 'AVAILABILITY72',
	$keyless = 'AVAILABILITY',
	$systems =  [ $::hostname ], 

) {

	file { $responsefile:
		ensure => file,
		content => template('veritas_infoscale/install.response.erb'),
	}
	->
	exec { 'veritas_infoscale::install':
		command => "${install_script} -responsefile ${responsefile}",
		timeout => 0,
		logoutput => true,
		unless => '/usr/bin/test -e /opt/VRTS/install/installer',
	}

}
