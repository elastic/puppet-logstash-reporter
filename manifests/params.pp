# == Class: logstash_reporter::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elastic.co>
#
class logstash_reporter::params {

  if( $::is_pe == true ) {
    if ( $::osfamily == 'windows' ){
      $config_file = 'C:\\ProgramData\\PuppetLabs\\puppet\\etc\\logstash.yaml'
    } else {
      $config_file = '/etc/puppetlabs/puppet/logstash.yaml'
    }
    $config_owner = 'pe_puppet'
    $config_group = 'pe_puppet'
  } elsif versioncmp($::puppetversion, '4.0.0') >= 0 {
    if ( $::osfamily == 'windows' ){
      $config_file = 'C:\\ProgramData\\PuppetLabs\\puppet\\etc\\logstash.yaml'
    } else {
      $config_file = '/etc/puppetlabs/puppet/logstash.yaml'
    }
    $config_owner = 'puppet'
    $config_group = 'puppet'
  } else {
    if ( $::osfamily == 'windows' ){
      $config_file = 'C:\\ProgramData\\PuppetLabs\\puppet\\etc\\logstash.yaml'
    } else {
      $config_file = '/etc/puppet/logstash.yaml'
      $config_owner = 'puppet'
      $config_group = 'puppet'
    }
  }

}
