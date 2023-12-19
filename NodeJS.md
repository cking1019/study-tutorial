# 1、Node.js简介

Chrome浏览器默认的js运行环境是V8，V8是目前JS最好的运行引擎，而且，Node.js是基于V8开发的。

~~~cmd
node -v  # 查看node版本
~~~

# 2、fs文件系统模块

fs模块是Node.js官方提供的，用来操作文件模块。它提供了一系列的方法，用来满足用户对文件操作的需求。

- fs.readFile()方法，用来读取指定文件的内容；
- fs.writeFile()方法，用来向指定的文件写入内容。

~~~js
const fs = require('fs')

fs.readFile('data.json', 'utf-8', (err, data) => {
    console.log(err)
    console.log(data)
})

fs.writeFile('data.json', 'hhh', 'utf8', err => {
    if (err) {
        return console.log(err);
    }
    console.log('this file is saved successfully!')
})
~~~

**成绩整理案例：**

grade.txt

~~~txt
xiaoming:12 xiaowang:100
~~~

~~~js
const fs = require('fs')

fs.readFile('grade.txt', (err, data) => {
    if (err) return console.log("open fail!\n" + err.message);

    console.log('open successfully!\n' + data);

    // change form from string to array
    const d = data.toString().split(' ');
    console.log(d);

    // iterate whole array
    const arr_d = []
    d.forEach((value, index, array) => {
        // the index of array, the each value of array, the whole list of array
        console.log(index, value, array)
        arr_d.push(value.replace('=', ': '))
    })
    console.log(arr_d);
    
    // change form from array to string
    const d2 = arr_d.join('\r\n');
    console.log(d2);

    // write again with new format
    fs.writeFile('grade.txt', d2, err => {
        if (err) {
            return console.log('open fail! ' + err.message);
        }
        console.log('write successfully!')
    })
})
~~~

注意：writeFile()：1、只能创建文件，不能创建路径；2、新内容会覆盖旧内容。

~~~js
setTimeout(() => {
    console.log(__dirname)   // dirname 表示当前执行文件的路径
    console.log(__filename)  // filename 表示当前执行文件的路径,包括文件名
}, 1000);
~~~

# 3、path路径模块

~~~js
const path = require('path')


// avoid bug cannot find file, such as  '__dirname + .\\data.txt' => '__dirname.\data.txt'
const f = path.join(__dirname, '\\data\\data.txt')
console.log(f)


// file name with suffix
const file_name = path.basename(f)
console.log(file_name)

// file name without suffix
const file__name_suffix = path.basename(f, '.txt')
console.log(file__name_suffix)

// return the extension of the path from the last '.' to end of string in the last portion of the path.
const extname_file = path.extname(f)
console.log(extname_file)
~~~

# 4、http模块

~~~js
const http = require('http')
const fs   = require('fs')
const path = require('path')

// create web server instance
const server = http.createServer()

// bind request event to listen
// req include data and property about user
server.on('request', (req, res) => {

   let url = req.url
   const method = req.method
   let filePath = ''
   if (url === '/') {
      filePath = path.join(__dirname, '/clock/clock.html')
   } else {
      filePath = path.join(__dirname, '/clock', url)
   }
   
   console.log(url, method)
   // res.setHeader('Content-Type', 'text/html; charset=utf-8')

   fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) return res.end('<h1>404 Not found</h1>')
      // reponse client
      res.end(data)
   })
})

// start server
server.listen(80, () => {
   console.log('server running at 127.0.0.1:80')
})
~~~



# 5、Node.js中的模块化

Node.js中根据模块来源的不同，将模块分为三大类，分别是：

- 内置模块：由Node.js官方提供，例如fs、path、http等；
- 自定义模块：用户创建的每个js文件，都属于自定义模块(导入模块时，需要写路径)；
- 第三方模块：由第三方开发出来的，需要下载。

CommonJS规定：

1. 每个模块内部，module变量代表当前模块；
2. module变量是一个对象，它的exports属性，即module.exports是对外的接口；
3. 加载某个模块，其实就是加载该模块的module.exports属性。require()方法用于加载该模块。

~~~js
// c points to module.exports object instead of exports
const c = require('./index')
~~~

# 6、npm与包

自定义格式化时间的包：

~~~js
const appZero = (n) => {
    return n < 10 ? '0' + n : n;
}

const dateForm = () => {
    const t = new Date()

    const y = t.getFullYear()
    const m = appZero(t.getMonth() + 1)
    const d = appZero(t.getDate())

    const hh = appZero(t.getHours())
    const mm = appZero(t.getMinutes())
    const ss = appZero(t.getSeconds())

    return `${y}-${m}-${d} ${hh}:${mm}:${ss}`
}

module.exports = {dateForm}
~~~

