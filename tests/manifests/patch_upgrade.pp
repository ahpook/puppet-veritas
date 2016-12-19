class veritas_infoscale::patch_upgrade (
	$responsefile = '/tmp/patch_upgrade.response',
	$install_script = undef,
	$systems =  [ $::hostname ], 
	$patch_version = '',
	$patch = ''
) {
	if ( $::veritas_packages[$patch] =~ $patch_version ) {
		$upgraded = 1
	} else {
		$upgraded = 0
	}

	file { $responsefile:
		ensure => file,
		content => template('veritas_infoscale/patch_upgrade.response.erb'),
	}
	->
	exec { 'veritas_infoscale::upgrade':
		command => "${install_script} -responsefile ${responsefile}",
		timeout => 0,
		logoutput => true,
		onlyif => "/usr/bin/test ${upgraded} -eq 0 ",
	}

}
