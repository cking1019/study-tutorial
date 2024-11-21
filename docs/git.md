# 命令概要

~~~shell
clone    # 克隆
commit   # 提交
push     # 推送
pull     # fetch+merge拉取与合并
fetch    # 拉取
merge    # 合并
branch   # 分支
switch   # 切换
checkout # 移动HEAD指针
stash    # 暂存
rebase   # 合并(线性)
remote   # 远程
reset    # 回退(向前)
revert   # 回退(向后)
ls-files # 列出
tag      # 标签
describe # 描述
submodule   # 拉取子模块
cherry-pick # 合并记录
~~~

# 1、分支

Git是一种分布式版本控制系统，用于跟踪项目中的代码和文件的变化，旨在提供高效、灵活、可靠的版本控制。

~~~shell
# 分支
git branch     # 查看本地分支
git branch -a  # 查看本地分支与远程分支
git branch -v  # 查看本地分支和最新提交记录
git branhc -vv # 查看本地分支与远程分支最新提交记录
dev    f902d93 [origin/dev] 修改cmake支持Linux平台
master f902d93 [origin/master: gone] 修改cmake支持Linux平台
# gone表示当前分支已经与上游分支失去关联

# 将分支移动到前四个提交记录位置
git branch -f dev HEAD~4
# 将分支移动到指定提交记录
git branch -f dev 6d3d3f4e
# 上游分支
git branch -u origin/master      # 设置当前分支为上游分支为master
git branch --unset-upstream dev  # 删除dev分支的上游分支
git push -u origin master        # 当前分支还如果没有上游，需要先做一次提交
git branch bugFix                # 建立分支

# 查看dev分支与当前主分支的差异
git diff dev
# 将dev分支合并到当前主分支
git merge dev

# 切换分支
git switch bugFix
# 建立并切换
git checkout -b dev
# 删除远程分支
git push origin -d goods_alpha_CK_SingleWinFix_new
# 删除本地分支
git branch -d goods_alpha_CK_SingleWinFix_new

# 回滚
git reset --hard 52ba984 # 不保留当前提交记录上的信息
git reset --soft 52ba984 # 保留当前提交
git push -f # 强制更新远程仓库
~~~

# 2、仓库

~~~shell
# 添加远程仓库
git remote add origin https://gitee.com/cking1019/comm-engine.git
git remote rm origin  # 删除远程仓库地址origin

# 拉取与合并远程上的所有分支
git pull origin goods_alpha_CY_ProtocolCrackingTarget
# 推送当前所有分支
git push

# 子仓库
git submodule add url
git submodule init
git submodule update
# 拉取子模块，等价于 git submodule init, git submodule update
git submodule update --init --recursive
# --recuresive递归处理子模块中还存在的子模块，确保所有嵌套层次的子模块都被正确初始化和更新。
# 删除子模块步骤
rm -rf subModule
vim .gitmodules # 删除子模块对应条目
vim .git/config # 删除子模块配置
rm -rf .git/modules/subModule

# 删除已跟踪的文件或目录
git rm --cached subModule
git restore --staged
~~~

# 3、标签

~~~shell
# 标签,-a:annotate,通常是标签名,-m表示该标签的注释信息，包括作者信息
git tag -a v1.0 -m 'Release version 1.0'
# 查看最新提交的标签
git tag --sort=-creatordate | head -3
# 删除本地标签
git tag -d goods_beta_CK_multiConn
# 显示所有标签，按字母顺序排序
git tag -l
# 打印所有标签，每条标签附带一条消息
git tag -l -n1
git push origin v1.0      # 推送单个标签
git push origin --tags    # 推送所有标签
# 删除远程标签
git push origin -d goods_beta_CK_multiConn
~~~

# 4、配置

~~~shell
git config --system -l  # 查看系统配置信息
git config --global -l  # 查看全局配置信息
git config --local  -l  # 查看项目配置信息
git config -l           # 以system、global、local的顺序显示配置信息

# 不加选项默认为local模式
git config user.name wangchao
git config user.email 183799815@qq.com
~~~

# 5、暂存

~~~shell
git stash
git stash pop   stash@{0} # 弹出指定暂存区的文件，并将暂存区清空
git stash apply stash@{0} # 弹出指定暂存区的文件，不会将当前暂存区的文件清空
git stash show  stash@{0} # 查看指定暂存区的文件
git stash drop  stash@{0} # 清空记录
git stash lits            # 列出所有暂存区
git stash clear           # 清空所有记录
~~~

# 6、其他

~~~shell
# 日志
git log
git log --pretty=oneline

# 索引
git rm --cached *.pyc
git rm --cached -r target/

# 列出所有被git跟踪的文件
git ls-files
# 列出远程地址的所有标签，包括哈希值
git ls-remote --tags origin
# 列出远程地址的指定标签名
git ls-remote --tags origin <tag_name>
~~~

