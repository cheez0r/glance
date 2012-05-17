#
# Cookbook Name:: glance
# Attributes:: database
#
::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:glance][:db][:password] = secure_password
default[:glance][:db][:user] = "glance"
default[:glance][:db][:database] = "glance"
default[:glance][:db][:sql_idle_timeout] = "60"
