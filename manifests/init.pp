class logstash_reporter (
  $logstash_host  = '127.0.0.1',
  $logstash_port  = '5999',
  $config_file  = '/etc/puppet/logstash.yaml',
){

  file { $config_file:
    ensure  => file,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0440',
    content => template('logstash_reporter/logstash.yaml.erb'),
  }

}

