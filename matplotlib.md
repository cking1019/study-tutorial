matplotlib与numpy一起使用可以替换matlib。

Matplotlib的两种构图方式：

- **隐式构图**：绘制一张简单的图，只包含一个默认的坐标系子图，子图默认是二维直角坐标系。

  原理：隐式构图不需要程序员显式地创建figure对象和axes坐标系对象，可以直接调用plt.xx()函数进行绘图。当只需要绘制一张简单的图形时，可以选择隐式构图。

- **显示构图**：绘制一张复杂的图，可包含多张子图。

​	**面向对象式绘图**：画图(figure)、区域(axe)、坐标轴(axis)。图中的所有组成元素对象都是一个artist，包括了Figure对象、Axes对象和Axis对象，Artist是它们的基类，所有Artist对象都绘制于canvas画布上。

​	Figure包含Axes、Artist、canvas对象；title、xlabel、ylabel、legend等都属于Artist对象；canvas对象不可见，matplotlib绘图时会自动调用该对象。

~~~python
fig, ax = plt.subplots()  # 默认创建一个空Axes的figure
fig, axs = plt.subplots(2, 2)  # 创建2x2个Axes的figure
~~~

fig = plt.figure()  # 创建并获取当前默认的figure对象。当import matplotlib.pyplot时，会自动把该直角坐标系与默认的figure对象关联，所以这行代码可省略。

axes:子图坐标系，是axis的复数形式，包括笛卡尔直角坐标系、平面极坐标系、柱面坐标系、球面坐标系等。

~~~python
ax1 = plt.axes()  # 创建默认的二维直角坐标系。
ax2 = plt.axes(projection='3d')  # 创建三维直角坐标系。
~~~

---

**plt对象主要包含两大类函数：**

- 操作类函数：对画布、图、子图、坐标轴、图例、背景、网格等对象属性进行操作。
- 绘图类函数：把输入数据可视化，绘制不同的图形，例如折线图、散点图、条形图、直方图、饼状图等。

**subplot()功能概述：**

subplot()函数允许在默认的figure画布中绘制多个不同的默认坐标系的子图。

函数原型：subplot(numbRow, numbCol, plotNum)

- numbRow:指明画布被切分成多少行；
- numbCol:指明画布被切分成多少列；
- plotNum:指明子图在切分后空间中的位置。

~~~python
import matplotlib.pyplot as plt

# fig, ax = plt.subplots()  # 只有一个空Axes的figure
fig, axs = plt.subplots(2, 2, tight_layout=True)  # 拥有2x2个Axes的figure
axs[0, 0].plot([1, 2], [1, 2])
axs[0, 0].set_title('a')
axs[0, 0].set_xlabel('xa')
axs[0, 0].set_ylabel('ya')

axs[0, 1].pie([1, 2, 3])
axs[0, 1].set_title('b')
axs[0, 1].set_xlabel('xb')
axs[0, 1].set_ylabel('yb')

axs[1, 0].hist([1, 2, 3, 3])
axs[1, 0].set_title('c')
axs[1, 0].set_xlabel('xc')
axs[1, 0].set_ylabel('yc')

axs[1, 1].scatter([1, 2], [3, 4])
axs[1, 1].set_title('d')
axs[1, 1].set_xlabel('xd')
axs[1, 1].set_ylabel('yd')

fig.show()
~~~

**一张画布上对应四个子图：**

![image-20221217163425500](C:\Users\Demo\AppData\Roaming\Typora\typora-user-images\image-20221217163425500.png)





