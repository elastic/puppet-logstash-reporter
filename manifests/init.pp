# == Class: logstash_reporter
#
# This class deploys and configures a puppet reporter to send reports to logstash
#
#
# === Parameters
#
# [*logstash_host*]
#   String.  Logstash host to write reports to
#   Default: 127.0.0.1
#
# [*logstash_port*]
#   Integer.  Port logstash is listening for tcp connections on
#   Default: 5999
#
# [*config_file*]
#   String.  Path to write the config file to
#   Default: /etc/(puppetlabs)/puppet/logstash.yaml
#
# [*user*]
#   String.  User to create file with
#   Default: Pulled from puppet master
#
# [*group*]
#   String.  Group to create file with
#   Default: Pulled from puppet master
#
#
# === Examples
#
# * Installation:
#     class { 'apache': }
#
#
# === Authors
#
# * John E. Vincent
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
class logstash_reporter (
  $logstash_host  = '127.0.0.1',
  $logstash_port  = 5999,
  $config_file    = "${confdir}/logstash.yaml",
  $user           = $::settings::user,
  $group          = $::settings::group,
){

  file { $config_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0444',
    content => template('logstash_reporter/logstash.yaml.erb'),
  }

}

