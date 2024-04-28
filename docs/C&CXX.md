# 1、CXX头文件

~~~bat
<algorithm>  # 算法库
<iostream>   # 输入输出流，继承了所有关于输入流、输出流的头文件
<vector> # 动态数组
<set>    # 包括set、multiset
<map>    # 包括map、multimap
<stack>  # 栈
<queue>  # 队列
<list>   # 链表
<string> # STL中的字符串库
<bitset>
<complex>
<deque>
<exception>
*<fstream>
<functional>
<iomanip>
<iterator>
<limits>
<locale>
<memory>
<new>
<numeric>
<sstream>
<stdexcept>
<strstream>
<typeinfo>
<utility>
<valarray>

# cxx11
<array>   # 数组
<random>  # 生成随机数
<regex>   # 正则表达式
<thread>  # 线程
<unoredered_map>  # 无序键值对容器
<unoredered_set>  # 无序集合
<atomic>
<chrono>
<codecvt>
<condition_variable>
<forward_list>
<future>
<initializer_list>
<mutex>
<ratio>
<scoped_allocator>
<system_error>
<tuple>
<tupe_traits>
<typeindex>

# 包括.h头文件的Cxx头文件，以c开头的头文件都包含在std命名空间下
<cmath>   # 数学公式库
<cstdio>  # C++标准输入输出库(scanf、printf)，包括<stdio.h>
<cstring> # C++字符串库，包括<string.h>。包括c字符串相关的函数
<ctime>   # 时间库
<cstdlib> # 标准库
<cassert>
<cctype>
<cerrno>
<cfloat>
<climits>
<clocale>
<csetjmp>
<csignal> # 信号处理
<cstdarg>
<cstddef>
<cwchar>
<cwtype>
~~~

# 2、容器

容器库是类模板与算法的汇集，允许程序员简单地访问常见的数据结构，例如顺序表、链表、栈、队列等。有三类容器——顺序容器、关联容器、无序关联容器，每种容器都为不同的操作而设计。容器管理为元素分配存储空间，并通过迭代器访问。

## 1、顺序容器

包括顺序表和链表

- array

- vector 动态数组

- list 链表

通过顺序容器可以实现stack、queue、priority_queue等适配器，在根据“先进先出”、“先进后出”等规则定义接口。

## 2、有序关联容器

根据键值自动排序，通过O(logn)的时间复杂度访问数据结构

- set：会将列表从小到大自动排序，并删除重复元素。

- map：会根据键值对其字典排序，并删除重复键值对。

- multiset：会将列表从小到大自动排序，不会删除重复元素。

- multimap：会根据键值对其字典排序，不会删除重复键值对。插入的数据类型为std::pair<T, T>，且不可用[]访问数据。

## 3、无序关联容器

不会自动排序，通过O(1)或O(n)的时间复杂度访问数据结构

- unordered_set

- unordered_map

- unordered_multiset

- unordered_multimap

  











