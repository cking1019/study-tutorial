# 1、安装与卸载

~~~shell
apt-get install ca-certificates curl gnupg lsb-release
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt-get install docker-ce docker-ce-cli containerd.io
# 配置docker下载镜像地址
vim /etc/docker/daemon.json
{
    "registry-mirrors": [
        "https://9cpn8tt6.mirror.aliyuncs.com",
        "https://dockerproxy.com",
        "https://hub-mirror.c.163.com",
        "https://mirror.baidubce.com",
        "https://ccr.ccs.tencentyun.com"
    ]
}

# 安装社区版docker
apt install docker-ce docker-ce-cli containerd.io
# 卸载docker
apt remove docker-ce docker-ce-cli containerd.io
# 启动docker
systemctl start docker
# 输出docker系统信息
docker info	
# 删除资源，/var/lib/docker为docker的默认工作路径
rm -rf /var/lib/docker
~~~

# 2、镜像

是对运行环境以及软件包的归档，可用于分发到其他服务器上。

~~~shell
# 搜索镜像
docker search mysql
# 拉取镜像
docker pull mysql     # 如果不加tag，则默认下载latest版
# 删除镜像
docker rmi -f imageID # 通过镜像名或镜像id删除
# 输出镜像信息
docker images
~~~

# 3、容器

通过运行镜像启动容器，每个容器是一个单独的进程，也是一个微型Linux环境，容器之间互不干涉。

~~~shell
# 每个容器都是一个Linux系统
# 查看当前所有容器，包括正在运行与已经停止的容器
docker ps -a
# 删除容器，可以是容器ID或容器名称
docker rm container_id  
# 启动容器
docker start   container_id	 # 启动容器
docker restart container_id	 # 重启容器
# 停止容器
docker stop    container_id	 # 停止正在运行的容器
docker kill    container_id	 # 强制停止当前的容器
# 查看容器的详细信息
docker inspect container_id  
# 以命令行的形式进入容器
docker exec -it mysql /bin/bash
# 将数据复制到mysql容器的根目录
docker cp ~/test.sql mysql:/
# 将容器内部的数据复制到外部环境
docker cp 765b89f78cf0:/etc/nginx/nginx.conf /etc/docker/nginx/nginx.conf
# 导出容器
docker save wewe-rss > wewe-rss.tar
# 导入容器
docker load < wewe-rss.tar
~~~

# 4、命令启动案例

~~~shell
# 启动nginx
docker run -d \
--name nginx \
-p 80:80 \
-p 443:443 \
-v /etc/docker/nginx/conf.d:/etc/nginx/conf.d \
-v /etc/docker/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /var/docker/nginx/html:/usr/share/nginx/html \
-v /var/docker/static:/var/static \
nginx

# 启动mysql，并且对数据进行持久化
docker run -d \
--name mysql \
-p 3306:3306 \
-v /etc/docker/mysql/conf.d:/etc/mysql/conf.d \
-v /var/docker/mysql/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
mysql

# 启动redis
docker run -d \
--name myredis \
-p 6379:6379 \
-v /etc/docker/redis/redis.conf:/etc/redis/redis.conf \
-v /var/docker/redis/data:/data \
redis

# 启动portainer
docker run -d \
--name portainer \
-p 9443:9443 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/docker/nginx/conf.d/cert:/cert \
--restart=always \
--privileged=true \
portainer/portainer-ce \
--sslcert /etc/docker/nginx/nginx.conf/cert/cking.icu.pem \
--sslkey  /etc/docker/nginx/nginx.conf/cert/cking.icu.key

# 启动wewe-rss
docker run -d \
--name wewe-rss \
-p 4000:4000 \
-e DATABASE_TYPE=sqlite \
-e AUTH_CODE=123456 \
-v /var/docker/wewe-rss/data:/app/data \
cooderl/wewe-rss-sqlite
~~~

# 5、制作镜像

**命令：docker build -t demo .** 可将语言环境与第三方包一起打包成镜像，便于打包传输。

~~~shell
# 使用官方的 Java 11 镜像作为基础镜像
FROM openjdk:11
# 设置工作目录
WORKDIR /app
# 将应用程序的 JAR 文件复制到镜像中
COPY demo.jar /app
# 暴露应用程序端口
EXPOSE 8080
# 定义容器启动命令
CMD ["java", "-jar", "demo.jar"]
~~~

# 6、制作docker-compose文件

**命令：docker compose up -d** 

## 6.1 wee-rss

~~~yaml
services:
  wewe-rss:
    image: cooderl/wewe-rss-sqlite
    container_name: wewe-rss
    restart: always
    ports:
      - "4000:4000"
    environment:
      - DATABASE_TYPE=sqlite
      - AUTH_CODE=123456
    volumes:
      - /var/docker/wewe-rss/data:/app/data
~~~

## 6.2 mysql

~~~yaml
services:
  mysql:
    image: mysql
    container_name: mysql
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    volumes:
      - /etc/docker/mysql/conf.d:/etc/mysql/conf.d
      - /var/docker/mysql/data:/var/lib/mysql
  redis:
    image: redis
    container_name: redis
    ports:
      - "6379:6379"
    volumes:
      - /etc/docker/redis/redis.conf:/etc/redis/redis.conf
      - /var/docker/redis/data:/data
~~~

## 6.3 nginx

~~~yaml
services:
  nginx:
    image: nginx
    container_name: nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /etc/docker/nginx/conf.d:/etc/nginx/conf.d
      - /etc/docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - /var/docker/nginx/html:/usr/share/nginx/html
      - /var/docker/nginx/static:/var/static
~~~

## 6.4 kafka

~~~yaml
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
    container_name: "zookeeper"
    restart: always
  kafka:
    image: wurstmeister/kafka:2.12-2.3.0
    container_name: "kafka"
    ports:
      - "9092:9092"
    environment:
      - TZ=CST-8
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
      # 非必须，设置自动创建 topic
      - KAFKA_AUTO_CREATE_TOPICS_ENABLE=true
      - KAFKA_ADVERTISED_HOST_NAME=${IP}
      - KAFKA_ADVERTISED_PORT=9092
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://${IP}:9092
      - KAFKA_LISTENERS=PLAINTEXT://:9092
      # 非必须，设置对内存
      - KAFKA_HEAP_OPTS=-Xmx1G -Xms1G
      # 非必须，设置保存7天数据，为默认值
      - KAFKA_LOG_RETENTION_HOURS=168
    volumes:
      # 将 kafka 的数据文件映射出来
      - /var/docker/kafka/data:/kafka
      # 用于管理其他容器
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
~~~

