# 1、express()

~~~javascript
const express = require('express')
const app = express()
~~~

方法：

~~~javascript
express.json       ([options])
express.raw        ([options])
express.Router     ([options])
express.static     (root[, options])
express.text       ([options])
express.urlencoded ([options])
// extended 为ture表示可以解析任何数据类型
options = {extended: true}
~~~

# 2、express应用

~~~javascript
app.all  (path, callback[, callback...])
app.get  (path, callback[, callback...])
app.post (path, callback[, callback...])
app.route(path)
app.use([path, ]callback [, callback])

app.listen([port[, host[, backlog]][, callback]])

app.get('/', (req, res) => {
    res.send('i am get')
})

app.post('/', (req, res) => {
    res.send('i am post')
})
~~~

# 3、Request

~~~javascript
// 该类主要获取请求相关的属性，包括请求ip地址、请求头、请求内容等。
app.get('/user/:id', (req, res) => {
    res.send('user ' + req.params.id)
})

app.use(express.json())
app.use(express.urlencoded({ extended: true}))

app.post('/profile', (req, res, next) => {
    res.json(req.body)
})

// 接受请求头的字段
req.accepts('application/json')
~~~

# 4、Respense

~~~javascript
// res 对象表示 Express 应用程序在收到 HTTP 请求时发送的 HTTP 响应。
app.get('/user/:id', (req, res) => {
    res.send('user ' + req.params.id)
})

res.append(field[, value])
res.cookie(name, value[, options])
res.end()
res.status(200).end()
// body 参数可以是 Buffer 对象、String、对象、Boolean 或 Array
res.send([body])
// 发送一个JSON数据格式数据
res.json([body])
res.set('Content-Type', 'application/json')

~~~

# 5、Router

~~~javascript
router.all(path, [callback,...])
                  
router.get('/', (req, res) => {
    res.send('hello world')
})

router.param(name, )
router.route(path)
router.use([path], [function,...])
~~~

