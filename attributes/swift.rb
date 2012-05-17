# Swift defaults for the Glance API server
default[:glance][:swift_store_auth_address] = "127.0.0.1:8080/v1.0/"
default[:glance][:swift_store_user] = "jdoe"
default[:glance][:swift_store_key] = "a86850deb2742ec3cb41518e26aa2d89"
default[:glance][:swift_store_container] = "glance"
default[:glance][:swift_store_create_container_on_put] = "False"
default[:glance][:swift_store_large_object_size] = "5120"
default[:glance][:swift_store_large_object_chunk_size] = "200"
default[:glance][:swift_enable_snet] = "False"
