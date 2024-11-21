# 1、常用命令

~~~shell
# 管道运算符，将前一条命令的输出作为下一条命令的输入
ps -ef | grep tomcat  # 查看当前系统运行的进程。f为format，显示全格式
ps -aux  # 查看当前所有进程

top  # 性能分析工具，能够实时的显示系统中各个进程资源的占用情况，类似于windows的任务管理器。
top -p 925  # 指定进程ID监控

lsof -i:8080   # (list open files)显示该端口进程
netstat -ntlp4 # 显示网络端口

tar -zxvf filename.tar.gz  # 用于解压文件。gun zip
-z  # 解压具有gzip的属性
-x  # 解压一个压缩文件的参数指令
-v  # 显示压缩过程中的文件名
-f  # 在f之后立即接档名
unzip filename.zip

# nohup(no hang up)用于在系统后台不挂断地运行命令，退出终端也不会影响程序的运行。
nohup java -jar app.jar  # 不挂断运行Java
nohup python main.py     # 不挂断运行python

which name    # 查找系统PATH目录下的可执行文件。
whereis name  # 通过文件索引数据库而非PATH来查找，查找范围比which要广。

# 清空文件内容
vi file_name # 输入%d清除所有内容

# 查找文件
find . -name "libJsonShared.*"
~~~

# 2、防火墙设置


~~~shell
# 防火墙设置
systemctl start firewalld  # 启动firewalld服务进程。
systemctl restart firewalld
systemctl stop firewalld
# firewall是防火墙的名字，而firewalld是防火墙的服务进程名。d表示daemon的缩写，即幽灵进程，也叫守护进程。systemctl=>system control
firewall-cmd --state      # 查看防火墙状态
firewall-cmd --reload     # 重新载入配置，比如添加规则之后，需要执行此命令
firewall-cmd --get-zones  # 列出支持的zone
firewall-cmd --zone=public --list-ports        # 查看已开放的端口
firewall-cmd --add-port=80/tcp --permanent     # 永久添加80端口
firewall-cmd --remove-port=80/tcp --permanent  # 永久添加80端口
firewall-cmd --zone=public --list-ports                   # 查看白名单列表
firewall-cmd --zone=public --add-port=80/tcp --permanent  # 添加白名单端口
firewall-cmd --zone=public --add-port=6000-7000/tcp --permanent
~~~

~~~shell
rm *      # 删除当前目录下的所有文件
rm -r     # 删除目录及其子目录下的所有文件
rm -rf /  # 删除目录及其子目录下的所有文件，无需确定是否删除

kill number process_name  # 杀死进程。
# 1(HUP)，重新加载进程
# 2(KILL)，杀死一个进程
# 3(TERM)，正常停止一个进程

df -hl  # 查看磁盘分区上的磁盘空间
# -a  包含全部的文件习题
# -h  以可读性较高的方式来显示信息
# -l  仅显示本地的文件系统

mkdir dir_name   # 创建目录
touch file_name  # 创建文件

find *python*  # 查找当前目录下包含python关键字的文件
find / -name 'read*'   # 在/目录下查找read开头的文件或目录
# -name:文件名或目录名
# -type:查找类型，如-d表示查找目录

# 文件内容
tee -a res.txt  # 将标准输出复制到指定文件中，功能类似于重定向> 
ps -ef | tee res.txt
ls -l 1> res  # 0标准输入、1标准输出、2错误输出，'>'默认是标准输出'1>'
ls * 2>&1 | tee res.txt # 将错误输出重定向到标准输出，并写入至res.txt文件
~~~

~~~shell
chmod 777 filename  # 即change mode,对当前文件授权
chmod u+x hello.sh  # 给用户添加可执行权限
chmod +x hello.sh   # 给当前用户、同组用户、其他用户添加可执行权限
# 三个数字分别表示u(拥有者)、g(同组用户)、o(其他用户)的权限;
# 4(可读)+2(可写)=6(读写)110
# r表示递归子目录

su root         # switch user。切换到root用户
su passwd root  # 修改root用户密码

# 查看服务器系统信息
uname -a
# 修改主机名
vim /etc/hostname
# 显示当前用户名称,必须大写
echo $USER

# 迁移文件
scp wewe-rss.tar root@47.119.18.145:/root
~~~

# 3、vim编辑器命令

