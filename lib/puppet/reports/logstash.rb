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

SEPARATOR = [Regexp.escape(File::SEPARATOR.to_s), Regexp.escape(File::ALT_SEPARATOR.to_s)].join

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

    validate_host(self.host)
    
    event = Hash.new
    event["host"] = self.host
    event["@timestamp"] = Time.now.utc.iso8601
    event["logs"] = logs_to_array(self.logs)
    event["metrics"] = {}
    metrics.each do |k,v|
      event["metrics"][k] = {}
      v.values.each do |val|
        event["metrics"][k][val[1].tr('[A-Z ]', '[a-z_]')] = val[2]
      end
    end
    if self.report_format >= 7
      event["catalog_uuid"] = self.catalog_uuid
      if self.report_format >= 
        event["server_used"] = self.server_used
      else
        event["master_used"] = self.master_used
      end
      event["cached_catalog_status"] = self.cached_catalog_status
    end
    event["report_format"] = self.report_format
    event["puppet_version"] = self.puppet_version
    event["configuration_version"] = self.configuration_version
    event["status"] = self.status
    event["environment"] = self.environment

    event["start_time"] = self.logs.first.time.utc.iso8601
    event["end_time"] = self.logs.last.time.utc.iso8601

    event["tags"] = ["puppet-run"]
    event["message"] = "Puppet run on #{self.host} #{self.status}"
    
    

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
  
  def logs_to_array logs
    h = []
    logs.each do |log|
      l = "level=" + log.level.to_s + ", source=" + log.source + ", message=" + log.message
      h << l
    end
    return h
  end

  def validate_host(host)
    if host =~ Regexp.union(/[#{SEPARATOR}]/, /\A\.\.?\Z/)
      raise ArgumentError, "Invalid node name #{host.inspect}"
    end
  end
  module_function :validate_host
end
