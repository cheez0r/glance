#
# Cookbook Name:: glance
# Recipe:: postgresql
#

Chef::Log.info("PostgreSQL recipe included")

package "python-psycopg2"

bash "postgresql-grant-glance-user-privileges" do
  code <<-EOH
    echo "GRANT ALL ON DATABASE #{node[:glance][:db][:database]} TO #{node[:glance][:db][:user]}" | su - postgres -c psql
  EOH
  action :nothing
end

bash "postgresql-create-glance-user" do
  code <<-EOH
    echo "CREATE USER #{node[:glance][:db][:user]} WITH PASSWORD '#{node[:glance][:db][:password]}'" | su - postgres -c psql
  EOH
  action :nothing
  notifies :run, "bash[postgresql-grant-glance-user-privileges]", :immediately
end

bash "postgresql-create-glance-db" do
  code <<-EOH
    echo "CREATE DATABASE #{node[:glance][:db][:database]}" | su - postgres -c psql
  EOH
  notifies :run, "bash[postgresql-create-glance-user]", :immediately
end

# save data so it can be found by search
unless Chef::Config[:solo]
  Chef::Log.info("Saving node data")
  node.save
end
