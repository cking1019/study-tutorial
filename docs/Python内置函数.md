# 1、数值运算

~~~python
max(x, key=None)
min(x, key=None)
sum(x, start=0)  # 将x中的数求和后再加上start
pow(x, y, mod)   # 第三个参数用于取模
divmod(2, 1)     # 返回一个元组，包括商和余数
abs(x)
round(number, ndigits)  # 对浮点数number四舍五入取ndigits位
~~~

# 2、数据类型转换

~~~python
int(x)
str(x)
float(x)
bool(x)
~~~

# 3、进制转换

~~~python
bin(x)
oct(x)
hex(x)
ord(x)
chr(x)
~~~

# 4、数组操作

~~~python
list(x)
dict(x)
set(x)
tuple(x)
enumerate(x)  # 返回一个元组，包括索引和值
range(x)
iter(x)
~~~

# 5、排序操作

~~~python
sorted(x, key=None, reverse=False)  # key=lambal x: x[1]
reversed(seq)
~~~

# 6、序列操作

~~~python
all(x_list)  # 判断集合中的元素是否都为真
any(x_list)  # 判断集合中的元素是否存在真

map(func, iter)  # func函数将迭代iter中的每一个元素
zip(ls1, ls2)    # 将两个列表或多个列表对应起来，并生成元组
~~~

# 7、对象元素操作

~~~python
id(object)    # 返回object对象的标识值，且在对象生命周期中保持唯一
hash(object)  # 返回哈希值
type(object)  # 返回object对象的所属类型
dir(object)
len(object)
format(value, format_spec)
vars(object)
~~~

# 8、属性操作

~~~python
isinstance(object, classinfo)
issubclass(class, classinfo)
hasattr(object, name)
getattr(object, name)
setattr(object, name, value)
delattr(object, name)
__import__(name)
callable(object)
~~~

# 9、变量操作

~~~python
globals()
locals()
~~~

# 10、人机交互操作

~~~python
print(*object, end='\n', file=sys.stdout)
input('请输入：')  # 接受一个字符串参数
open(file, mode='r')
~~~

# 11、编译操作

~~~python
eval(expression)
~~~

# 12、装饰器函数

~~~python
property()  # 可以将类方法转换成类属性使用
classmethod()
staticmethod()
~~~

# 13、其他

~~~python
help()  # 用户查看函数或模块用途的详细说明
~~~

# 14、列表内置函数

~~~python
clear()    # 清空列表
copy()     # 浅复制
sort()     # 排序，默认升序
reverse()  # 原地逆序

append(x)         # 将元素x插在列表末尾
insert(index, x)  # 将元素x插在列表index位置
extend(list2)     # 将列表list2追加到当前列表末尾

remove(x)   # 将列表中的x元素移除
pop(index)  # 将列表中index索引处的元素返回并将其删除
index(x)    # 返回元素x在列表中的索引
count(x)    # 返回元素x在列表中出现的次数
~~~

# 15、字典内置函数

~~~python
clear()            # 清空字典
copy()             # 浅复制
update(dict_item)  # 把键值对更新到原字典中

get(key)  # 返回指定键key的值
pop(key)  # 返回指定键key的值，并删除

items()   # 返回字典中(键,值)元组的迭代器
keys()    # 返回字典中所有的键的迭代器
values()  # 返回字典中所有的值的迭代器
~~~

# 16、内置模块

~~~
内置模块：time、os、sys
~~~

# 17、builtins内置模块

~~~python
abs
all
any
ascill
bin
breakpoint
callable
chr
compile
copyright
credits
delattr
dir
divmod
eval
exec
exit
format
getattr
globals
hasattr
hash
help
hex
id
input
isinstance
issubclass
iter
len
license
locals
max
min
next
oct
open
ord
pow
print
quit
repr
round
setattr
sorted
sum
vars
~~~

