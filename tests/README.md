# Veritas InfoScale

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Install Puppet from PuppetLabs](#install-puppet-from-puppetlabs)
    * [Install puppet modules for Veritas InfoScale product](#install-puppet-modules-for-veritas-infoscale-product)
4. [Usage](#usage)
    * [Deploy Veritas InfoScale product from Puppet server to managed hosts](#install-and-configure-veritas-infoscale-product-from-puppet-server-to-managed-hosts)
    * [Discover Veritas InfoScale product objects](#discover-veritas-infoscale-product-objects)
5. [Reference](#reference)
6. [Limitations](#limitations)

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


## Setup

### Install Puppet from PuppetLabs

Follow the following documents to install Puppet server from PuppetLabs repository:

<http://docs.puppetlabs.com/puppetserver/2.4/install_from_packages.html>


### Install puppet modules for Veritas InfoScale product

1. Download the Veritas InfoScale puppet module
2. Run the following commands to copy this module to Puppet directory:

```puppet
    # cp -r veritas_infoscale /etc/puppetlabs/code/environments/production/modules
```

## Usage

### Deploy Veritas InfoScale product from Puppet server to managed hosts

1. cd /etc/puppetlabs/code/environments/production/manifests/

2. Create one site.pp following the examples under veritas_infoscale/examples/

3. Wait about half an hour, the client systems will automatically deploy InfoScale Enterprise with the puppet manifest file.

Or run the following command on client systems directly to immediately deploy InfoScale Enterprise:

```puppet
    # puppet agent -t
```


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


## Limitations

Currently, puppet resource types and providers to manipulate service groups, volumes, licenses are not supported.
