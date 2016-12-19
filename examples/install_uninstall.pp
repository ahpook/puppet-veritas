node /^nodes/ {
	class{ 'veritas_infoscale::install':
		prod => 'ENTERPRISE72',
		keyless => 'ENTERPRISE',
		install_script => '/net/release/re/release_train/sol/7.2/SxRT-7.2-2016-07-08a/dvd2-sol_x64/sol11_x64/installer',
	}
	->
	class{ 'veritas_infoscale::uninstall':
		prod => 'ENTERPRISE72',
		install_script => '/opt/VRTS/install/installer',
	}
}

