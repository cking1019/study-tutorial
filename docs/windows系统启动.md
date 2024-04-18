# 摘要：

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

# 一、加电自检

# 二、引导

UEFI固件从ESP中加载EFI启动程式，包括BCD(Boot Configuration Data)文件等。BCD文件是一个注册表配置单元格式的二进制文件，包含了启动配置数据，如bootmgfw.efi、winload.efi等文件路径，并影响着系统启动的所有方面。

**winload.efi**加载bootstat.dat数据，并启动**ntoskrnl.exe**(Windows NT内核程序)可执行文件。ntoskrnl.exe会加载psshed.dll、hal.dll、ci.dll、bootvid.dll等动态链接库到内存中。

# 三、加载系统内核

ntoskrnl.exe会启动**smss.exe**(Session Manager Subsystem)可执行文件初始化系统变量，负责启动用户会话。

执行步骤如下：

1. 创建系统环境变量；

2. 系统环境进行初始化；

3. 创建虚拟内存页面文件；

4. 对一些必要的文件进行重命名。

初始化后，ntoskrnl.exe还会启动**csrss.exe**(Client Sever Runtime Subsystem)，其作用是管理Windows图形相关任务，以及创建和删除线程。

# 四、系统初始化

ntoskrnl.exe会先后启动**services.exe**、**logonUI.exe**、**winlogon.exe**、**lsass.exe**。

- services.exe：启动和停止服务。

- logonUI.exe：启动系统登录界面。
- winlogon.exe：Windows NT用户登录程序，以及管理用户登录和退出。
- lsass.exe：本地安全权限服务，用于计算机本地安全和登录策略。

**userinit.exe**: 系统关键进程，管理启动顺序。

**svchost.exe**: 服务主进程，用于运行服务。

**explorer.exe**: Windows资源管理器，用于显示系统的桌面环境、桌面图标，以及文件管理等。