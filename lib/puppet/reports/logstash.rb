require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'puppet'
require 'socket'
require 'timeout'
require 'json'
require 'yaml'
require 'time'

unless Puppet.version >= '2.6.5'
  fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:logstash) do

  config_file = File.join([File.dirname(Puppet.settings[:config]), "logstash.yaml"])
  unless File.exist?(config_file)
    raise(Puppet::ParseError, "Logstash report config file #{config_file} missing or not readable")
  end
  CONFIG = YAML.load_file(config_file)

  desc <<-DESCRIPTION
  Reports status of Puppet Runs to a Logstash TCP input
  DESCRIPTION

  def process

    # Push all log lines as a single message
    logs = []
    self.logs.each do |log|
      logs << log
    end

    event = Hash.new
    event["@fields"] = Hash.new
    event["@source"] = "puppet://#{self.host}"
    event["@source_path"] = 'puppet'
    event["@source_host"] = self.host
    event["@timestamp"] = Time.now.utc.iso8601
    event["@tags"] = ["puppet-#{self.kind}"]
    event["@message"] = "Puppet run on #{self.host} #{self.status}"
    event["@fields"]["logs"] = logs
    event["@fields"]["environment"] = self.environment
    event["@fields"]["report_format"] = self.report_format
    event["@fields"]["puppet_version"] = self.puppet_version
    event["@fields"]["status"] = self.status
    event["@fields"]["start_time"] = self.logs.first.time
    event["@fields"]["end_time"] = self.logs.last.time
    event["@fields"]["metrics"] = {}
    metrics.each do |k,v|
      event["@fields"]["metrics"][k] = {}
      v.values.each do |val|
        event["@fields"]["metrics"][k][val[1]] = val[2]
      end
    end

    begin
      Timeout::timeout(CONFIG[:timeout]) do
        json = event.to_json
        ls = TCPSocket.new "#{CONFIG[:host]}" , CONFIG[:port]
        ls.puts json
        ls.close
      end
    rescue Exception => e
      Puppet.err("Failed to write to #{CONFIG[:host]} on port #{CONFIG[:port]}: #{e.message}")
    end
  end
end
