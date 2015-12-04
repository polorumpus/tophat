if ['rhel'].include?(node['platform_family'])
  # XXX should this instead do security updates instead of full
  # system updates?
  execute 'yum upgrade -y'
  # default repository should be the Long-Term Support release
  # https://wiki.jenkins-ci.org/display/JENKINS/LTS+Release+Line
  node.default['jenkins']['master']['repository'] = 'http://pkg.jenkins-ci.org/redhat-stable'
  node.default['jenkins']['master']['repository_key'] = 'http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key'
end
if ['debian'].include?(node['platform_family'])
  node.default['apt']['compile_time_update'] = true
  include_recipe 'apt::default'
  # XXX should this instead do security updates instead of full
  # system updates?
  execute 'apt-get upgrade -y' do
    environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  end
  # default repository should be the Long-Term Support release
  # https://wiki.jenkins-ci.org/display/JENKINS/LTS+Release+Line
  node.default['jenkins']['master']['repository'] = 'http://pkg.jenkins-ci.org/debian-stable'
  node.default['jenkins']['master']['repository_key'] = 'http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key'
end

include_recipe 'jenkins-config::prereqs'
include_recipe 'java'
include_recipe 'git'
include_recipe 'jenkins::master'
include_recipe 'jenkins-config::jenkins-plugins'
# include_recipe 'jenkins-config::jenkins-jobs'
include_recipe 'jenkins-config::homebin'

service 'jenkins' do
  action :restart
end
