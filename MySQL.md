# 1、启动与备份

~~~sql
# 导入sql文件到数据库
use database_name
SOURCE C:\Users\Demo\Desktop\data.sql

# 导出当前数据库下的所有表结构和表数据到指定文件
mysqldump -u root -p mvp_prod > C:/Users/Demo/Desktop/data.sql

# 连接数据库
mysql -h localhost -P 3306 -u user -p123456

# 当前数据库
show databases;

# 暂停当前服务，需要管理员权限
net stop mysql_mvp
# 将MySQL从服务中卸载
mysqld --remove mysql
# 将MySQL注册到Windows服务中
mysqld --install mysql
# 初始化数据库，包括1、创建数据目录；2、初始化系统表空间；3、生成root密码。
mysqld --initialize # 初始化后为无密码登录
# 修改root密码
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';

# 设置mysql用户支持外网访问
update mysql.user set host='%' where user='root';
# 刷新mysql权限
FLUSH PRIVILEGES;

# 设置MySQL服务允许外网访问
[mysqld]
bind-address=0.0.0.0
~~~

# 2、数据库术语及操作

MySQL分为**DDL**、**DML**、**DQL**、**DCL**等四种操作语言

## 2.1、数据定义语言(DDL)

数据定义语言DDL(Data Definition Language)，操纵数据库和表；

~~~sql
# 使用数据库
USE menagerie
# 显示当前所有数据库
SHOW DATABASES;
# 显示当前数据库下的所有表
SHOW TABLES;
# 表述当前表结构
DESC tbl_name;
# 查看当前数据库
SELECT DATABASE();

# 创建数据库
CREATE DATABASE menagerie;
# 创建表
CREATE TABLE child (
    id INT,
    parent_id INT,
    INDEX par_ind (parent_id),
    FOREIGN KEY (parent_id)
        REFERENCES parent(id)
        ON UPDATE CASCADE  # 级联，父表更新时，子表实时更新；若没有，父表id更新会报错。
        ON DELETE CASCADE  # 级联，父表删除时，子表实时删除；若没有，父表id删除会报错。
) ENGINE=INNODB;

CREATE TABLE animals (
    grp ENUM('fish','mammal','bird') NOT NULL,
    id MEDIUMINT AUTO_INCREMENT NOT NULL,
    name CHAR(30) NOT NULL,
    PRIMARY KEY (grp,id)
) ENGINE=MyISAM;
# 如果包含了多个索引(主键默认为索引)，那么在生成序列值时，MySQL 将忽略 PRIMARY KEY。

# 删除表
DROP TABLE child;
~~~

## 2.2、数据操作语言(DML)

数据操作语言(Data Manipulation Language )：对数据进行增删改；

~~~sql
# 插入
INSERT INTO pet VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);

# 更新表
UPDATE pet 
SET birth = '1989-08-31' 
WHERE name = 'Bowser';

# 清空表数据
DELETE FROM pet;
~~~

## 2.3、数据查询语言(DQL)

数据查询语言(Data Query Language)：用来查询数据

~~~sql
SELECT    字段1，字段2....(字段列表)
FROM      表一，表二....(表名列表) 
WHERE     条件1，条件2...(条件列表) 
GROUP BY  分组字段
HAVING    分组之后的条件
ORDER BY  按什么字段排序
LIMIT 6   分页限定

SELECT * FROM pet WHERE birth >= '1998-1-1';
SELECT * FROM pet WHERE species = 'dog' AND sex = 'f';
SELECT * FROM pet WHERE species = 'snake' OR species = 'bird';
SELECT * FROM pet WHERE (species = 'cat' AND sex = 'm') 
	   OR (species = 'dog' AND sex = 'f');

SELECT DISTINCT owner FROM pet;
SELECT name, birth FROM pet ORDER BY birth;
SELECT name, birth FROM pet ORDER BY birth DESC;
SELECT name, species, birth FROM pet ORDER BY species, birth DESC;
SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR, birth, CURDATE()) AS age FROM pet;

# 模式匹配
# 匹配开头
SELECT * FROM pet WHERE name LIKE 'b%';
# 匹配结尾
SELECT * FROM pet WHERE name LIKE '%fy';
# 匹配包含
SELECT * FROM pet WHERE name LIKE '%w%';
# 匹配字段长度为五个字符的记录
SELECT * FROM pet WHERE name LIKE '_____';

# 利用正则表达式
SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b');

# 多表连接
SELECT pet.name, TIMESTAMPDIFF(YEAR,birth,date) AS age, event1.remark 
FROM pet 
INNER JOIN event1 ON pet.name = event1.name WHERE event1.type = 'litter';

# 左连接
SELECT s1.article, s1.dealer, s1.price
FROM shop s1 
LEFT JOIN shop s2 ON s1.price < s2.price
WHERE s2.article IS NULL;

# 限制记录数
SELECT article, dealer, price
FROM shop
ORDER BY price DESC
LIMIT 1;
~~~

聚合函数：

1. count()
2. max()、min()、sum()、avg()
3. lower()、upper()
4. curdate()
5. curtime()
6. now()

## 2.4、数据控制语言(DCL)

数据控制语言(Data Control Language )：授权。

