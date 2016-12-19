node drivernode { 
   class{ 'veritas_infoscale::install':
       prod => 'ENTERPRISE72',
       keyless => 'ENTERPRISE',
       install_script => '/net/release/re/release_train/sol/7.2/SxRT-7.2-2016-07-08a/dvd2-sol_x64/sol11_x64/installer',
   }
   ->
   class{ 'veritas_infoscale::configure':
       prod => 'ENTERPRISE72',
       activecomponent =>  'VCS72',
       clustername       => 'cluster1',
       systems => [ 'sol11u3-n1', 'sol11u3-n2' ],
       keyless => 'ENTERPRISE',
       install_script => '/opt/VRTS/install/installer',
       heartbeat_links   => [ 'net1', 'net2' ],
       lopri_link        => 'net0',
   }
	     
}

node /clients/ { 
	class{ 'veritas_infoscale::install':
		prod => 'ENTERPRISE72',
		keyless => 'ENTERPRISE',
		install_script => '/net/release/re/release_train/sol/7.2/SxRT-7.2-2016-07-08a/dvd2-sol_x64/sol11_x64/installer',
	}
}
