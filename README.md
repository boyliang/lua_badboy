#Badboy是专为叉叉脚本引擎开发的工具类，代码全部以开源的方式提供，目前一共提供了两个工具模块: JSON和StringUtils。

##API都比较丰富， 在此大概列一下：

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
	...(等等，自己看情况使用吧)

##用法
	1. 进入https://github.com/boyliang/lua_badboy，下载项目源码；
	2. 把项目当中内容，复制到src目录下；
	3. 在main.lua中加入你的脚本逻辑；
	4. 使用xsp打包工具即完成out.xsp


#Badboy库目前还是初级阶段，还有很多不完善，如果遇到不明白的地方，请及时反馈。如果你觉得有好的开源项目，也可以告诉我们，我们会评估是否集成到Badboy库。
