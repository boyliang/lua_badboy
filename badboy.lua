
local badboy = {}

-- JSON模块
local lo_json = {}
lo_json.obj = require('bblibs.JSON')
lo_json.decode = function(x) return lo_json.obj:decode(x) end
lo_json.encode = function(x) return lo_json.obj:encode(x) end
lo_json.encode_pretty = function(x) return lo_json.obj:encode_pretty(x) end;
badboy.json = lo_json
badboy.jsonlib = lo_json.obj
-- JSON模块

-- StrignUtils模块
local lo_strutils = require('bblibs.StrUtilsAPI')
local lo_md5 = require('bblibs.md5')
lo_strutils.md5 = function(str) return lo_md5.sumhexa(str) end
--以下对string进行扩展，也可以直接使用badboy.strutils，功能强大10倍
function string:tohex() return lo_strutils.toHex(self) end
function string:fromhex() return lo_strutils.fromHex(self) end
function string:sha1() return lo_strutils.SHA1(self) end
function string:md5() return lo_strutils.md5(self) end
function string:base64_encode() return lo_strutils.toBase64(self) end
function string:base64_decode() return lo_strutils.fromBase64(self) end
function string:encrypt(key) return lo_strutils.encrypt(self, key) end
function string:decrypt(key) return lo_strutils.decrypt(self, key) end
function string:split(divider) return lo_strutils.seperate(self, divider) end
function string:trim() return lo_strutils.trim(self) end
badboy.strutils = lo_strutils
-- StringUtils模块

return badboy