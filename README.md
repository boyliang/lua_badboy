#Badboy是专为叉叉脚本引擎开发的工具类，代码全部以开源的方式提供。

##模块清单：

##JSON
	newArray		新建数组对象
	newObject		新建对象
	decode			json字符串转成talbe对象
	encode			table对象转换成压缩的json字符
	encode_pretty 	table对象转换成优雅的json字符

##StringUtils
	toCharTable		从字符串转字符数组
	fromCharTable	从字符数组转字符串
	toByteTable		从字符串转字节数组
	fromByteTale	从字节数组转字符串
	contains		是否包含子串
	startWith		是否以某个子串开头
	endsWith		是否以某个子中结束
	...(等等，自己看去探索)

##UI
	RootView:create			构造UI根对象
	RootView:addView		添加子view
	RootView:removeView		删除子view
	RootView:removeViewByID	删除子view
	Page:create				构建Page控件
	Page:addView			添加子view
	Page:removeView         删除子view
	Page:removeViewByID     删除子view
	Image:create			构造Image控件
	Edit:create				构造Edit控件
	Lable:create			构造Lable控件
	...（所有属性都可以直接通过对象访问）

##POS
	distanceBetween			计算距离		
	click                   单击
	touchMoveTo  			精确滑动
	angleBetween			计算角度
	polarProjection         根据角度和距离找点  
	isColorClick			根据颜色进行点击

##utils
	sysLogFmt				格式化字符串输出
	sysLogLst				任意内容输出
	tap						模拟一次点击
	swip					模拟一次滑动
	cmpColor				指定颜色对比
	
##luasocket
	详细使用说明，main.lua中，API参考见http://w3.impa.br/~diego/software/luasocket/reference.html

##用法
	1. 进入https://github.com/boyliang/lua_badboy，下载项目源码；
	2. 把项目当中内容，复制到src目录下；
	3. 在main.lua中加入你的脚本逻辑；
	4. 使用xsp打包工具即完成out.xsp


#Badboy库目前还是初级阶段，还有很多不完善，如果遇到不明白的地方，请及时反馈。如果你觉得有好的开源项目，也可以告诉我们，我们会评估是否集成到Badboy库。
