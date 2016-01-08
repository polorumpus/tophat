require 'spec_helper'

describe package('jenkins'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('jenkins'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('jenkins'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('jenkins'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe port(8080), :if => (os[:family] == 'ubuntu' or
                             os[:family] == 'redhat') do
  it { should be_listening.with('tcp6') }
end

describe http_get('http://localhost:8080/') do
  its(:body) { should match /Log in<\/a> to create new jobs/ }
end
