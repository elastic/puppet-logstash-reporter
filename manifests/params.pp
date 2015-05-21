# Class logstash_reporter::params
#
# Default parameters for logstash_reporter module
#
class logstash_reporter::params {

  if $::is_pe {
    $config_file = '/etc/puppetlabs/puppet/logstash.yaml'
    $config_owner = 'pe_puppet'
    $config_group = 'pe_puppet'
  } elsif versioncmp('4.0.0', $::puppetversion) < 1 {
    $config_file = '/etc/puppetlabs/puppet/logstash.yaml'
    $config_owner = 'puppet'
    $config_group = 'puppet'
  } else {
    $config_file = '/etc/puppet/logstash.yaml'
    $config_owner = 'puppet'
    $config_group = 'puppet'
  }

}