# /etc/nginx/nginx.conf

user nginx;

# Set number of worker processes automatically based on number of CPU cores.
worker_processes auto;

# Enables the use of JIT for regular expressions to speed-up their processing.
pcre_jit on;

# Configures default error logger.
error_log /var/log/nginx/error.log warn;

# Includes files with directives to load dynamic modules.
include /etc/nginx/modules/*.conf;

# Uncomment to include files with config snippets into the root context.
# NOTE: This will be enabled by default in Alpine 3.15.
#include /etc/nginx/conf.d/*.conf;

events {
	# The maximum number of simultaneous connections that can be opened by
	# a worker process.
	worker_connections 1024;
}

http {
	# Includes mapping of file name extensions to MIME types of responses
	# and defines the default type.
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	# Name servers used to resolve names of upstream servers into addresses.
	# It's also needed when using tcpsocket and udpsocket in Lua modules.
	#resolver 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001;

	# Don't tell nginx version to the clients. Default is 'on'.
	server_tokens off;

	# Specifies the maximum accepted body size of a client request, as
	# indicated by the request header Content-Length. If the stated content
	# length is greater than this size, then the client receives the HTTP
	# error code 413. Set to 0 to disable. Default is '1m'.
	client_max_body_size 1m;

	# Sendfile copies data between one FD and other from within the kernel,
	# which is more efficient than read() + write(). Default is off.
	sendfile on;
	sendfile_max_chunk 1m;

	# Causes nginx to attempt to send its HTTP response head in one packet,
	# instead of using partial frames. Default is 'off'.
	tcp_nopush on;

	# Enable gzipping of responses.
	gzip on;
    gzip_disable "msie6";

    gzip_min_length 10;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 9;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;

	# Helper variable for proxying websockets.
    # 	map $http_upgrade $connection_upgrade {
    # 		default upgrade;
    # 		'' close;
    # 	}

	# Specifies the main log format.
	log_format main '$remote_addr - $remote_user [$time_local] "$request" '
			'$status $body_bytes_sent "$http_referer" '
			'"$http_user_agent" "$http_x_forwarded_for"';

	# Sets the path, format, and configuration for a buffered log write.
	access_log /var/log/nginx/access.log main;


	# Includes virtual hosts configs.
	include /etc/nginx/conf.d/*.conf;
}

# TIP: Uncomment if you use stream module.
#include /etc/nginx/stream.conf;