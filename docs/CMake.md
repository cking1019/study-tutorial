# 3、CMake变量

## find_package

~~~txt
find_package(OpenCV 3 REQUIRED)命令执行流程：
1. 进入搜索路径：/usr/local/share/OpenCV
2. 找到OpenCVConfig.cmake文本，并执行该文件
3. 定义OpenCV_INCLUDE_DIR、OpenCV_LIBS、OpenCV_DIR等变量
4. 在Cmakelists.txt文件中引用完变量后完成编译
~~~

find_package是一个搜包命令，该命令有两种工作模式，分别是module与config，这两种工作模式决定了不同的搜索包路径。通过一些特定的规则找到<package_name>Config.cmake包配置文件，执行该配置文件，从而定义一些变量，通过这些变量可以准确定位库的头文件与库文件，从而完成编译。
**REQUIRED**：可选字段，表示一定要找到该包，找不到则立即停掉整个CMake。如果不指定该字段，那么CMake会继续执行。
**COMPONENTS**：可选字段，表示查找的包中必须要找到的组件，如果任何一个找不到就算失败，类似于required，导致CMake停止执行。

### module模式(默认)

module模式默认只有两个查找路径，CMAKE_MODULE_PATH和CMake安装路径下的Modules目录。
搜包路径次序为：CMAKE_MODULE_PATH, CMAKE_ROOT
先在CMAKE_MODULE_PATH变量对应的路径中查找。如果路径为空，或者路径中查找失败，则在CMake安装目录(即CMAKE_ROOT变量)下的Modules目录下(/usr/share/cmake-3.10)查找。

### config模式

只有在find_config中制定了config或no_module等关键字，或者module模式查找