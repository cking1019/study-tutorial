# 1、ssh配置

## 1.1、客户端配置

~~~toml
serverAddr = "47.119.18.145"
serverPort = 7000

[[proxies]]
name = "ssh"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6000
~~~

## 1.2、服务端配置

~~~toml
bindPort = 7000
~~~

**实验：连接内网**

~~~bat
ssh -oPort=6000 demo@47.119.18.145
# 输入密码即可登陆
# demo@47.119.18.145's password:
~~~

# 2、http配置

## 2.1、客户端配置

~~~toml
serverAddr = "47.119.18.145"
serverPort = 7000

[[proxies]]
name = "web"
type = "http"
localIP = "127.0.0.1"
localPort = 8080
customDomains = ["cking.icu"]
~~~

## 2.2、服务端配置

~~~toml
bindPort = 7000
vhostHTTPPort = 8080
~~~

