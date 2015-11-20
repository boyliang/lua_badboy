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

print('hex:' .. hex)
print('sha1:' .. sha1)
print('md5:' .. md5)
