# 1、asyn与promise的应用


~~~javascript
function fn(state) {
    return new Promise((reslove, reject) => {
        console.log('我从异步函数中收到的参数为：', state)
        if (state == 'success')
            reslove('状态码为：' + state)
        else
            reject('状态码为：' + state)
    })
}

// 等价于fn = () => {}
(async () => {
    let state = 'fail'
    await fn(state).then(res => {
        console.log('我收到来自reslove函数中的参数为', res)
    }, err => {
        console.log('我收到来自reject函数中的参数为', err)
    })
})();


(() => {console.log('hello world!')})()


let fn2 = () => {console.log('hello world!')}
let fn3 = () => {console.log('hello world!')}
fn2()
fn3()
~~~

# 2、js模块化

**test1.js**

~~~javascript
function fn1() {
    console.log('i am fn1')
    fn2()
}

export function fn2() {
    console.log('i am fn2')
}

export default fn1
~~~

**test2.js**

~~~javascript
import fn1 from './test1.js'
import {fn2} from './test1.js'

fn1()
fn2()
~~~

 export 与 export default 直接的区别
 1、在一个文件中，export可以有多个，export default仅有一个；
 2、export 导出的文件，在导入时，必须加上{}；export default 则不需要；
 3、export default导出时，导入的函数或变量可以另取别名；export 则不行。

# 3、promise的应用

~~~javascript
// new Promise((resolve, reject) => {
//     let a = 1, b = 2
//     return resolve(a + b)//没有定义a的值，会直接调用catch，输出err
// }).then(data => {
//     console.log("promise a + b = ", data)
// }).catch(err => {
//     console.log("promise err value :", err)
// })

function promiseClick() {
    return new Promise((resolve, reject) => {
        let num = Math.random()
        if (num <= 0.5) {
            resolve(num)
        }
        else {
            reject('数字大于0.5，即将执行失败回调')
        }
    })
}

promiseClick().then(
    data => {
        console.log('resolve回调成功！返回结果为：', data)
    },
    reason => {
        console.log('reject回调失败！返回失败原因：', reason)
    }
)
~~~

Promise构造函数只有一个参数，它是一个函数。这个函数在构造之后会直接被异步执行，所以，我们称之为起始函数。起始函数包含两个参数，分别是resolve和reject。Promise对象有三种状态，分别是等待(pending)、已完成(fulfilled)、已拒绝(rejected)。一个Promise对象的状态只可能从“等待”到“完成”或从“等待”到“拒绝”，不能逆向转换。一个Promise对象只能改变一次，且只能接受一个参数，并且是一个函数。

# 5、JQuery

## 5.1 表单提交

~~~js
$('#submit').on("click", () => {
    const name = $('#e-mail').val()
    const pwd = $('#pwd').val()
    alert(name + pwd)
})
~~~

## 5.2 背景隐藏

~~~js
$('#btn').on("click", () => {
    $('#app').hide()  // 等价于 $('#app').css('display', 'none')
})
~~~

## 5.3 加载背景

~~~js
$('#app').css('background', 'url(./Communication_kieker.png)')
$('#app').css('width' , '1150px')
$('#app').css('height', '278px')
~~~

模块化：CommonJS、AMD、ES6

CommonJS：module.exports  方式导出

常见的前端框架：React、Vue、Angular2

新语言：ES6、TypeScript、Flow、SCSS

构建就是做这件事情，将源代码转换成可执行的JavaScript、CSS、HTML代码，包括代码转换、文件优化、代码分割、模块合并、自动刷新、代码校验、自动发布。构建其实就是工程化、自动化思想在前端开发中的体现，将一系列流程用代码去实现，让代码自动化地执行这一系列复杂的流程。构建为前端开发注入了更大的活力，解放了我们的生产力。

构建工具：Npm Script、Grunt、Gulp、Fis3、Webpack、Rollup

Webpack:它是一个打包模块化JavaScript的工具，在Webpack里一切文件皆模块，通过Loader转换文件，通过Plugin注入钩子，最后由多个模块组合成的文件。WebPack专注于构建模块化项目。Loader可以看作具有文件转换功能的翻译员，配置里的module.rules数组配置了一组规则，告诉Webpack在遇到哪些文件时使用哪些Loader去加载和转换。Plugin是用来扩展Webpack功能的，通过在构建流程里注入钩子实现，它为Webpack带来了很大的灵活性。

# 6、构建Electron应用

Electron是Node.js和Chromium浏览器的结合体，用Chromium浏览器显示出的Web页面作为应用的GUI，通过Node.js和操作系统交互。Electron由GitHub主导和开源，VSCode编译器就是由Electron开发的。

# 7、数据库操作

~~~js
const mysql = require('mysql')

const db = mysql.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: '123456',
    database: 'myblog'
})

// select
selectFunc = () => {
    const sqlStr = 'select * from tag';
    db.query(sqlStr, (err, res) => {
        if(err) return console.log(err.message)
        console.log(res)
    })
}

insertFunc = () => {
    const sqlStr = 'insert into tag values(?, ?, ?, ?)';
    db.query(sqlStr, [33, 'test', 2, new Date()], (err, res) => {
        if(err) return console.log(err.message);
        if(res.affectedRows === 1) console.log('insert into successfully!');
    })
}

deleteFunc = () => {
    const sqlStr = 'delete from tag where id = ?';
    db.query(sqlStr, 33, (err, res) => {
        if(err) return console.log(err.message);
        if(res.affectedRows === 1) console.log('delete successfully!');
    })
}

updateFunc = () => {
    const sqlStr = 'update tag set ? where id=?';
    const data = {id: 32, name: 'test', number: 100, date: new Date()}
    db.query(sqlStr, [data, data.id], (err, res) => {
        if(err) return console.log(err.message);
        if(res.affectedRows === 1) console.log('update successfully');
    })
}


// deleteFunc()
// insertFunc()
updateFunc()

setTimeout(() => {
    selectFunc()
}, 1000);
~~~

# 8、AJAX的应用

## 8.1、jQuery.ajax(url, [settings])

~~~ini
url: 一个用来包含发送请求的URL字符串
settings: AJAX请求设置，所有选项都是可选的

type: 请求类型。默认为GET
url: 发送请求的地址
accepts: 内容类型发送请求头，告诉服务器什么样的响应会接收返回
async: 默认为true，所有请求均为异步请求
contents: 用来确定jQuery如何解析响应，给定其内容类型
data: 发送到服务器的数据，将自动转换成请求字符串格式。GET请求中将附加在URL后。
dataType: 预期服务器返回的数据类型。如果不指定，jQuery将自动根据HTTP包中的MIME信息智能判断
hearders: 一个额外的{key: value}对映射到请求一起发送
mimeType: 一个mime类型用来覆盖XHR的MIME类型
success(data, textStatus, jqHHR): 请求成功后的回调函数。由服务器返回，根据dataType参数进行处理
~~~

## 8.2、jQuery.get(url, [data], [callback], [type])

~~~ini
url: 待载入页面的URL地址
data: 待发送的key/value参数
callback: 载入成功时回调函数
type: 返回内容格式，xml、json、text、html
~~~

## 8.3、jQuery.post(url, [data], [callback], [type])

~~~ini
url: 待载入页面的URL地址
data: 待发送的key/value参数
callback: 载入成功时回调函数
type: 返回内容格式，xml、json、text、html
~~~

