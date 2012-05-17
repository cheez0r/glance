#
# Cookbook Name:: glance
# Recipe:: mysql
#

execute "mysql-install-glance-privileges" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} < /etc/mysql/glance-grants.sql"
  action :nothing
end

node[:mysql][:bind_address] = node[:glance][:my_ip]

Chef::Log.info("Mysql recipe included")

include_recipe "mysql::server"
require 'rubygems'
Gem.clear_paths
require 'mysql'

template "/etc/mysql/glance-grants.sql" do
  path "/etc/mysql/glance-grants.sql"
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node[:glance][:db][:user],
    :password => node[:glance][:db][:password],
    :database => node[:glance][:db][:database]
  )
  notifies :run, resources(:execute => "mysql-install-glance-privileges"), :immediately
end

execute "create #{node[:glance][:db][:database]} database" do
  command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{node[:glance][:db][:database]}"
  not_if do
    m = Mysql.new("localhost", "root", node[:mysql][:server_root_password])
    m.list_dbs.include?(node[:glance][:db][:database])
  end
end

# save data so it can be found by search
unless Chef::Config[:solo]
  Chef::Log.info("Saving node data")
  node.save
end
