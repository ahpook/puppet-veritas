class veritas_infoscale::upgrade (
	$responsefile = '/tmp/upgrade.response',
	$install_script = undef,
	$systems =  [ $::hostname ], 
	$target_version = '',
) {
	if ( $::veritas_packages['VRTSsfcpi'] =~ $target_version ) {
		$upgraded = 1
	} else {
		$upgraded = 0
	}

	file { $responsefile:
		ensure => file,
		content => template('veritas_infoscale/upgrade.response.erb'),
	}
	->
	exec { 'veritas_infoscale::upgrade':
		command => "${install_script} -responsefile ${responsefile}",
		timeout => 0,
		logoutput => true,
		onlyif => "/usr/bin/test ${upgraded} -eq 0 ",
	}

}
