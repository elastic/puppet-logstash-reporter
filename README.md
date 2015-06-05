#Logstash Reporter Puppet module

####Table of Contents

1. [Overview](#overview)
2. [Module description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with the Logstash Reporter](#setup)
  * [The module manages the following](#the-module-manages-the-following)
  * [Requirements](#requirements)
4. [Usage - Configuration options and additional functionality](#usage)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Support - When you need help with this module](#support)
9. [Credits](#credits)



##Overview

This module manages the Logstash reporter which sends puppet reports to Logstash ( http://www.elasticsearch.org/overview/logstash/ )

##Module description

The logstash_reporter module sets up and configures the reporter

##Setup

###The module manages the following

* reporter configuration file.

###Requirements

* `json`
* `yaml`
* Master puppet.conf needs to use the logstash reporter. 
```
[master]
report = true
reports = logstash
pluginsync = true
```
* Agent puppet.conf needs to send the reports to master. 
```
[agent]
report = true
pluginsync = true
```

##Usage

###Main class

####Basic usesage

```puppet
class { 'logstash_reporter':
}
```

And have a TCP input configured in logstash

```
input {
  tcp {
    type => "puppet-report"
    port => 5999
    codec => json
  }
}
```

####Separate logstash host and port

```puppet
class { 'logstash_reporter':
  logstash_host => '123.123.123.123',
  logstash_port => 1234,
}
```

##Limitations

This module has been built on and tested against Puppet 3.2 and higher.

The module has been tested on:

* Debian 6/7/8
* CentOS 6/7
* Ubuntu 12.04, 14.04
* OpenSuSE 13.x

Other distro's that have been reported to work:

* RHEL 6
* OracleLinux 6
* Scientific 6

Testing on other platforms has been light and cannot be guaranteed.

##Development

##Support

Need help? Join us in [#logstash](https://webchat.freenode.net?channels=%23logstash) on Freenode IRC or go to our [Discuss](http://discuss.elastic.co/) groups

##Credits

This module was originally posted by John Vincent at https://github.com/lusis/puppet-logstash-reporter
