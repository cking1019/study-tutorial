# 1、常用命令

Git是一种分布式版本控制系统，用于跟踪项目中的代码和文件的变化，旨在提供高效、灵活和可靠的版本控制。

**常用命令：**

~~~shell
git config --local  -l  # 查看项目配置信息
git config --global -l  # 查看全局配置信息
git config --system -l  # 查看系统配置信息
git config -l           # 显示local、global、system下所有的配置信息

# 删除当前分支下所有.pyc文件的缓存，然后再push，即可删除远程分支的.pyc文件
git rm --cached *.pyc
git rm --cached -r target/

git status  # 查看当前状态。

git checkout -b dev  # 建立一个新的本地分支dev。
git branch -a  # 查看所有的分支。
git branch -D dev  # 删除本地分支dev。

git clone https://gitee.com/cking1019/comm-engine.git  # 克隆项目到本地。

git add .              # 将所有文件提交至暂存区
git commit -m 'init'   # 将暂存区的所有文件提交至本地仓库
git push origin master # 将本地仓库的所有文件提交至远程仓库

# 添加远程仓库地址的别名origin
git remote add origin https://gitee.com/cking1019/comm-engine.git
git remote rm origin  # 删除远程仓库地址origin

git pull origin main  # 拉取远程仓库下main分支的代码并与本地代码合并
# pull=fetch+merge。fetch从远程仓库拉取最新版到本地，merge自动合并来自远程仓库的代码。

# 获取远程master的分支的代码到临时新建的temp
git fetch origin master:temp
# 查看temp分支与当前分支的差异
git diff temp  
# 将临时分支temp合并到当前分支
git merge tmep
~~~

~~~bash
git pull origin <远程分支名>:<本地分支名>
git pull origin <远程分支名>

git push origin <本地分支名>:<远程分支名>
git push origin <本地分支名>
~~~
