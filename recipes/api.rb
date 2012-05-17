#
# Cookbook Name:: glance
# Recipe:: api
#
#

include_recipe "#{@cookbook_name}::common"

# Locate glance registry and retrieve it's IP
unless Chef::Config[:solo]
  registries = search(:node, "recipes:glance\\:\\:registry")
  if registries and registries[0]
    node.default[:glance][:registry_host] = registries[0][:glance][:registry_host]
  end
end

Chef::Log.info("Using glance registry at #{node[:glance][:registry_host]}")

paste_vars = {
    :service_protocol => node[:glance][:keystone_service_protocol],
    :service_host => node[:glance][:keystone_service_host],
    :service_port => node[:glance][:keystone_service_port],
    :auth_host => node[:glance][:keystone_auth_host],
    :auth_port => node[:glance][:keystone_auth_port],
    :auth_protocol => node[:glance][:keystone_auth_protocol],
    :auth_uri => node[:glance][:keystone_auth_uri],
    :admin_token => node[:glance][:keystone_admin_token]
}

package "glance-api" do
  action :install
end

# Ubuntu autostarts glance (we stop it here forcefully on initial install)
if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
  service "glance-api" do
    stop_command "stop glance-api"
    status_command "status glance-api | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
    action :nothing
    subscribes :stop, resources(:package => "glance-api"), :immediately
  end
end

generate_paste_template "/etc/glance/glance-api-paste.ini.template" do
  source node[:glance][:api_paste_config_file]
  package "glance-api"
  variables(paste_vars)
end

template node[:glance][:api_paste_config_file] do
  source "/etc/glance/glance-api-paste.ini.template"
  owner "glance"
  group "glance"
  mode "0644"
  local true
  variables(paste_vars)
end

template node[:glance][:api_config_file] do
  source "glance-api.conf.erb"
  owner "glance"
  group "glance"
  mode 0644
end

template node[:glance][:cache_config_file] do
  source "glance-cache.conf.erb"
  owner "glance"
  group "glance"
  mode 0644
end

template node[:glance][:scrubber_config_file] do
  source "glance-scrubber.conf.erb"
  owner "glance"
  group "glance"
  mode 0644
end

file "/var/log/glance/api.log" do
  owner "glance"
  group "glance"
  mode "0644"
  action :create
end

directory node[:glance][:filesystem_store_datadir] do
  owner "glance"
  group "glance"
  mode "0755"
  action :create
end

["", "incomplete", "invalid", "queue"].each do |cache_dir|

  directory "#{node[:glance][:image_cache_dir]}/#{cache_dir}" do
    owner "glance"
    group "glance"
    mode "0755"
    action :create
  end

end

service "glance-api" do
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart glance-api"
    stop_command "stop glance-api"
    start_command "start glance-api"
    status_command "status glance-api | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
  end
  supports :status => true, :restart => true
  action :start
  subscribes :restart, resources(:template => node[:glance][:api_config_file])
  subscribes :restart, resources(:package => "glance-api")
end
