node drivernode {
    class { 'veritas_infoscale::upgrade':
        systems => [ 'rhel6u6-n1', 'rhel6u6-n2' ],
		target_version => '7.2',
        install_script => '/mnt/release_train/linux/7.2/LxRT-7.2-2016-05-20a/dvd1-redhatlinux/rhel6_x86_64/installer',
    }
}