~~~sql
# 创建一个新用户
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';

# 删除用户
DROP USER 'username'@'localhost'

# 授权
GRANT ALL ON menagerie.* TO 'your_mysql_name'@'your_client_host';

# 查看当前mysql下的所有用户
SELECT user, host FROM mysql.user;

# 插入生成 AUTO_INCREMENT 值的记录后，可以像这样获取该值。
# 如果使用一条 INSERT 语句插入多条记录，LAST_INSERT_ID() 只返回为第一条插入记录生成的值。
SELECT LAST_INSERT_ID();
~~~

# 3、约束

~~~sql
PRIMARY KEY: 默认为字段建立索引，其索引名为primary_{id},id从0开始计数
FOREIGN KEY
NOT NULL
UNIQUE
AUTO_INCREMENT
ON UPDATE CASCADE
ON DELETE CASCADE
~~~

# 4、事务

- 原子性：不可分隔的最小操作单元
- 持久性：事务提交或回滚，数据库持久化保存数据
- 隔离性：事务之间相互隔离
  - 脏读
  - 虚读
  - 幻读
- 一致性：事务操作前后总量不变

~~~sql
START TRANSACTION

COMMIT

ROLLBACK
~~~

# 5、索引

索引是帮助MySQL高效获取数据的数据结构。更通俗的说，数据库索引好比是一本书前面的目录，能加快数据库的查询速度。 一般来说索引本身也很大，不可能全部存储在内存中，往往存储在磁盘上的文件（可能存储在单独的索引文件，也可能和数据一起存储在数据文件）。 数据量大时，减少查询时间效果显著。

**优点**：可以提高数据检索的效率，降低数据库的IO成本，通过索引列对数据进行排序，降低数据排序的成本，降低了CPU的消耗。如果按照索引列的顺序进行排序，对应order by语句来说，效率就会提高很多。

**缺点**：索引会占据磁盘空间，索引虽然会提高查询效率，但是会降低更新表的效率。比如每次对表进行增删改操作，MySQL不仅要保存数据，还有保存或者更新对应的索引文件。

**索引名命名格式为** ：idx _ 表名 _字段名

~~~sql
# 显示表中的索引
SHOW INDEX FROM tbl_name
# 创建索引
CREATE INDEX idx_name ON tbl_name(name);
# 为表添加索引
ALTER TABLE tbl_name ADD INDEX idx_name (name);
# 删除索引
ALTER TABLE tbl_name DROP INDEX idx_name;
# 删除主键索引
ALTER TABLE tbl_name DROP PRIMARY KEY;
~~~

- 唯一索引：unique index
- 主键索引：primary key
- 聚集索引
- 非聚集索引

# 6、MySQL数据工具

1. **mysqld**: 服务器启动脚本。该脚本用于使用 System V 风格运行目录的系统，该目录包含针对特定运行级别启动系统服务的脚本。它调用 mysqld_safe 启动 MySQL 服务器。mysqld:SQL 守护进程（即 MySQL 服务器）。要使用客户端程序，mysqld 必须运行，因为客户端是通过连接服务器来访问数据库的。
3. **mysql**: 用于交互式输入 SQL 语句或以批处理模式从文件执行这些语句的命令行工具。
3. **mysqldump**: 将 MySQL 数据库转储为 SQL、文本或 XML 文件的客户端。

# 7、引擎

## 7.1、MyISAM引擎

回到 MyISAM，其索引结构如下图所示，由于 MyISAM 的索引文件仅仅保存数据记录的地址。在 MyISAM 中，主索引和辅助索引（Secondary key）在结构上没有任何区别：

![](https://pic3.zhimg.com/80/v2-6cfc13ac2050f4253e055dbbad1da572_1440w.webp)

MyISAM 中索引检索的算法为首先按照 B+Tree 搜索算法搜索索引，如果指定的 Key 存在，则取出其 data 域的值，然后以 data 域的值为地址，读取相应数据记录。

## 7.2、InnoDB引擎

对于 InnoDB 来说，表数据文件本身就是按 B+Tree 组织的一个索引结构，这棵树的叶节点 data 域保存了完整的数据记录。

![](https://pic3.zhimg.com/80/v2-71c52679a39e5f6758987e9d3c3d3d0e_1440w.webp)

由于 InnoDB 利用的数据库主键作为索引 Key，所以 InnoDB 数据表文件本身就是主索引，且因为 InnoDB 数据文件需要按照主键聚集，所以使用 InnoDB 作为数据引擎的表需要有个主键，如果没有显式指定的话 MySQL 会尝试自动选择一个可以唯一标识数据的列作为主键，如果无法找到，则会生成一个隐含字段作为主键，这个字段长度为6个字节，类型为长整形。

# 配置文件[my.ini]

~~~ini
[mysqld]
port=3306
bind-address=0.0.0.0
basedir=D:/tools/mysql-8.0.34-winx64
datadir=D:/tools/mysql-8.0.34-winx64/data
max_connections=200
max_connect_errors=10
character-set-server=utf8mb4
default-storage-engine=INNODB
authentication_policy=caching_sha2_password
[mysql]
default-character-set=utf8
[client]
port=3306
default-character-set=utf8
~~~