~~~bat
# 进入命令行模式替换文件中的变量
:%s/cn.archive.ubuntu.com/mirrors.aliyun.com/g

# 复制一行文本
yy + p

# 删除一行
dd
# 使光标移动到文件内容首行
G
# 使光标移动到文件内容尾行
gg
# 使光标移动到指定行数
:<line_number>
~~~

# 4、sed命令用法

sed是一个流编辑器，用于对文本进行处理。

~~~bash
# 在指定行添加数据，-i表示--in-place
sed -i -e '1i/Hello, World!' test.txt
# 在文件末尾插入多条数据
sed -i -e '$a/Hello' -e '$a/World' test.txt
# 在文件最后追加数据
sed -i -e '$a/hello world' test.txt
# 将love替换成hello，s表示substitute，g表示global。# 如果不加g只会替换每一行首个匹配的关键字      
sed -i -e 's/love/hello/g' test.txt
# 删除第一至第四行的数据
sed -i -e '1,4d' test.txt

# p选项表示会打印文件内容，e选项表示引入一个sed命令
sed -n -e 'p' test.txt
# 打印第三至第六行的数据
sed -n -e '3,6p' /etc/passwd
# 多个指令可以使用分号隔离，输出第一和第四行
sed -n -e '1p;4p' /etc/passwd
~~~

# 5、grep命令用法

~~~bash
# 搜索包含hello的行
grep "hello" file.txt
# 从标准输入中搜索
echo -e "Hello\nLinux\nHello Linux" | grep "Linux"
# 使用-i选项忽略大小写
grep -i "hello" file.txt
# 使用-c选项统计匹配的行数
grep -c "Linux" file.txt
# 使用-r选项在目录中递归搜索
grep -r "printf" /path/to/code
# 使用-E选项启用扩展正则表达式
grep -E "Hello|Linux" file.txt
# 匹配以"Hello"开头的行
grep "^Hello" file.txt
# 匹配以"Linux"结尾的行
grep "Linux$" file.txt
# 匹配多个关键字，匹配字符串中间不能出现空格
grep 'driver\|m_b'
grep -E 'driver|m_b'
grep -e driver -e m_b
~~~

# 6、编译过程

~~~bash
1、预处理
g++ main.cpp -E -omain.i
头文件加载、宏替换、条件编译、去掉注释。

2、编译
g++ main.i -S
检查语法，并生成汇编代码。

3、汇编
g++ main.s -c
把汇编代码转换成二进制的机器码。

4、链接
g++ main.o -omain
找到调用函数的地址，链接对应上，合并在一起。
生成静态库:
ar rcs libmain.a main.o  # ".a"或“.lib”都表示静态库文件，它们的命名都以“lib”前缀开头，它们是'.o'文件的集合。

4.1、静态链接
加载(.a)文件，程序运行时不依赖静态库。
g++ main.cpp -omain -Iinclude -static  # 将程序所需要的库打包成到一起，生成的可执行文件可以跨设备运行，因为不需要再配置环境变量。
g++ main.cpp -omain -L. -linfo         # -L表示静态库路径，-l表示静态库名

4.2、动态链接
加载(.dll)文件，程序运行时依赖动态库。
g++ -fPIC -shared -olibmain.dll main.o  # 生成动态链接库
g++ main.cpp -omain -L. -linfo
~~~

# 7、Ubuntu镜像源

~~~bash
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ bionic-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ bionic-security main restricted universe multiverse

deb表示二进制文件
deb-src表示源码文件
bionic-security表示版本代号
main表示包含 Ubuntu 团队维护的自由软件
restricted包含受限制的软件，需符合特定的使用条件
universe包含社区维护的自由软件
multiverse包含非自由软件

各个Ubuntu版本对应代号
Ubuntu 16.04 LTS：Xenial Xerus
Ubuntu 18.04 bionic-security
Ubuntu 20.04 LTS：Focal Fossa
Ubuntu 21.04：Hirsute Hippo
Ubuntu 21.10：Impish Indri

# 自动查找并删除与已卸载的软件包相管理的所有依赖
apt autoremove libboost-mpi-dev  # 卸载该软件包及依赖的软件包(没有被其他软件包依赖)
apt remove libboost-mpi-dev      # 卸载该软件包以被依赖的
apt purge  # 清除软件包的配置
apt update # 更新软件安装源
aptitude install
~~~

