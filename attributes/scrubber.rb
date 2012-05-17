# defaults for Glance scrubber
default[:glance][:scrubber_daemon] = "False"
default[:glance][:scrubber_wakeup_time] = "300"
default[:glance][:scrubber_datadir] = "/var/lib/glance/scrubber"
default[:glance][:cleanup_scrubber] = "False"
default[:glance][:cleanup_scrubber_time] = "86400"
