local bb = require("badboy")

if sysLog == nil then
  sysLog = print
  showUI = function(...) end
end

-- JSON test
local json = bb.getJSON()
local lua_value = json.decode('{"a": 1, "b":"boy", "c":{"d":1}}')
local a_value = lua_value.a     -- =1
local b_balue = lua_value.b     -- ="boy"
local c_d_balue = lua_value.c.d -- =1

local raw_json_text = json.encode(lua_value)
local pretty_json_text = json.encode_pretty(lua_value)

sysLog(raw_json_text)
sysLog(pretty_json_text)

-- strutils test
local strutils = bb.getStrUtils()
local str = 'i am a badboy'

local hex = str:tohex() -- 等同于 strutils.tohex(str)
local sha1 = str:sha1() -- 等同于 strutils.sha1(str)
local md5 = str:md5() -- 等同于 strutils.md5(str)

sysLog('hex:' .. hex)
sysLog('sha1:' .. sha1)
sysLog('md5:' .. md5)

-- UI test
bb.loaduilib()
local rootview = RootView:create({style = ViewStyle.CUSTOME})
local page = Page:create("page")
page.text = "Page1"
local page2 = Page:create("page2")
page2.text = "Page2"
local label = Label:create("label", {color = "255, 255, 0"})
label.text = "I love XX"
local image = Image:create("image")
image.src = "bg.png"
local edit = Edit:create("edit", {prompt = "提示"})
edit.align = TextAlign.LEFT

local radiogroup = RadioGroup:create("radiogroup")
radiogroup:setList('男', '女', '嬲', '奻')
radiogroup:setSelect(3)

local checkboxgroup = CheckBoxGroup:create('checkboxgroup')
checkboxgroup:setList('XX', 'OO', 'AA', 'BB')
checkboxgroup:setSelects(2, 3)

rootview:addView(page)    --把page添加到rootview
rootview:addView(page2)

page:addView(label)       --把label添加到page
-- page:addView(label)    --label的id重复，这里会报错
page:addView(image)       --把image添加到page
page:addView(checkboxgroup)
page:addView(radiogroup)
page:removeView(label)   --从page中删除label

uijson = json.encode(rootview)
showUI(uijson)

-- utils test
bb.loadutilslib()
i = 3
j = 6.9
s = 'good boy'
sysLogFmt('i=%d, j=%f, s=%s', i, j, s)
sysLogLst(i, j, s)

-- POS test
local pos = bb.loadpos()
p1 = pos:new(0, 0, 0x123456)
p2 = pos:new(1, 2)
sysLog(p1:distanceBetween(p2))
sysLog(p1:angleBetween(p2))
p2 = p1:polarProjection(4, 30)
sysLogFmt('p2[%d, %d]', p2.x, p2.y)

-- lua socket test
bb.loadluasocket()
local socket = bb.socket
---- dns
local dns = socket.dns
sysLog('localhostIP: ' .. dns.toip('localhost'))
sysLog('result: ' .. (dns.tohostname('59.37.96.63') or 'nil'))
sysLog('hostname: ' .. dns.gethostname())
sysLog('addinfo: ' .. tostring(dns.getaddrinfo('localhost')))
---- http
local http = bb.http
local ltn12 = bb.ltn12
res, code = http.request('http://www.baidu.com')
-- 等价于 
-- local response_body = {} 
-- res, code = http.request({
--    url = 'http://www.baidu.com', 
--    sink = ltn12.sink.table(response_body)
--  })
if code == 200 then
  sysLog(res)
  dialog(res, 0)
end

-- 获取外网ip地址 
local res, code = http.request('http://www.ip.cn/');
if code == 200 then
    local i,j = string.find(res, '%d+%.%d+%.%d+%.%d+')
    local ipaddr =string.sub(res,i,j)
    dialog(ipaddr, 0)
end

--httppost请求
local response_body = {}
local post_data = 'asd';  
res, code = http.request{  
    url = 'http://127.0.0.1/post.php',  
    method = "POST",  
    headers =   
    {  
        ['Content-Type'] = 'application/x-www-form-urlencoded',  
        ['Content-Length'] = #post_data,  
    },  
    source = ltn12.source.string('data=' .. post_data),  
    sink = ltn12.sink.table(response_body)  
}  

