@echo off

git add .
git commit -m '#'
@REM git pull origin master // 如果远程仓库中的文件内容发生变化，需要先将远程仓库变化的文件拉取至本地，然后再将本地变化的文件推送至远程仓库。
git push origin master

pause
