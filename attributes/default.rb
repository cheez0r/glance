default[:glance][:api_config_file]="/etc/glance/glance-api.conf"
default[:glance][:api_paste_config_file]="/etc/glance/glance-api-paste.ini"
default[:glance][:api_flavor]="caching"
default[:glance][:cache_config_file]="/etc/glance/glance-cache.conf"
default[:glance][:registry_config_file]="/etc/glance/glance-registry.conf"
default[:glance][:registry_paste_config_file]="/etc/glance/glance-registry-paste.ini"
default[:glance][:registry_flavor]="keystone"
default[:glance][:scrubber_config_file]="/etc/glance/glance-scrubber.conf"
default[:glance][:log_dir]="/var/log/glance"
default[:glance][:use_syslog]="False"
default[:glance][:working_directory]="/var/lib/glance"
default[:glance][:pid_directory]="/var/run/glance"

default[:glance][:verbose] = "True"
default[:glance][:debug] = "True"
default[:glance][:my_ip] = ipaddress
default[:glance][:api_bind_host] = "0.0.0.0"
default[:glance][:api_bind_port] = "9292"
default[:glance][:registry_host] = ipaddress
default[:glance][:registry_bind_host] = "0.0.0.0"
default[:glance][:registry_bind_port] = "9191"
default[:glance][:registry_client_protocol] = "http"

# Backlog requests when creating socket
default[:glance][:backlog] = "4096"

#registry SQL settings
default[:glance][:mysql] = false
default[:glance][:postgresql] = false
default[:glance][:sql_connection] = "sqlite:////var/lib/glance/glance.sqlite"
default[:glance][:sql_idle_timeout] = "60"
#registry settings
default[:glance][:api_limit_max] = "1000"
default[:glance][:limit_param_default] = "25"
#default[:glance][:cert_file] = ""
#default[:glance][:key_file] = ""
#default[:glance][:registry_client_key_file] = ""
#default[:glance][:registry_client_cert_file] = ""
#default[:glance][:registry_client_ca_file] = ""

#default_store choices are: file, http, https, swift, s3
default[:glance][:default_store] = "file"
default[:glance][:filesystem_store_datadir] = "/var/lib/glance/images"

default[:glance][:image_cache_dir] = "/var/lib/glance/image-cache"

#keystone settings
default[:glance][:keystone_service_protocol] = "http"
default[:glance][:keystone_service_host] = "127.0.0.1"
default[:glance][:keystone_service_port] = "5000"
default[:glance][:keystone_auth_host] = "127.0.0.1"
default[:glance][:keystone_auth_port] = "35357"
default[:glance][:keystone_auth_protocol] = "http"
default[:glance][:keystone_auth_uri] = "http://127.0.0.1:5000/"
default[:glance][:keystone_admin_token] = "999888777666"

#RBD Store options
default[:glance][:rbd_store_ceph_conf] = "/etc/ceph/ceph.conf"
default[:glance][:rbd_store_user] = "glance"
default[:glance][:rbd_store_pool] = "images"
default[:glance][:rbd_store_chunk_size] = "8"

#Delayed Delete Options
default[:glance][:delayed_delete] = "False"
default[:glance][:scrub_time] = "43200"
default[:glance][:scrubber_datadir] = "/var/lib/glance/scrubber"

#Notification System Options
default[:glance][:notifier_strategy] = "noop"
default[:glance][:rabbit_host] = "localhost"
default[:glance][:rabbit_port] = "5672"
default[:glance][:rabbit_use_ssl] = "False"
default[:glance][:rabbit_userid] = "guest"
default[:glance][:rabbit_password] = "guest"
default[:glance][:rabbit_virtual_host] = "/"
default[:glance][:rabbit_notification_exchange] = "glance"
default[:glance][:rabbit_notification_topic] = "glance_notifications"

# Example Attributes for the glance::load_images recipe:
#
# default[:glance][:tty_linux_image] = "http://abc.rackcdn.com/tty_linux.tar.gz"
#
# default[:glance][:image_list] = [{:name => "squeeze", :url => "http://abc.rackcdn.com/squeeze-agent-0.0.1.28.ova", :disk_format => "vhd", :container_format="ovf"}]
