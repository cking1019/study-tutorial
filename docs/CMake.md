# 1、函数

~~~cmake
cmake_minimum_required(VERSION 3.10)
project(NorthProject)  # PROJECT_NAME的变量值

# 添加预处理，防止在release模式下，输出的日志信息不显示文件名，行号等信息
add_definitions(-DQT_MESSAGELOGCONTEXT) # 添加预处理命令
add_compile_options(-g -std=c++11)      # 增加编译选项

set(CMAKE_AUTOMOC ON)  # 开启MOC模式
set(CMAKE_AUTORCC ON)  # 开启RCC模式
set(CMAKE_AUTOUIC ON)  # 开启UIC模式
set(CMAKE_BUILD_TYPE "Release")         # 设置构建类型
set(QT_VERSION "5.15.1" CACHE INTERNAL "Qt version info")
# 会初始化所有目标属性的LIBRARY_OUTPUT_DIRECTORY、ARCHIVE_OUTPUT_DIRECTORY、RUNTIME_OUTPUT_DIRECTORY的值
# 动态库输出路径
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/release/lib)
# 静态库输出路径
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/release/static)
# 可执行文件输出路径
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/release)

# 添加库文件搜索路径
find_package(Qt5 REQUIRED COMPONENTS Core Network Gui Widgets Sql)
# REQUIRED: 可选字段，表示一定要找到该包，找不到则立即停掉整个CMake。如果不指定该字段，那么CMake会继续执行
# COMPONENTS: 可选字段，表示查找的包中必须要找到的组件，如果任何一个找不到就算失败，类似于required，导致CMake停止执行
# Module 模式：在CMake模块路径中查找 Find<PackageName>.cmake 文件来寻找软件包。
# Config 模式：通过软件包提供的配置文件（<PackageName>Config.cmake 或 <lower-case-package-name>-config.cmake）来查找软件包。
# find_package的搜包模式默认为Module模式。

# 文件操作
file(COPY ${CMAKE_SOURCE_DIR}/static DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/release/conf/)
# 添加子目录
add_subdirectory(src/kl_client)

# 添加目标依赖项
add_custom_target(${PROJECT_NAME} ALL 
                    DEPENDS NebulaNorth NebulaTest NebulaUI)
# 添加目标命令
add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/conf/Common.json ${CMAKE_SOURCE_DIR}/release/conf/
)

# 将当前目录下的源程序加载至srcs变量中
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} srcs)
aux_source_directory(../ srcs)

# 头文件搜索路径
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR} ../)

# 库链接
link_libraries(${PROJECT_SOURCE_DIR}/lib)  # 全局链接的库文件，会影响项目中的所有目标
target_link_libraries(snake easyx winmm)   # 特定目标链接的库文件，只会影响指定目标及其依赖
~~~

# 2、变量

~~~cmake
PROJECT_SOURCE_DIR # CMake顶层目录
CMAKE_BINARY_DIR   # 顶层目录
CMAKE_SOURCE_DIR   # 顶层目录

CMAKE_VERSION      # 当前CMake版本
CMAKE_ROOT         # CMake安装根目录

CMAKE_LIBRARY_OUTPUT_DIRECTORY  # 动态库输出路径
CMAKE_ARCHIVE_OUTPUT_DIRECTORY  # 静态库输出路径
CMAKE_RUNTIME_OUTPUT_DIRECTORY  # 可执行文件输出路径

CMAKE_CXX_FLAGS_RELEASE # release编译，默认值为-O3 -DNDEBUG
CMAKE_CXX_FLAGS_DEBUG   # debug编译，默认值为-g

PROJECT_NAME
CMAKE_CURRENT_BINARY_DIR  # 构建目录
CMAKE_CURRENT_SOURCE_DIR  # 当前路径
~~~

