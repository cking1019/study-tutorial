**XMLHttpRequest**

XMLHttpRequest (XHR)对象用于与服务器交互

~~~ini
readyState: xhr状态码，包括0、1、2、3、4
response: 响应主体内容,会根据相应头部Content-Type自动转换为对应的数据类型，包括文本类型
responseText: 从服务器收到的问题，自动转换文本类数据类型
responseType: 指定响应中包含的数据类型
responseURL: 响应的序列化URL
status: HTTP状态码，UNSENT: 0; OPENED: 0; LOADING: 200; DONE: 200
statusText: 包含HTTP服务器返回的响应状态消息的字符串,0 UNSENT; 1 OPENED; 3 LOADING OK; 4 DONE OK
timeout: 表示请求的毫秒数
upload: 返回一个XMLHttpRequestUpload对象，可以观察到监控上传的进度。
withCredentials: 是否应该使用诸如cookie、授权头或TLS客户端证书之类的凭证进行跨站点访问控制请求。
~~~

**XMLHttpRequestUpload**

表示XMLHttpRequest对象的上传过程

~~~ini
abort:      当请求被终止
error:      当前请求发送错误
load:       当前请求成功完成
loadend:	当前请求完成，不论成功与否
loadstart:  当前请求开始上传数据
progress:   当请求接收到更多数据时，会定期触发progress事件
timeout:    当前请求过期
~~~

