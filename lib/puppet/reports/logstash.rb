require 'puppet'
require 'socket'
require 'timeout'
require 'json'
require 'yaml'

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
end

def process

  self.logs.each do |log|
    event = Hash.new
    event["@source"] = "puppet://#{self.host}/#{log.source}"
    event["@source_path"] = "#{log.file}" || __FILE__
    event["@source_host"] = self.host
    event["@tags"] = ["puppet-#{self.kind}"]
    event["@tags"] << log.tags if log.tags
    event["@fields"] = Hash.new
    event["@fields"]["environment"] = self.environment
    event["@fields"]["report_format"] = self.report_format
    event["@fields"]["puppet_version"] = self.puppet_version
    event["@fields"]["status"] = self.status
    event["@fields"]["start_time"] = log.time
    event["@fields"]["end_time"] = Time.now
    event["@fields"]["severity"] = log.level
    event["@fileds"]["metrics"] = metrics || {}
    event["@message"] = log.message
    begin
      Timeout::timeout(CONFIG[:timeout]) do
        json = event.to_json
        ls = TCPSocket.new "#{CONFIG[:host]}" , CONFIG[:port]
        ls.puts json
        ls.close
      end
    rescue Exception => e
      Puppet::Error("Failed to write to #{CONFIG[:host]} on port #{CONFIG[:port]}: #{e.message}")
    end
  end
end
