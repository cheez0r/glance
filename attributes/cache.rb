# defaults for Glance cache
default[:glance][:image_cache_dir] = "/var/lib/glance/image-cache/"
default[:glance][:image_cache_stall_time] = "86400"
default[:glance][:image_cache_invalid_entry_grace_period] = "3600"
default[:glance][:image_cache_max_size] = "1073741824"
