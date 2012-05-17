#
# Cookbook Name:: glance
# Recipe:: common
#
#

package "glance-common" do
  options "--force-yes"
  action :install
end

#FIXME: This should come out if/when we require python-keystone in api package
if node[:glance][:auth_type] and node[:glance][:auth_type] == "keystone" then
  package "python-keystone"
end

[node[:glance][:log_dir], node[:glance][:working_directory], File::dirname(node[:glance][:api_config_file]), File::dirname(node[:glance][:registry_config_file]), node[:glance][:pid_directory]].each do |glance_dir|

  directory glance_dir do
    owner "glance"
    group "root"
    mode "0755"
    action :create
  end

end
