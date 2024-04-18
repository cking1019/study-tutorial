# 1、Get请求

~~~shell
# 不指定-X, curl默认发送get请求
curl https://www.example.com
~~~

~~~shell
# -A：指定客户端的用户代理标头，即User-Agent
curl https://google.com -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36' 

# -H：指定响应内容
curl  https://google.com -H 'User-Agent: php/1.0' -H "Content-Type: application/json"
~~~

-b参数向服务器发送cookie

~~~shell
# -b: 向服务器发送cookie，生成一个标头Cookie:foo=bar，向服务器发送一个{key: foo，value: bar}的cookie
curl  https://google.com -b 'foo=bar;foo2=bar2' 


# 读取本地文件cookies.txt
curl https://www.google.com -b cookies.txt
~~~

~~~shell
# -c: 将服务器设置的cookie写入一个文件
curl https://www.google.com -c cookies.txt
~~~

# 2、Post请求

~~~shell
# -X: 指定请求方式；-d：数据
curl https://google.com/login -X POST -d'login=emma＆password=123'
# 使用-d参数后，HTTP请求会自动加上标头Content-Type:application/x-www-form-urlencoded,并自动将请求转为POST方法，因此可以省略-X POST
~~~

~~~shell
# 读取本地文件
curl https://google/com/login -d '@data.txt'
~~~

~~~shell
# --data-urlencode等同于-d，发送POST请求的数据体，区别在于会自动将发送的数据进行URL编码。
curl https://google.com/login --data-urlencode 'comment=hello world'
~~~

~~~shell
# 发送json数据
curl http://127.0.0.1:5000/post -d "{\"name\":\"root\", \"pwd\":\"123456\"}"
~~~

# 3、其他

~~~ shell
# -F参数用来向服务器上传二进制文件
curl https://google.com/profile -F 'file=@photo.png'
# 如上命令会在HTTP请求加上标头Content-Type:multipart/form-data

# -F参数可以指定MIME类型
curl https://google.com/profile -F 'file=@photo.png;type=image/png'

# 可以指定服务器收到的文件名为me.png
curl https://google.com/profile -F 'file=@photo.png;filename=me.png'
~~~

~~~shell
# 上面命令设置用户名为bob，密码为12345，然后将其转为HTTP标头Authorization:Basic Ym9iOjEyMzQ1
curl https://google.com/login -u 'root:123456'

# curl 能够识别 URL 里面的用户名和密码。
curl https://root:123456@google.com/login

# 上面命令只设置了用户名，执行后，curl 会提示用户输入密码。
curl -u 'root' https://google.com/login
~~~

~~~shell
# -I参数向服务器发出HEAD请求，然后将服务器返回的HTTP标头打印出来
curl -I https://www.example.com

# -i参数打印出服务器回应的 HTTP 标头。
curl -i https://www.example.com
# 上面命令收到服务器回应后，先输出服务器回应的标头，然后空一行，再输出网页的源码。
~~~

