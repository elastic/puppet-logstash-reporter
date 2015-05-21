puppet-logstash\_reporter
=========================

Description
-----------

A Puppet report handler for sending logs, event and metrics to a Logstash TCP input.


Requirements
------------

* `json`
* `yaml`

A working logstash install with a defined `tcp` input matching the report configuration.

```
input {
  tcp {
    type => "puppet-report"
    port => 5999
    codec => json
  }
}
```

**NOTE**
* Create a simple Logstash config like so (called logstash.conf):

```
input {
  tcp {
    type => "puppet-report"
    port => 5999
    codec => json
  }
}

output {
  stdout {
    codec => rubydebug
  }
}
```
* run logstash with the configuration file

```
bin/logstash agent -f logstash.conf
```

* Follow the installation instructions below, changing host to the host where logstash is running and port to match the port you defined in your Logstash configuration file.

* Profit?

Installation and Usage
----------------------

1. Define a TCP input as described above in your Logstash configuration file
2. Copy the `logstash.yaml` to `/etc/puppet`
3. Enable pluginsync and reports on your puppetmaster and clients in `puppet.conf`

```
[master]
report = true
reports = logstash
pluginsync = true
[agent]
report = true
pluginsync = true
```

4. Run the Puppet client and sync the report as a plugin

Credits
-------
This module was originally posted John Vincent at https://github.com/lusis/puppet-logstash-reporter
