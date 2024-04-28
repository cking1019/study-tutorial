# 1、cmd文件与bat文件的区别

```txt
cmd文件运行在32位系统的命令窗口，是Windows NT的命令脚本；
bat是DOS命令，可在任何DOS环境下使用，是ms dos批处理文件。
```

# 2、删除目录或文件总结

~~~shell
DEL *.class        # 删除当前目录下以class结尾的文件
DEL /s /q *.class  # 删除当前目录及其子目录下所有以class结尾的文件

RD dir_name        # 删除空目录dir
RD /S /Q dir_name  # 删除空或非空目录dir。/s表示删除当前目录及其子目录内容

MD dir_name     # 创建目录
CD              # 显示当前目录
DIR             # 显示当前目录下的所有文件及文件夹
~~~

**其他**

~~~shell
@ECHO OFF  # 关闭自身命令的回显
@REM 'comment'  # 注解

ECHO hello > test.txt   # 覆盖
ECHO hello >> test.txt  # 追加

ECHO hello & ECHO world  # 第一条命令执行成功与否，后面的命令都将被执行
ECHO hello && dir e:     # 第一条命令执行失败，后面的命令将不被执行

IPCONFIG | FINDSTR IPv4   # 管道运算符，第一条命令的输出用作第二条命令的输入
ECHO hello || ECHO world  # 当第一条命令执行成功时，后面的命令不会执行

%~dp0  # 脚本文件执行目录
%rootDir:~1,-1%  # ~1表示从开头第二个字符截取，-1表示从倒数第二个字符截取，一般用于消除两端双引号。
set APP_BASE_NAME=%~n0  # 当前可执行批处理文件的文件名(无扩展名)
set CMD_LINE_ARGS=%*  # %*表示将所有参数作为字符串传入传递命令行参数。例如: test.bat -a 1 -b 2


XCOPY D:\desktop E:\desktop /E /H /Y
# /E 包括空文件
# /H 包括隐藏文件
# /Y 禁止提示确定要覆盖的目标文件

CALL [drive:][path]filename [batch-parameters]
# filename为批处理文件，batch-parameters指定批处理文件的参数
~~~

# 3、常用命令

~~~shell
# 打开开机启动目录
EXPLORER C:\Users\Demo\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
# 关机命令
SHUTDOWN /R
# 修改注册表
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSecondsInSystemClock /t REG_DWORD /d 1
~~~

# 4、for循环总结

~~~shell
for /l %i in (0,1,5) do calc   # for循环
for /d %i in (*) do echo %i    # 遍历当前目录下的所有目录
for /r %i in (*) do echo %i    # 遍历当前目录下的所有文件(绝对路径)
for %i in (*) do echo %i       # 遍历当前目录下的所有文件名
for /r JPEGImages %i in (*.jpg) do echo %i >> idx.txt # 将JPEGImages目录下的所有照片的绝对路径写入idx.txt
~~~

# 5、注册Windows服务

~~~bat
sc create ssh binpath= D:\OpenSSH-Win64\sshd.exe  # 等号后面必须有空格
~~~

