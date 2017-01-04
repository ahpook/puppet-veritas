node drivernode {
    class { 'veritas_infoscale::patch_upgrade':
		install_script => '/root/patch/installVRTSvxfen710P100',
		patch_version => '7.1.0.100',
		patch => 'VRTSvxfen',
		systems => [ 'rhel65-only-1', 'rhel65-only-2' ],
    }
}
