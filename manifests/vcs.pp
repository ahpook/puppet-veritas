class veritas_infoscale::configure (
	$responsefile =		'/tmp/configure.response',
	$install_script =	'/opt/VRTS/install/installer',
	$prod =				'AVAILABILITY72',
	$activecomponent =	'VCS72',
	$keyless =			'AVAILABILITY',
	$lltoverudp =		'0',
	$smtprsev =			undef,
	$allowcomms =		'1',
	$eat_security =		'1',
	$systems =			[ $::hostname ],
	$heartbeat_links =	[],
	$lopri_link =		'',
	$clusterid =		undef,
	$clustername,
	$csgnetmask =      undef,
	$csgnic =          undef,
	$csgvip =          undef,
	$smtprecp =        undef,
	$smtpserver =      undef,
	$eat_security_fips = undef,
	$gconetmask =      undef,
	$gconic =          undef,
	$gcovip =          undef,
	$securegco =       undef,
	$smtpserv =        undef,
	$snmpcons =        undef,
	$snmpcsev =        undef,
	$snmpport =        undef,
	$userenpw =        undef,
	$username =        undef,
	$userpriv =        undef,

) {

	file { $responsefile:
		ensure => file,
		content => template('veritas_infoscale/configure.response.erb'),
	}
	->
	exec { 'veritas_infoscale::configure':
		command => "${install_script} -responsefile ${responsefile}",
		timeout => 0,
		logoutput => true,
		unless => '/opt/VRTS/bin/hastatus -sum',
	}

}
