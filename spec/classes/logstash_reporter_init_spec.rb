require 'spec_helper'

describe 'logstash_reporter', :type => :class do

  context 'default' do
    let(:facts) { { :puppetversion => '3.7.5'} }
    it { should contain_class('logstash_reporter') }
    it { should contain_class('logstash_reporter::params') }
    it { should contain_file('/etc/puppet/logstash.yaml').with(:owner => 'puppet') }
  end

  context 'pe' do
    let(:facts) { { :is_pe => true } }
    it { should contain_class('logstash_reporter') }
    it { should contain_class('logstash_reporter::params') }
    it { should contain_file('/etc/puppetlabs/puppet/logstash.yaml').with(:owner => 'pe-puppet') }
  end

  context 'puppet 4' do
    let(:facts) { { :puppetversion => '4.0.0', :is_pe => false } }
    it { should contain_class('logstash_reporter') }
    it { should contain_class('logstash_reporter::params') }
    it { should contain_file('/etc/puppetlabs/puppet/logstash.yaml').with(:owner => 'puppet') }
  end
  context 'pe >= 2015' do
      let(:facts) { { :puppetversion => '4.0.0', :pe_server_version => true } }
      it { should contain_class('logstash_reporter') }
      it { should contain_class('logstash_reporter::params') }
      it { should contain_file('/etc/puppetlabs/puppet/logstash.yaml').with(:owner => 'pe-puppet') }
  end
end
