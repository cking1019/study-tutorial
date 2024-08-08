# 1、系统启动过程

## 摘要：

~~~mermaid
graph LR
硬件-->C(BIOS)-->操作系统
~~~

BIOS启动模式：UEFI(Unified Extensible Firmware Interface)

磁盘分区表：GPT

参数名称可以在cmd下运行msinfo32.exe进行对照。

ESP(EFI System Partition)，即为EFI系统分区。

BIOS为软件，它有两种启动方式，分别为Legacy和UEFI。现在目前留下UEFI启动方式。

**系统启动过程：**

1. 加电自检；
2. 引导；
3. 加载系统内核；
4. 系统初始化。

## 1.1、加电自检

## 1.2、引导

UEFI固件从ESP中加载EFI启动程式，包括BCD(Boot Configuration Data)文件等。BCD文件是一个注册表配置单元格式的二进制文件，包含了启动配置数据，如bootmgfw.efi、winload.efi等文件路径，并影响着系统启动的所有方面。

**winload.efi**加载bootstat.dat数据，并启动**ntoskrnl.exe**(Windows NT内核程序)可执行文件。ntoskrnl.exe会加载psshed.dll、hal.dll、ci.dll、bootvid.dll等动态链接库到内存中。

## 1.3、加载系统内核

ntoskrnl.exe会启动**smss.exe**(Session Manager Subsystem)可执行文件初始化系统变量，负责启动用户会话。

执行步骤如下：

1. 创建系统环境变量；

2. 系统环境进行初始化；

3. 创建虚拟内存页面文件；

4. 对一些必要的文件进行重命名。

初始化后，ntoskrnl.exe还会启动**csrss.exe**(Client Sever Runtime Subsystem)，其作用是管理Windows图形相关任务，以及创建和删除线程。

## 1.4、系统初始化

ntoskrnl.exe会先后启动**services.exe**、**logonUI.exe**、**winlogon.exe**、**lsass.exe**。

- services.exe：启动和停止服务。

- logonUI.exe：启动系统登录界面。
- winlogon.exe：Windows NT用户登录程序，以及管理用户登录和退出。
- lsass.exe：本地安全权限服务，用于计算机本地安全和登录策略。

**userinit.exe**: 系统关键进程，管理启动顺序。

**svchost.exe**: 服务主进程，用于运行服务。

**explorer.exe**: Windows资源管理器，用于显示系统的桌面环境、桌面图标，以及文件管理等。

# 2、资源管理器优化

## 2.1、移除导航窗格多余目录

~~~
计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
~~~

| 文件夹 |             注册表中对应项             |
| :----: | :------------------------------------: |
| 3D对象 | {0DB7E03F-FC29-4DC6-9020-FF41B59E513A} |
|  视频  | {f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} |
|  图片  | {24ad3ad4-a569-4530-98e1-ab02f9417aa8} |
|  文档  | {d3162b92-9365-467a-956b-92703aca08af} |
|  下载  | {088e3905-0323-4b02-9826-5d99428e115f} |
|  音乐  | {3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} |
|  桌面  | {B4BFCC3A-DB2C-424C-B029-7FE99A87C641} |

删除对应项即可删除对应目录。

## 2.2、删除快速访问

~~~
计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer
~~~

新建HubMode，选择DWORD类型，改值为1。

## 2.3、删除OneDrive

~~~
计算机\HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}
~~~

找到System.IsPinnedToNameSpaceTree健，改值为0。



# 3、注册表

~~~txt
HKEY_CLASSES_ROOT
HKEY_CURRENT_USER
HKEY_LOCAL_MACHINE
HKEY_USERS
HKEY_CURRENT_CONFIG
看是五个分支，其实就是HKEY_LOCAL_MACHINE、HKEY_USERS这两个才是真正的注册表键，其它都是从某个分支映射出来的，
相当于快捷方式或是别名，这样的话看注册表就简单了许多了，现在说一下每个分支的作用：
HKEY_CLASSES_ROOT：列出当前计算机注册的所有COM服务器和与应用程序相关联的所有文件扩展名。
HKEY_CURRENT_USER：保存着当前登录到由这个注册服务的计算机上的用户配置文件。
HKEY_LOCAL_MACHINE：保存操作系统及硬件相关信息的配置单元，它是一个公共的配置信息与具体用户无关，其中关键是两个键值
SOFTWARE：保存着与这台电脑中安装的应用程序相关的设置。
SYSTEM：WINDOWS所装载的设备驱动程序以及当WINDOWS启动时所需要的各种参数。
HKEY_USERS：包含当前计算机所有用户配置文件。
HKEY_CURRENT_CONFIG： 计算机当前会话中的所有硬件配置信息。
~~~

