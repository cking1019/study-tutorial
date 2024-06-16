# 配置文件

~~~conf
#user  nobody;
worker_processes  1;

error_log  logs/error.log;
error_log  logs/error.log  notice;
error_log  logs/error.log  info;

pid        logs/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '[$remote_addr]-[$time_iso8601]';
    access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;

    server {
        listen       80;
        server_name  localhost;
		
		if ($host = '47.119.18.145') {
			return 403 "this is 403";
		}
		
		error_page 404 /404.html;
		
		rewrite ^(.*)$ https://$host$1;
		
        location / {
			add_header Content-Type 'text/html; charset=utf-8';
			root   html;
            index  index.html;
        }
    }

    server {
        listen       443 ssl;
        server_name  cking.icu wyy.cking.icu;

        ssl_certificate      cert/cking.icu.pem;
        ssl_certificate_key  cert/cking.icu.key;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;
		
		#if ($host = '47.119.18.145') {
		#	return 403 "this is 403";
		#}

        location / {
            root   html;
            index  index.html;
            # add_header Host $host;
            # add_header X-Real-IP $remote_addr;
        }
		
		location /json {
			default_type application/json;
			return 200 '{"status":"success","result":"nginx json"}';
		}
		
		location /proxy {
			proxy_pass http://localhost:8080/test;
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
		}
		
		location /static {
			alias C:/static/;
			autoindex on;
		}
    }
}

~~~

