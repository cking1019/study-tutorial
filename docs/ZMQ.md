# 1、发布-订阅模式

~~~python
# 发布者
socket = zmq.Context().socket(zmq.PUB)
socket.bind("tcp://*:14322")

# 订阅者
socket = zmq.Context().socket(zmq.SUB)
socket.connect("tcp://127.0.0.1:14322")
socket.setsockopt_string(zmq.SUBSCRIBE, '')
~~~

# 2、请求-响应模式

~~~python
# 请求
socket = zmq.Context().socket(zmq.REQ)
socket.connect("tcp://localhost:14322")

# 响应
socket = zmq.Context().socket(zmq.REP)
socket.bind("tcp://*:14322")
~~~

# 3、推送-拉取模式

~~~python
# 推送
socket = zmq.Context().socket(zmq.PUSH)
socket.bind("tcp://*:5555")

# 拉取
socket = zmq.Context().socket(zmq.PULL)
socket.connect("tcp://127.0.0.1:5555")
~~~