--挂载代理
http.PROXY = 'http://127.0.0.1:8888' --代理服务器地址
local result, code = http.request('http://www.baidu.com')
dialog(result or tostring(code), 0)

--以socket的方式访问
local host = 'www.baidu.com'
local file = "/"
local sock = assert(socket.connect(host, 80)) --创建一个 TCP 连接，连接到 HTTP 连接的标准 80 端口上
sock:send('GET ' .. file .. ' HTTP/1.0\r\n\r\n')
repeat
    local chunk, status, partial = sock:receive(1024) --以 1K 的字节块接收数据
until status ~= 'closed'
sock:close()  -- 关闭 TCP 连接

--smtp方法发送email
local smtp = bb.smtp
from = '<youmail@126.com>' -- 发件人
--发送列表
rcpt = {
    '<youmail@126.com>',
    '<youmail@qq.com>',
    '<youmail@gmail.com>',
}
mesgt = {
    headers = {
        to = 'youmail@gmail.com', -- 收件人
        cc = '<youmail@gmail.com>', -- 抄送
        subject = "This is Mail Title"
    },
    body = "邮件内容"
}

r, e = smtp.send{
    server = "smtp.126.com", --smtp服务器地址
    user = "youmail@126.com",--smtp验证用户名
    password = "******",     --smtp验证密码  
    from = from,
    rcpt = rcpt,
    source = smtp.message(mesgt)
}

if not r then
    dialog(e, 0)
else
    dialog('发送成功!', 0)
end

-- 实现获取网络时间
server_ip = {
    "132.163.4.101",
    "132.163.4.102",
    "132.163.4.103",
    "128.138.140.44",
    "192.43.244.18",
    "131.107.1.10",
    "66.243.43.21",
    "216.200.93.8",
    "208.184.49.9",
    "207.126.98.204",
    "207.200.81.113",
    "205.188.185.33"
}

local function nstol(str)
    assert(str and #str == 4)
    local t = {str:byte(1,-1)}
    local n = 0
    for k = 1, #t do
        n= n*256 + t[k]
    end
    return n
end

local function gettime(ip)
    local tcp = socket.tcp()
    tcp:settimeout(10)
    tcp:connect(ip, 37)
    success, time = pcall(nstol, tcp:receive(4))
    tcp:close()
    return success and time or nil
end

local function nettime()
    for _, ip in pairs(server_ip) do
        time = gettime(ip)
        if time then 
            return time
        end
    end
end

dialog(nettime(),0)

-- 统计毫秒精度时间
local function sleep(sec)
    socket.select(nil,nil,sec);
end
local t0 = socket.gettime()
sleep(0.4);
local t1 = socket.gettime()
dialog(t1 - t0, 0)

-- FTP 测试
-- [ftp://][<user>[:<password>]@]<host>[:<port>][/<path>][type=a|i]
-- The following constants in the namespace can be set to control the default behavior of the FTP module:
--  PASSWORD: default anonymous password.
--  PORT: default port used for the control connection;
--  TIMEOUT: sets the timeout for all I/O operations;
--  USER: default anonymous user;

local ftp = bb.ftp

-- Log as user "anonymous" on server "ftp.tecgraf.puc-rio.br",
-- and get file "lua.tar.gz" from directory "pub/lua" as binary.
f, e = ftp.get("ftp://ftp.tecgraf.puc-rio.br/pub/lua/lua.tar.gz;type=i")

-- Log as user "fulano" on server "ftp.example.com",
-- using password "silva", and store a file "README" with contents 
-- "wrong password, of course"
f, e = ftp.put("ftp://fulano:silva@ftp.example.com/README",  "wrong password, of course")

-- Log as user "fulano" on server "ftp.example.com",
-- using password "silva", and append to the remote file "LOG", sending the
-- contents of the local file "LOCAL-LOG"
f, e = ftp.put{
  host = "ftp.example.com", 
  user = "fulano",
  password = "silva",
  command = "appe",
  argument = "LOG",
  source = ltn12.source.file(io.open("LOCAL-LOG", "r"))
}

