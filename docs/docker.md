# 1、docker的安装与卸载

~~~shell
# 1、需要的安装包
yum install -y yum-utils
# 2、配置国内镜像地址
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 3、更新yum软件包索引
yum makecache fast
# 4、安装社区版docker
yum install docker-ce docker-ce-cli containerd.io
# 5、启动docker
systemctl start docker
# 6、查看docker版本
docker version

docker --version             # 显示docker的版本信息
docker info					 # 显示docker的系统信息，包括镜像和容器的数量
docker command --help		 # 帮助命令

docker inspect container_id  # 查看容器的详细信息

docker images
-a # all，列出所有镜像
-q # quiet，只显示镜像的id

# 1、卸载依赖
yum remove docker-ce docker-ce-cli containerd.io
# 2、删除资源
rm -rf /var/lib/docker  # /var/lib/docker为docker的默认工作路径
~~~

# 2、阿里云加速

~~~shell
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://j6yjzbk6.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
~~~

# 3、底层工作原理

Docker是一个Client-Server结构的系统，Docker的守护进程运行在主机上，并通过Socket从客户端访问。

DockerServer接收到Docker-Client的指令，就会执行。

# 4、镜像命令

~~~shell
# 搜索镜像
docker search mysql
docker search mysql --filter=STARS=3000  # 过滤STARS大于3000的镜像

# 拉取镜像
docker pull mysql            # 如果不加tag，则默认下载latest版
docker pull imageName[:tag]  # tag指定版本号

# 删除镜像
docker rmi -f imageID # 通过镜像名或镜像id删除
docker rmi -f $(docker iamges -aq)
~~~

# 5、容器命令

~~~shell
docker ps  # 列出当前正在运行的所有容器
-a    # 列出当前正在运行的所有容器+历史运行过的容器
-n=?  # 显示最近创建的容器
-q    # 只显示容器的编号

docker rm container_id  # 删除容器

# 启动容器
docker start   container_id	 # 启动容器
docker restart container_id	 # 重启容器
# 停止容器
docker stop    container_id	 # 停止当前正在运行的容器
docker kill    container_id	 # 强制停止当前的容器
~~~

# 6、案例

~~~shell
# 启动nginx
docker run -d --name nginx01 -p 3344:80 nginx
# -d 后台运行
# --name 容器命名
# -p 宿主机端口:容器内端口

# 启动tomcat
docker run -d --name tomcat01 -p 3345:8080 tomcat:9.0

# 启动mysql，并且数据持久化
docker run -d --name mysql01 
-v /home/mysql/conf:/etc/mysql/conf.d 
-v /home/mysql/data:/var/lib/mysql 
-e MYSQL_ROOT_PASSWORD=your_password 
-p 3306:3306 mysql:latest

# 启动portainer，portainer是Docker的图形界面管理工具，提供了一个后台面板。
docker run -d 
-p 8088:9000 
--restart=always 
-v /var/run/docker.sock:/var/run/docker.sock 
--privileged=true portainer/portainer
~~~
