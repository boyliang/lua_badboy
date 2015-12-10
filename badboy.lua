local badboy = {}

-- JSON模块
function badboy.getJSON() 
  if badboy.json == nil then
    local lo_json = {}
    local obj = require('bblibs.JSON')
    
    lo_json.decode = function(x) return obj:decode(x) end
    lo_json.encode = function(x) return obj:encode(x) end
    lo_json.encode_pretty = function(x) return obj:encode_pretty(x) end;
    
    badboy.json = lo_json
  end
  return badboy.json
end

-- StrignUtils模块
function badboy.getStrUtils()
  if badboy.strutils == nil then
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
  end
	
	return badboy.strutils
end

local function loadlib(flag, name)
  if badboy[flag] == nil then
    require(name)
    badboy[flag] = true
  end
end

local function getlib(flag, name)
  if badboy[flag] == nil then
    badboy[flag] = require(name)
  end
  
  return badboy[flag]
end

-- UI动态构建模块
function badboy.loaduilib() loadlib('__ui', 'bblibs.UI') end

-- Utils模块
function badboy.loadutilslib() loadlib('__utils', 'bblibs.utils') end

-- POS模块
function badboy.loadpos() return getlib('pos', 'bblibs.pos') end

-- luasocket
function badboy.loadluasocket() 

  flag_names = {
    ftp = 'bblibs.socket.ftp',
    http = 'bblibs.socket.http',
    smtp = 'bblibs.socket.smtp',
    socket = 'bblibs.socket.socket',
    ltn12 = 'bblibs.socket.ltn12'
  }
  
  for k, v in pairs(flag_names) do
    getlib(k, v)
  end
  
end

return badboy
