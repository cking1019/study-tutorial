# 1、Axios是什么？

Axios是一个基于promise网络请求库，作用于node.js和浏览器中。在服务端，它使用原生的node.js中http模块，而在客户端(浏览器)，则使用XMLHttpRequest。

特性：

- 在浏览器创建XMLHttpRequests对象
- 在node.js创建http请求
- 支持PromiseAPI
- 拦截请求和响应
- 转换请求和响应数据
- 取消请求
- 自动转换JSON数据
- 客户端支持防御XSRF

# 2、安装方式

NPM

~~~bash
npm inistall axios
~~~

CDN

~~~html
<script src="https://cdn.staticfile.org/axios/1.3.6/axios.min.js"></script>
~~~

# 3、API

~~~javascript
axios         (config)         // config是一个字典类型
axios         (url[, config])
axios.request (config)
axios.get     (url[, config])
axios.post    (url[, config])
axios.delete  (url[, config])
axios.put     (url[, config])
axios.delete  (url[, config])
axios.head    (utl[, config])
axios.options (url[, config])

// 例如：
axios({
    url: 'https://api.cdnjs.com/libraries/react',
    method: 'get'
}).then(res => {
    console.log(res)
}).catch(err => {
    console.log(err)
})

// 默认发起一个GET请求
axios('https://api.cdnjs.com/libraries/react')
~~~

# 4、Axios实例

~~~javascript
axios.create([config])

// 实例配置
const instance = axios.create({
    baseURL: 'https://api.cdnjs.com/libraries/react',
    headers: {'content-type': 'application/json; charset=UTF-8'},
    timeout: 1000
})
~~~

# 5、请求配置

~~~shell
// 在请求配置config中，url是必须的。如果没有指定method，那么默认使用GET。
{
	url: '/react',
    method: 'get',
    baseURL: 'url',       // baseURL自动加在url前面
    headers: {}，         // 自定义请求头
    parames: {ID: 12345},
	data: {a:1, b: 2},    // 'data'作为请求体被发送的数据，仅适用于put、post、delete、patch请求方法
	timeout: 1000,        // 请求超时的毫秒数。默认值是0，永不超时。如果超过timeout值，则请求会中断。
	withCredentials: false， // 表示跨域请求时，是否需要使用凭证。
	responseType: 'json'，   // 表示浏览器将要响应的数据类型
	validateStatus: function (status) {
        return status >= 200 && status < 300; // 默认. 对于给定的http状态码是resolve还是reject promise。如果true，就resolve，否则reject.
    }
}
~~~

# 6、相应结构

~~~shell
// 一个请求的响应结构应包含以下信息
{
    
    data: {},         // 服务器的响应数据
    status: 200,      // 服务器响应的http状态码
    statusText: 'OK', // 服务器响应的http状态信息
    headers: {},      // 服务器响应头，所有header名称都是小写
    config: {},       // axios请求的配置信息
    request: {}       // 生成此响应的请求，在nodejs中是ClientRequest示例，在浏览器中是XMLHttpRequest实例
}
~~~

# 7、默认配置

axios的全局配置

~~~properties
axios.defaults.baseURL = 'https://api.cdnjs.com'
~~~

配置的优先级

配置会按照优先级进行合并。它的顺序是：在lib/defaults.js中找到库的默认值，然后是示例的defaults属性，最后是请求的config参数。

例如：

~~~javascript
// 使用库的默认配置创建实例，此时timeout的默认值是0
const instance = axios.create()

// 重写库的超时默认值
instance.defaults.timeout = 2500

// 重写请求的超时默认值
instance.get('/api', {
    timeout: 5000
})
~~~

# 8、拦截器

在请求或响应被then或catch处理前拦截它们

~~~javascript
// 添加请求拦截器
axios.interceptors.request.use(function (config) {
    return config
}, function (err) {
    return Promise.reject(error)
})
// 添加响应拦截器
axios.interceptors.response.use(function (res) {
    return res
}, function (err) {
    return Promise.reject(err)
})
~~~



