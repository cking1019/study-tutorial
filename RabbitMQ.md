**publisher.py**

~~~python
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

persons = [Person("John", 25), Person("Alice", 30), Person("Bob", 35)]
# 将对象列表转换为字节流
message = pickle.dumps(persons)

channel.basic_publish(exchange='',
                      routing_key='my_queue',
                      properties=pika.BasicProperties(
                          delivery_mode=pika.spec.PERSISTENT_DELIVERY_MODE),
                      body=message)
connection.close()
~~~

**consumer.py**

~~~python
connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()


# 定义回调函数来处理接收到的消息
def callback(ch, method, properties, body):
    data = pickle.loads(body)
    for d in data:
        print("收到对象:", d)
    ch.basic_ack(delivery_tag=method.delivery_tag)




# 获取随机的queue名字
result = channel.queue_declare(queue="", exclusive=True)
queue_name = result.method.queue

# channel.queue_bind(queue=queue_name, exchange='log')
channel.queue_bind(queue='my_queue', exchange='log')

# 接收消息
# channel.basic_consume(queue=queue_name, on_message_callback=callback, auto_ack=False)
channel.basic_consume(queue='my_queue', on_message_callback=callback, auto_ack=False)

# 开始消费消息
channel.start_consuming()

connection.close()
~~~

常用API：

~~~python
connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

# 声明一个交换机，其模式为广播。在fanout模式下，如果没有队列绑定给交换机，则消息将会丢失。
channel.exchange_declare(exchange="logs", exchange_type="fanout")
# direct：直连
# topic：组播
# headers
# fanout：广播

# 声明一个队列，exclusive=True表示当连接关闭，该队列也将被删除
result = channel.queue_declare(queue="", exclusive=True)
# 获取一个随机队列名，amq.gen-***
queue_name = result.method.queue

# 频道绑定队列my_queue，空字符串表示默认交换机
channel.queue_bind(queue=queue_name, exchange='')

# 发布消息,routing_key表示信息将发布到这个队列中，delivery_mode=2表示消息持久化。当logs交换机为"faout"模式时，可以忽视routeing_key指定的路由，因为它会广播所有队列。
channel.basic_publish(exchange='logs', 
                      routing_key='my_queue', 
					  properties = pika.BasicProperties(
                          delivery_mode=pika.spec.PERSISTENT_DELIVERY_MODE),
                      body=message)

# 消费者在收到ack确定之前，每次只能接收一条消息
channel.basic_qos(prefetch_count=1)
# 消费消息, auto_ack默认为Ture，表示即使程序中断，也会从消息队列中移除该信息
channel.basic_consume(queue='my_queue',
                      on_message_callback=callback,
                      auto_ack=False)
~~~

