#
# Cookbook Name:: glance
# Recipe:: registry
#
#

include_recipe "#{@cookbook_name}::common"

sql_connection = nil
if node[:glance][:mysql]
  Chef::Log.info("Using mysql")
  package "python-mysqldb"
  mysqls = nil

  unless Chef::Config[:solo]
    mysqls = search(:node, "recipes:glance\\:\\:mysql")
  end
  if mysqls and mysqls[0]
    mysql = mysqls[0]
    Chef::Log.info("Mysql server found at #{mysql[:mysql][:bind_address]}")
  else
    mysql = node
    Chef::Log.info("Using local mysql at  #{mysql[:mysql][:bind_address]}")
  end
  sql_connection = "mysql://#{mysql[:glance][:db][:user]}:#{mysql[:glance][:db][:password]}@#{mysql[:mysql][:bind_address]}/#{mysql[:glance][:db][:database]}"
elsif node[:glance][:postgresql]
  Chef::Log.info("Using postgresql")
  postgresqls = nil

  unless Chef::Config[:solo]
    postgresqls = search(:node, "recipes:glance\\:\\:postgresql")
  end
  if postgresqls and postgresqls[0]
    postgresql = postgresqls[0]
    Chef::Log.info("PostgreSQL server found at #{postgresql[:ipaddress]}")
  else
    postgresql = node
    Chef::Log.info("Using local PostgreSQL at #{postgresql[:ipaddress]}")
  end
  sql_connection = "postgresql://#{postgresql[:glance][:db][:user]}:#{postgresql[:glance][:db][:password]}@#{postgresql[:ipaddress]}/#{postgresql[:glance][:db][:database]}"
else
  # default to sqlite
  sql_connection = "sqlite:////var/lib/glance/glance.sqlite"
end

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

package "glance-registry" do
  action :install
end

if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
  service "glance-registry" do
    stop_command "stop glance-registry"
    status_command "status glance-registry | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
    action :nothing
    subscribes :stop, resources(:package => "glance-registry"), :immediately
  end
end

generate_paste_template "/etc/glance/glance-registry-paste.ini.template" do
  source node[:glance][:registry_paste_config_file]
  package "glance-registry"
  variables(paste_vars)
end

template node[:glance][:registry_paste_config_file] do
  source "/etc/glance/glance-registry-paste.ini.template"
  owner "glance"
  group "glance"
  mode 0644
  local true
  variables(paste_vars)
end

template node[:glance][:registry_config_file] do
  source "glance-registry.conf.erb"
  owner "glance"
  group "glance"
  mode 0644
  variables(
    :sql_connection => sql_connection
  )
end

service "glance-registry" do
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart glance-registry"
    stop_command "stop glance-registry"
    start_command "start glance-registry"
    status_command "status glance-registry | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
  end
  supports :status => true, :restart => true
  action :start
  subscribes :restart, resources(:template => node[:glance][:registry_config_file])
  subscribes :restart, resources(:package => "glance-registry")
end
