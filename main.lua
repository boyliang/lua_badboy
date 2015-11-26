local bb = require("badboy")
local json = bb.json

local lua_value = json.decode('{"a": 1, "b":"boy", "c":{"d":1}}')
local a_value = lua_value.a     -- =1
local b_balue = lua_value.b     -- ="boy"
local c_d_balue = lua_value.c.d -- =1

local raw_json_text = json.encode(lua_value)
local pretty_json_text = json.encode_pretty(lua_value)

print(raw_json_text)
print(pretty_json_text)


local str = 'i am a badboy'
local strutils = bb.strutils

local hex = str:tohex() -- 等同于 strutils.tohex(str)
local sha1 = str:sha1() -- 等同于 strutils.sha1(str)
local md5 = str:md5() -- 等同于 strutils.md5(str)

if sysLog == nil then
  sysLog = print
end

sysLog('hex:' .. hex)
sysLog('sha1:' .. sha1)
sysLog('md5:' .. md5)

local rootview = RootView:create({style = ViewStyle.CUSTOME})
local page = Page:create("page")
page.text = "Page1"
local page2 = Page:create("page2")
page2.text = "Page2"

local label = Lable:create("lable", {color = "255, 255, 0"})
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
page:removeView(label1)   --从page中删除label

uijson = json.encode(rootview)
showUI(uijson)
