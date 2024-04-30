# 1、安装与卸载

~~~shell
# 安装社区版docker
yum install docker-ce docker-ce-cli containerd.io
# 启动docker
systemctl start docker

docker info	# 显示docker的系统信息，包括镜像和容器的数量
docker images

# 卸载docker
yum remove docker-ce docker-ce-cli containerd.io
# 删除资源，/var/lib/docker为docker的默认工作路径
rm -rf /var/lib/docker
~~~

# 2、镜像

~~~shell
# 搜索镜像
docker search mysql
# 拉取镜像
docker pull mysql     # 如果不加tag，则默认下载latest版
# 删除镜像
docker rmi -f imageID # 通过镜像名或镜像id删除
~~~

# 3、容器

~~~shell
docker ps  # 列出当前正在运行的所有容器

docker rm container_id  # 删除容器

# 启动容器
docker start   container_id	 # 启动容器
docker restart container_id	 # 重启容器
# 停止容器
docker stop    container_id	 # 停止当前正在运行的容器
docker kill    container_id	 # 强制停止当前的容器

docker inspect container_id  # 查看容器的详细信息

# 创建并启动一个容器实例，可以指定容器名称、端口映射、容器镜像、环境变量等
docker run
# 用于在正在运行的容器中执行新的命令，比如查看日志，安装r
docker exec
~~~

# 4、案例

~~~shell
# 启动nginx
docker run -d --name nginx01 \
-p 80:80 \
nginx

# 启动tomcat
docker run -d --name tomcat01 \
-p 8080:8080 \
tomcat:9.0
docke
# 启动mysql，并且数据持久化
docker run -d --name mysql01 
-v /home/mysql/conf:/etc/mysql/conf.d \
-v /home/mysql/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=your_password \ 
-p 3306:3306 \
mysql

# 启动portainer，portainer是Docker的图形界面管理工具，提供了一个后台面板。
docker run -d --name portainer01 \
-v /var/run/docker.sock:/var/run/docker.sock \
--restart=always \
--privileged=true \
-p 8088:9000 \
portainer/portainer-ce
~~~
