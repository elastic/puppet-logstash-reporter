require 'spec_helper'

describe 'logstash_reporter', :type => :class do

  context 'default' do
    it { should contain_class('logstash_reporter') }
    it { should contain_class('logstash_reporter::params') }
    it { should contain_file('/etc/puppet/logstash.yaml').with(:owner => 'puppet') }
  end

  context 'pe' do
    let(:facts) { { :is_pe => true } }
    it { should contain_class('logstash_reporter') }
    it { should contain_class('logstash_reporter::params') }
    it { should contain_file('/etc/puppetlabs/puppet/logstash.yaml').with(:owner => 'pe_puppet') }
  end

  context 'puppet 4' do
    let(:facts) { { :puppetversion => '4.0.0' } }
    it { should contain_class('logstash_reporter') }
    it { should contain_class('logstash_reporter::params') }
    it { should contain_file('/etc/puppetlabs/puppet/logstash.yaml').with(:owner => 'puppet') }
  end
end

