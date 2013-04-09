# puppet-accounts

####Table of Contents

0. [Changelog](#changelog)
1. [Module Description - What does the module do?](#module-description)
2. [Setup - The basics of getting started with puppet-accounts](#setup)
3. [Usage - Configuration and customization options](#usage)
4. [Reference - An under-the-hood peek at what the module is doing](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Tests - Testing your configuration](#tests)

##Changelog

##Module Description

The puppet-accounts module lets you manage user accounts with Puppet.

##Setup

The puppet-accounts module requires:
* [puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) module.
* [pluginsync enabled](http://docs.puppetlabs.com/guides/plugins_in_modules.html#enabling-pluginsync).
* valid [yaml file](https://github.com/nagas/puppet-accounts/blob/master/files/users_example.yaml) containing user accounts information

##Usage

Since the puppet-accounts module needs to know the location of the users yaml file, you cannot use Include-like class declaration. This will not work:
```puppet
include accounts
```
Instead you need to use Resource-like declaration:
```puppet
class {'accounts':
  users_yaml => '/path/to/users.yaml',
}
```
Available parameters are:
* `purge` - use its with care. When set to `true` (default: `no`), it will remove all users that are not managed by Puppet.
* `skip_sys_users` - only has effect when used with `purge => true` (default: `yes`). It keeps system users from being purged. By default, it does not purge users whose UIDs are less than or equal to 500, but you can specify a different UID as the inclusive limit.

```puppet
class {'accounts':
  users_yaml => '/path/to/users.yaml',
  purge => true,
  skip_sys_users => 1500,
}
```
This will remove all users that aren't managed by Puppet and whose UID is greater than 1500.

##Reference

coming soon

##Limitations

Please note that the module was tested only on RedHat family operating systems.

##Development

1. Fork it
2. Clone it to your development environment (`git clone https://github.com/nagas/puppet-accounts`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a Pull Request

###Testing

coming soon 
