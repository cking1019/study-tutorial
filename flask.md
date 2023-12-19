# 1、表格提交

~~~python
from flask import Flask, request, render_template

app = Flask(__name__)

# 提交表达数据
@app.post('/form')
def form():
    username = request.form['username']
    password = request.form['password']
    file = request.files['file']  # 获取表格中name字段
    file.save(f'data/{file.filename}')
    print(username, password)
    return render_template('index.html')
~~~

# 2、post提交

~~~python
# post提交
@app.post('/post')
def post():
    data = request.get_json(force=True)
    print(data['name'], data['pwd'])
    return {'code': '200'}
~~~

# 3、get提交

~~~python
@app.get('/')
def index():
    print(request.method)
    return 'hello'

if __name__ == '__main__':
    app.run(debug=True)
~~~

