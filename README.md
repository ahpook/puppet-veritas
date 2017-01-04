# Veritas InfoScale

## Overview

This module is to support installation, configuration, Upgrade and Uninstall for Veritas InfoScale products.


## Module Description

This module is to support the following function for Veritas InfoScale products:

1. Install, configure, Upgrade and Uninstall the following Veritas InfoScale products:
    * Enterprise
    * Storage
    * Availability
    * Foundation
2. Support Puppet facter to discover the InfoScale product objects on the systems, like:
    * Veritas licenses
    * VxVM disks,disk groups,volumes
    * VxFS file systems
    * VCS resources and service groups.


## Usage

### Deploy Veritas InfoScale product from Puppet server to managed hosts

1. Create one site.pp following the examples under veritas_infoscale/examples/

2. Wait about half an hour, the client systems will automatically deploy InfoScale Enterprise with the puppet manifest file.

Or run the following command on client systems directly to immediately deploy InfoScale Enterprise:

```puppet
    # puppet agent -t
```

### Examples ###

The details of examples can refer to derectory veritas_infoscale/examples.

#### Install InfoScale Enterprise ####

```puppet
class{ 'veritas_infoscale::install':
   prod => 'ENTERPRISE72',
   keyless => 'ENTERPRISE',
   install_script => '/mnt/infoscale_image/dvd2-sol_x64/sol11_x64/installer',
}   
```

#### Configure InfoScale Enterprise with VCS component ####

```puppet
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
````


### Discover Veritas InfoScale product objects

1. Run the following command to discover all system facters including Veritas InfoScale objects:

```puppet
    # puppet facts
```
 
2. Run the following command to discover Veritas InfoScale objects respectively:

For example:

To check Veritas Licenses

```puppet
    # facter -p veritas_licenses
```
 
To check Veritas VxVM disks, disk groups, volumes

```puppet
    # facter -p veritas_vxvm_disks
    # facter -p veritas_vxvm_diskgroups
```

To check Veritas VxFS file sytems, mounts

```puppet
    # facter -p veritas_vxfs_filesystems
```

To check Veritas VCS resources and service groups

```puppet
    # facter -p veritas_vcs_cluster
```

To check Veritas CFS cluster status

```puppet
    # facter -p veritas_cfs_cluster
```

## Reference

This infoscale module support the following native Puppet facts:

    * veritas_licenses
    * veritas_vxvm_disks
    * veritas_vxvm_diskgroups
    * veritas_vxfs_filesystems
    * veritas_vcs_cluster
    * veritas_cfs_cluster
	* veritas_packages


## Limitations

Currently, puppet resource types and providers to manipulate service groups, volumes, licenses are not supported.
