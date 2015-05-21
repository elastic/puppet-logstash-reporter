#! /usr/bin/env ruby
require 'spec_helper'

require 'puppet/reports'
require 'time'
require 'pathname'
require 'tempfile'
require 'fileutils'

processor = Puppet::Reports.report(:logstash)

describe processor do
  describe "#process" do

    after :each do
        @server.close
    end

    before :each do
      @server = TCPServer.new 5999
      @report = YAML.load_file(File.join(fixture_path, 'report2.6.x.yaml')).extend processor

    end

    it  "should send the right data to the remote server" do

      @report.process
      client = @server.accept()
      resp = client.read()
      data = JSON.parse(resp)
      expect(data).not_to be_empty
      expect(data['@version']).to eq(1)
      expect(data['@timestamp']).to eq(Time.now.utc.iso8601)

      expect(data).to include("environment", "report_format", "puppet_version", "status", "start_time", "end_time", "tags")


    end

    it "rejects invalid hostnames" do
      @report.host = ".."
      expect { @report.process }.to raise_error(ArgumentError, /Invalid node/)
    end
  end

  describe "::validate_host" do
    ['..', 'hello/', '/hello', 'he/llo', 'hello/..', '.'].each do |node|
      it "rejects #{node.inspect}" do
        expect { processor.validate_host(node) }.to raise_error(ArgumentError, /Invalid node/)
      end
    end

    ['.hello', 'hello.', '..hi', 'hi..'].each do |node|
      it "accepts #{node.inspect}" do
        processor.validate_host(node)
      end
    end
  end
end
