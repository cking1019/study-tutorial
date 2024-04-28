# 常用命令

在window系统中，很多内置命令(例如cd,dir,md等)会随着系统的启动自动加载至内存中，其可执行文件不会出现在system32目录之下。

~~~shell
# windows内置命令
DEL *.class        # 删除当前目录下以class结尾的文件
DEL /s /q *.class  # 删除当前目录及其子目录下所有以class结尾的文件

RD dir_name        # 删除空目录dir
RD /S /Q dir_name  # 删除空或非空目录dir。/s表示删除当前目录及其子目录内容

MD dir_name     # 创建目录
CD              # 显示当前目录
DIR             # 显示当前目录下的所有文件及文件夹

ECHO hello > test.txt   # 覆盖
ECHO hello >> test.txt  # 追加

ECHO hello & ECHO world  # 第一条命令执行成功与否，后面的命令都将被执行
ECHO hello && dir e:     # 第一条命令执行失败，后面的命令将不被执行

IPCONFIG   | FINDSTR IPv4   # 管道运算符，第一条命令的输出用作第二条命令的输入
ECHO hello || ECHO world  # 当第一条命令执行成功时，后面的命令不会执行

%~dp0  # 脚本文件执行目录
# ~1表示从开头第二个字符截取，-1表示从倒数第二个字符截取，一般用于消除两端双引号。
%rootDir:~1,-1% 
# 当前可执行批处理文件的文件名(无扩展名)
set APP_BASE_NAME=%~n0  
# %*表示将所有参数作为字符串传入传递命令行参数。例如: test.bat -a 1 -b 2
set CMD_LINE_ARGS=%*  

# 在bat文件中，call可以用于调用另一个批处理文件，并且会继承被调用批处理文件的环境变量
CALL text.bat

# 循环
for /l %i in (0,1,5) do calc   # for循环
for /d %i in (*) do echo %i    # 遍历当前目录下的所有目录
for /r %i in (*) do echo %i    # 遍历当前目录下的所有文件(绝对路径)
for %i in (*) do echo %i       # 遍历当前目录下的所有文件名
for /r JPEGImages %i in (*.jpg) do echo %i >> idx.txt # 将JPEGImages目录下的所有照片的绝对路径写入idx.txt
~~~
