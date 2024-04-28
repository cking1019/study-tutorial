# 1、启动与备份

~~~sql
# 导入sql文件到数据库
SOURCE C:\Users\Demo\Desktop\data.sql

# 导出当前数据库下的所有表结构和表数据到指定文件
mysqldump -u root -p mvp_prod > C:/Users/Demo/Desktop/data.sql
# 从远程服务器中导出sh
mysqldump -h 10.100.102.143 -u root -p test > ./data.sql

# 连接数据库
mysql -h localhost -P 3306 -u user -p123456

# 显示授权信息
show grants for 'ck' @'localhost';

# 暂停当前服务，需要管理员权限
net stop mysql_mvp
# 将MySQL从服务中卸载
mysqld --remove mysql
# 将MySQL注册到Windows服务中
mysqld --install mysql
# 初始化数据库，包括1、创建数据目录；2、初始化系统表空间；3、生成root密码。
mysqld --initialize
mysqld --initialize-insecure  # 初始化后为无密码登录

# 设置mysql用户支持外网访问
UPDATE mysql.user SET host = '%' WHERE user='ck';

create user 'ck' @'localhost' identified by '123456';

# 跳过mysql密码登录
mysqld --skip-grant-tables --shared-memory --console
# 进入mysql后，设置无密码登陆
UPDATE mysql.user SET authentication_string='' WHERE user='root';

# 修改root用户的密码为123456
ALTER user 'root'@'localhost' IDENTIFIED BY '123456';
~~~

# 2、数据库术语及操作

MySQL有四种操作语言，分别是**DDL**、**DML**、**DQL**、**DCL**。

DDL：数据定义语言。包括创建数据库、创建表、修改表字段、删除表等操作；

DML：数据操作语言。包括增加、删除、修改等操作；

DQL：数据查询语言。包括查找操作；

DCL：数据控制语言。包括授权与撤回操作。

## 2.1、数据定义语言(DDL)

数据定义语言DDL(Data Definition Language)，操纵数据库和表；包括create、drop、alter等语句。

~~~sql
# 使用数据库
USE menagerie;
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

DROP USER 'ck'@'localhost';
drop：
1、drop是DDL，会隐式提交，所以，不能回滚，不会触发触发器。
2、drop语句删除表结构及所有数据，并将表所占用的空间全部释放。
3、drop语句将删除表的结构所依赖的约束，触发器，索引，依赖于该表的存储过程/函数将保留,但是变为invalid状态。

alter table <表名>
[add <新字段名><数据类型><约束条件>]添加新的字段
[drop <字段>]删除表中某个字段
[modify <字段><数据类型>]修改字段的类型
~~~

## 2.2、数据操作语言(DML)

数据操作语言(Data Manipulation Language )：对数据进行增删改，包括insert、delete、update等语句；

~~~sql
# 插入
INSERT INTO pet VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);

# 更新表
UPDATE pet 
SET birth = '1989-08-31' 
WHERE name = 'Bowser';

# 清空表数据
DELETE FROM pet;

# 删除用户
delete from mysql.user where user = 'ck';

delete：
1、delete是DML，执行delete操作时，每次从表中删除一行，并且同时将该行的的删除操作记录在redo和undo表空间中以便进行回滚（rollback）和重做操作，
但要注意表空间要足够大，需要手动提交（commit）操作才能生效，可以通过rollback撤消操作。
2、delete可根据条件删除表中满足条件的数据，如果不指定where子句，那么删除表中所有记录。
3、delete语句不影响表所占用的extent，高水线(high watermark)保持原位置不变。
~~~

## 2.3、数据查询语言(DQL)

数据查询语言(Data Query Language)：用来查询数据，包括select语句。

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
CREATE USER 'cking'@'localhost' IDENTIFIED BY '123456';

# 授权
grant all oN menagerie.* to 'ck'@'localhost';
grant all on school to 'ck'@'localhost';
revoke all on school from 'ck'@'localhost';

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

- 原子性：不可分隔的最小操作单元；
- 持久性：事务提交或回滚，数据库持久化保存数据；
- 隔离性：事务之间相互隔离；
  - 脏读
  - 虚读
  - 幻读
- 一致性：事务操作前后总量不变。

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



Q: 索引单个字段和索引多个字段的区别

A: 索引单个字段和索引多个字段的主要区别在于索引涉及的字段数量和索引的用途。

**索引单个字段**：

1. **适用性**：单个字段索引适用于单个字段的查询，可以加快特定字段的查询速度。
2. **查询效率**：单个字段索引可以提高单个字段的查询效率，但在涉及多个字段的查询时可能效果不明显。

**索引多个字段**：

1. **组合查询**：多个字段索引用于优化涉及多个字段的查询，在这种情况下，通过索引涉及的多个字段一起搜索数据，提高查询效率。
2. **联合性**：多个字段索引适用于需要按照多个字段组合进行查询、排序或连接的情况，可以更好地支持复杂查询需求。
3. **覆盖索引**：多个字段索引还可以用作覆盖索引，即可以满足查询的筛选条件和返回结果所需的字段，从而避免访问实际数据行，提高查询性能。

综上所述，单个字段索引适用于单个字段的查询优化，而多个字段索引适用于需要优化多字段组合查询的情况，可以更好地支持复杂查询需求并提高查询效率。



# 6、MySQL数据工具

1. **mysqld**: 服务器启动脚本。它调用 mysqld_safe 启动 MySQL 服务器。要使用客户端程序，mysqld 必须运行，因为客户端是通过连接服务器来访问数据库的。
3. **mysql**: 用于交互式输入 SQL 语句或以批处理模式从文件执行这些语句的客户端。
3. **mysqldump**: 将 MySQL 数据库转储为 SQL、文本或 XML 文件。

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

