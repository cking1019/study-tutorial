# 1、nginx.conf配置文件

~~~conf
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    tcp_nopush      on;

    keepalive_timeout  65;
	# 文件压缩
    gzip  on;
    # 中文解析
    charset utf-8,gbk;
    # 各种配置server配置信息
    include /etc/nginx/conf.d/*.conf;
}
~~~

# 2、conf.d/default.conf配置文件

~~~conf
server {
    listen       80;
    server_name  localhost;

    access_log  /var/log/nginx/host.access.log  main;
    # 可重定向支443端口
    #rewrite ^(.*)$ https://$host$1;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
    
    # 静态目录
    location /ftp {
	    alias /var/static;
	    autoindex on;
        autoindex_exact_size off;#文件大小从KB开始显示
        autoindex_localtime on;#显示文件修改时间为服务器本地时间

        auth_basic            "Please Input Your Passwd";
        auth_basic_user_file /etc/nginx/conf.d/passwd;

        set $limit_rate 2048k; #他的定义是ngix每秒发送1k的数据到客户端

        add_header "Access-Control-Allow-Origin" "*";
        add_header "Access-Control-Allow-Methods" "GET, POST, DELETE, PUT, OPTIONS";
        add_header "Access-Control-Allow-Headers" "*";
        expires 30d;
    }
}

server {
    listen       443 ssl;
    server_name  cking.icu;
    
    access_log  /var/log/nginx/host.access.log  main;

    ssl_certificate      /etc/nginx/conf.d/cert/cking.icu.pem;
    ssl_certificate_key  /etc/nginx/conf.d/cert/cking.icu.key;

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;

    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;
    
    location / {
      root   /usr/share/nginx/html;
      index clock.html;
      try_files $uri $uri/ /clock.html;
    }

    location /3d {
        root   /usr/share/nginx/html;
        index  index.html;
    }
    
    #location ~* /static/(jpg|jpeg|png|gif|ico|css|js)? {
    #    root /usr/share/nginx/html;
    #}
}
~~~

