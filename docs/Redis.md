# Redis常用命令

## 1、字典

~~~cmd
hset user name Demo
hset user age 25

hget user name
hget user age

hmset user name Demo age 25
hmget user name age

hgetall user
hkeys user
hvals user
# 判断是否存在
hexists user name
# 获取字段数量
hlen user
# 获取字段值
hdel user name
~~~

## 2、集合

~~~cmd
sadd langs java python go c++

smembers langs

sismember langs java

scard langs

srem langs java python
~~~

## 3、列表

~~~cmd
lpush sports foodball basketball pingpong

lrange sports 0
lrange sports 0 2

lpush nums 111 222 111 222 222 333 222 222
# count=0:删除所有；count>0:删除左端前count个；count<0:删除右端前count个。
lrem key count value
lrem nums 0 111

ltrim key start stop
~~~

## 4、基本命令

~~~cmd
# 获取所有键名
keys *
# 获取键总数
dbsize
exists user
del user
# 查看键类型
type user
move user 2
# -1:永不过期
ttl user -1
expire user 60
persist user

rename user my_user
# 如果key不存在则建立，否则修改。
set num 100
get num
incr num

mset num1 100 num2 200
mget num1 num2
~~~

## 启动命令

~~~cmd
redis-server --port 6379

redis-server --service-install

redis-server --service-start

redis-server --service-stop
# 测试连通性
ping
~~~

字符串是Redis中最基本的数据类型，其单个数据存储的最大空间为512MB。

