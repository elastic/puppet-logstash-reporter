puppet-logstash-report
======================

**WARNING**
This is currently untested. I'm in the process of rebuilding my puppet development environment.

Description
-----------

A Puppet report handler for sending logs, event and metrics to a Logstash TCP input.


Requirements
------------

* `json`
* `yaml`

A working logstash install with a defined `tcp` input matching the report configuration.

```
input { tcp { type => "puppet-report" port => "5959" } }
```

**NOTE**
This currently only works with logstash MASTER which has neccessary changes to the `json_event` format for inputs.
To install logstash from master:

* Make sure you have java + ant installed and on your PATH
* clone the repo from https://github.com/logstash/logstash
* run `make jar`
* Create a simple Logstash config like so (called logstash.conf):

```
input { tcp { type => "puppet-report" port => "5959" format => "json_event" } }
output { stdout { debug => true debug_format => "json" } }
```
* run logstash with the configuration file

```
java -jar build/logstash--monolithic.jar agent -f logstash.conf
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
Pretty much anything @jamrtur01 has ever written about or coded for Puppet
