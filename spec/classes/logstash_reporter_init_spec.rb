require 'spec_helper'
 
describe 'logstash_reporter', :type => :class do

  it { should create_class('logstash_reporter') }
  it { should contain_file('/etc/puppet/logstash.yaml') }

end

