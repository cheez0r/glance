# S3 defaults for the Glance API server
default[:glance][:s3_store_host] = "127.0.0.1:8080/v1.0/"
default[:glance][:s3_store_access_key] = "ABCD"
default[:glance][:s3_store_secret_key] = "EFGH"
default[:glance][:s3_store_bucket] = "abcdglance"
default[:glance][:s3_store_create_bucket_on_put] = "False"
