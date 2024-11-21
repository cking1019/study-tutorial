# 1、安装与卸载

~~~shell
apt install ca-certificates curl gnupg lsb-release
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt install docker-ce docker-ce-cli containerd.io
# 配置docker下载镜像地址
cat /etc/docker/daemon.json
{
    "registry-mirrors": [
    	"https://dockerproxy.com",
        "https://9cpn8tt6.mirror.aliyuncs.com",
   		"https://ccr.ccs.tencentyun.com",
    	"https://docker.nju.edu.cn"
    ]
}
# 启动docker
systemctl start docker
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
# 查看当前所有容器，包括正在运行与已经停止的容器
docker ps -a
# 删除容器，可以是容器ID或容器名称
docker rm container_id  
# 启动容器
docker start   container_name	 # 启动容器
docker restart container_name	 # 重启容器
# 停止容器
docker stop    container_name	 # 停止正在运行的容器
docker kill    container_name	 # 强制停止当前的容器
# 查看容器的详细信息
docker inspect container_name 
# 以命令行的形式进入容器
docker exec -it mysql /bin/bash
# 将数据复制到mysql容器的根目录
docker cp ~/test.sql mysql:/
# 将容器内部的数据复制到外部环境
docker cp nginx:/etc/nginx/nginx.conf /etc/docker/nginx/nginx.conf
docker cp /etc/apt/sources.list nginx:/etc/apt/sources.list
# 导出镜像
docker save wewe-rss > wewe-rss.tar
# 导入镜像
docker load < wewe-rss.tar
# 导出容器
docker export nginx -o nginx.tar
# 导入容器
docker import nginx.tar nginx

# 查看当前所有容器与镜像占用的磁盘大小
docker system df
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          11        7         4.485GB   1.848GB (41%)
Containers      7         4         1.104GB   167B (0%)
Local Volumes   6         1         607.5kB   474.6kB (78%)
Build Cache     23        0         97.8MB    97.8MB

# 查看所有网络
docker network ls
NETWORK ID     NAME                     DRIVER    SCOPE
68269b63473d   bridge                   bridge    local
8252cd1c4db6   docker-compose_default   bridge    local
da64cca0d0a9   emlog_default            bridge    local
5d803fb0cb2f   host                     host      local
3c14c9773708   none                     null      local
adb6ab05811b   root_default             bridge    local
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

**命令：docker compose -f compose.ymal up -d** 

## 6.1 wee-rss

~~~yaml
services:
  wewe-rss:
    image: cooderl/wewe-rss-sqlite
    container_name: wewe-rss
    restart: always
    ports:
      - 0.0.0.0:4000:4000
    environment:
      - DATABASE_TYPE=sqlite
      - AUTH_CODE=123456
    volumes:
      - /var/docker/wewe-rss/data:/app/data
    networks:
      - bridge
networks:
  bridge:
    driver: bridge
~~~

## 6.2 mysql-redis

~~~yaml
services:
  mysql:
    image: mysql
    container_name: mysql
    restart: always
    ports:
      - 0.0.0.0:3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    volumes:
      - /etc/docker/mysql/conf.d:/etc/mysql/conf.d
      - /var/docker/mysql/data:/var/lib/mysql
    networks:
      - bridge
  redis:
    image: redis
    container_name: redis
    restart: always
    ports:
      - 0.0.0.0:6379:6379
    volumes:
      - /etc/docker/redis/redis.conf:/etc/redis/redis.conf
      - /var/docker/redis/data:/data
    networks:
      - bridge
    depends_on:
      - mysql
networks:
  bridge:
    driver: bridge
~~~

## 6.3 nginx

~~~yaml
services:
  nginx:
    image: nginx
    container_name: nginx
    restart: always
    ports:
      - 0.0.0.0:80:80
      - 0.0.0.0:443:443
    volumes:
      - /etc/docker/nginx/conf.d:/etc/nginx/conf.d
      - /etc/docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - /var/docker/nginx/html:/usr/share/nginx/html
      - /var/docker/nginx/static:/var/static
    command: ["nginx", "-g", "daemon off;"] # 如果是迁移过来的容器，那么需要加该命令
~~~

## 6.4 kafka

~~~yaml
services:
  zookeeper:
    image: wurstmeister/zookeeper
    container_name: zookeeper
    restart: always
    ports:
      - 0.0.0.0:2181:2181
  kafka:
    image: wurstmeister/kafka:2.12-2.3.0
    container_name: kafka
    restart: always
    ports:
      - 0.0.0.0:9092:9092
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
~~~

## 6.5 portainer

~~~yaml
services:
  portainer:
    image: portainer/portainer-ce
    container_name: portainer
    restart: always
    ports:
      - 0.0.0.0:9443:9443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/docker/nginx/conf.d/cert:/cert
    privileged: true
    command: 
      - --ssl-cert
      - /etc/docker/nginx/nginx.conf/cert/cking.icu.pem
      - --ssl-key
      - /etc/docker/nginx/nginx.conf/cert/cking.icu.key
~~~

## 6.6 mogodb

~~~yaml
services:
  mongodb:
    image: mongo
    container_name: mongodb
    restart: always
    environment:
      - TZ=Asia/Shanghai
      - MONGO_INITDB_DATABASE=demo
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=123456
    ports:
      - 0.0.0.0:27017:27017
    volumes:
      - /var/docker/mongodb/data:/data/db
      - /var/docker/mongodb/logs:/data/logs
      - /etc/docker/mongodb/config:/data/configdb
~~~

