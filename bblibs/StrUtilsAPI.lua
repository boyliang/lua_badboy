--[[
Copyright (C) 2012 Thomas Farr a.k.a tomass1996 [farr.thomas@gmail.com]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

-The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-Visible credit is given to the original author.
-The software is distributed in a non-profit way.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local floor,modf, insert = math.floor,math.modf, table.insert
local char,format,rep = string.char,string.format,string.rep

local function basen(n,b)
  if n < 0 then
    n = -n
  end
       local t = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}~"
   if n < b then
  local ret = ""
  ret = ret..string.sub(t, (n%b)+1,(n%b)+1)
  return ret
   else
  local tob = tostring(basen(math.floor(n/b), b))
  local ret = tob..t:sub((n%b)+1,(n%b)+1)
  return ret
   end
end

local Base64 = {}
Base64["lsh"] = function(value,shift)
    return (value*(2^shift)) % 256
end
Base64["rsh"] = function(value,shift)
    return math.floor(value/2^shift) % 256
end
Base64["bit"] = function(x,b)
    return (x % 2^b - x % 2^(b-1) > 0)
end
Base64["lor"] = function(x,y)
    local result = 0
    for p=1,8 do result = result + (((Base64.bit(x,p) or Base64.bit(y,p)) == true) and 2^(p-1) or 0) end
    return result
end
Base64["base64chars"] = {
    [0]='A',[1]='B',[2]='C',[3]='D',[4]='E',[5]='F',[6]='G',[7]='H',[8]='I',[9]='J',[10]='K',
    [11]='L',[12]='M',[13]='N',[14]='O',[15]='P',[16]='Q',[17]='R',[18]='S',[19]='T',[20]='U',
    [21]='V',[22]='W',[23]='X',[24]='Y',[25]='Z',[26]='a',[27]='b',[28]='c',[29]='d',[30]='e',
    [31]='f',[32]='g',[33]='h',[34]='i',[35]='j',[36]='k',[37]='l',[38]='m',[39]='n',[40]='o',
    [41]='p',[42]='q',[43]='r',[44]='s',[45]='t',[46]='u',[47]='v',[48]='w',[49]='x',[50]='y',
    [51]='z',[52]='0',[53]='1',[54]='2',[55]='3',[56]='4',[57]='5',[58]='6',[59]='7',[60]='8',
    [61]='9',[62]='-',[63]='_'}
Base64["base64bytes"] = {
    ['A']=0,['B']=1,['C']=2,['D']=3,['E']=4,['F']=5,['G']=6,['H']=7,['I']=8,['J']=9,['K']=10,
    ['L']=11,['M']=12,['N']=13,['O']=14,['P']=15,['Q']=16,['R']=17,['S']=18,['T']=19,['U']=20,
    ['V']=21,['W']=22,['X']=23,['Y']=24,['Z']=25,['a']=26,['b']=27,['c']=28,['d']=29,['e']=30,
    ['f']=31,['g']=32,['h']=33,['i']=34,['j']=35,['k']=36,['l']=37,['m']=38,['n']=39,['o']=40,
    ['p']=41,['q']=42,['r']=43,['s']=44,['t']=45,['u']=46,['v']=47,['w']=48,['x']=49,['y']=50,
    ['z']=51,['0']=52,['1']=53,['2']=54,['3']=55,['4']=56,['5']=57,['6']=58,['7']=59,['8']=60,
    ['9']=61,['-']=62,['_']=63,['=']=nil}

local base32 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

local tSHA1 = {}
tSHA1["bytes_to_w32"] = function(a,b,c,d) return a*0x1000000+b*0x10000+c*0x100+d end
tSHA1["w32_to_bytes"] = function(i) return floor(i/0x1000000)%0x100,floor(i/0x10000)%0x100,floor(i/0x100)%0x100,i%0x100 end
tSHA1["w32_rot"] = function(bits,a)
    local b2 = 2^(32-bits)
    local a,b = modf(a/b2)
    return a+b*b2*(2^(bits))
end
tSHA1["byte_to_bits"] = function(b)
    local b = function (n)
        local b = floor(b/n)
        return b%2==1
    end
    return b(1),b(2),b(4),b(8),b(16),b(32),b(64),b(128)
end
tSHA1["bits_to_byte"] = function(a,b,c,d,e,f,g,h)
    local function n(b,x) return b and x or 0 end
    return n(a,1)+n(b,2)+n(c,4)+n(d,8)+n(e,16)+n(f,32)+n(g,64)+n(h,128)
end
tSHA1["bits_to_string"] = function(a,b,c,d,e,f,g,h)
    local function x(b) return b and "1" or "0" end
    return ("%s%s%s%s %s%s%s%s"):format(x(a),x(b),x(c),x(d),x(e),x(f),x(g),x(h))
end
tSHA1["byte_to_bit_string"] = function(b) return tSHA1.bits_to_string(byte_to_bits(b)) end
tSHA1["w32_to_bit_string"] = function(a)
    if type(a) == "string" then return a end
    local aa,ab,ac,ad = tSHA1.w32_to_bytes(a)
    local s = tSHA1.byte_to_bit_string
    return ("%s %s %s %s"):format(s(aa):reverse(),s(ab):reverse(),s(ac):reverse(),s(ad):reverse()):reverse()
end
tSHA1["band"] = function(a,b)
    local A,B,C,D,E,F,G,H = tSHA1.byte_to_bits(b)
    local a,b,c,d,e,f,g,h = tSHA1.byte_to_bits(a)
    return tSHA1.bits_to_byte(
        A and a, B and b, C and c, D and d,
        E and e, F and f, G and g, H and h)
end
tSHA1["bor"] = function(a,b)
    local A,B,C,D,E,F,G,H = tSHA1.byte_to_bits(b)
    local a,b,c,d,e,f,g,h = tSHA1.byte_to_bits(a)
    return tSHA1.bits_to_byte(
        A or a, B or b, C or c, D or d,
        E or e, F or f, G or g, H or h)
end
tSHA1["bxor"] = function(a,b)
    local A,B,C,D,E,F,G,H = tSHA1.byte_to_bits(b)
    local a,b,c,d,e,f,g,h = tSHA1.byte_to_bits(a)
    return tSHA1.bits_to_byte(
        A ~= a, B ~= b, C ~= c, D ~= d,
        E ~= e, F ~= f, G ~= g, H ~= h)
end
tSHA1["bnot"] = function(x) return 255-(x % 256) end
tSHA1["w32_comb"] = function(fn)
    return function (a,b)
        local aa,ab,ac,ad = tSHA1.w32_to_bytes(a)
        local ba,bb,bc,bd = tSHA1.w32_to_bytes(b)
        return tSHA1.bytes_to_w32(fn(aa,ba),fn(ab,bb),fn(ac,bc),fn(ad,bd))
    end
end
tSHA1["w32_xor_n"] = function(a,...)
    local aa,ab,ac,ad = tSHA1.w32_to_bytes(a)
    for i=1,select('#',...) do
        local ba,bb,bc,bd = tSHA1.w32_to_bytes(select(i,...))
        aa,ab,ac,ad = tSHA1.bxor(aa,ba),tSHA1.bxor(ab,bb),tSHA1.bxor(ac,bc),tSHA1.bxor(ad,bd)
    end
    return tSHA1.bytes_to_w32(aa,ab,ac,ad)
end
tSHA1["w32_or3"] = function(a,b,c)
    local aa,ab,ac,ad = tSHA1.w32_to_bytes(a)
    local ba,bb,bc,bd = tSHA1.w32_to_bytes(b)
    local ca,cb,cc,cd = tSHA1.w32_to_bytes(c)
    return tSHA1.bytes_to_w32(
        tSHA1.bor(aa,tSHA1.bor(ba,ca)), tSHA1.bor(ab,tSHA1.bor(bb,cb)), tSHA1.bor(ac,tSHA1.bor(bc,cc)), tSHA1.bor(ad,tSHA1.bor(bd,cd))
    )
end
tSHA1["w32_not"] = function(a) return 4294967295-(a % 4294967296) end
tSHA1["w32_add"] = function(a,b) return (a+b) % 4294967296 end
tSHA1["w32_add_n"] = function(a,...)
    for i=1,select('#',...) do
        a = (a+select(i,...)) % 4294967296
    end
    return a
end
tSHA1["w32_to_hexstring"] = function(w) return format("%08x",w) end
tSHA1["w32_and"] = tSHA1.w32_comb(tSHA1.band)
tSHA1["w32_xor"] = tSHA1.w32_comb(tSHA1.bxor)
tSHA1["w32_or"] = tSHA1.w32_comb(tSHA1.bor)

local CRC = {}
CRC.crc32 = {
    0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F,
    0xE963A535, 0x9E6495A3, 0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988,
    0x09B64C2B, 0x7EB17CBD, 0xE7B82D07, 0x90BF1D91, 0x1DB71064, 0x6AB020F2,
    0xF3B97148, 0x84BE41DE, 0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7,
    0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9,
    0xFA0F3D63, 0x8D080DF5, 0x3B6E20C8, 0x4C69105E, 0xD56041E4, 0xA2677172,
    0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B, 0x35B5A8FA, 0x42B2986C,
    0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59,
    0x26D930AC, 0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423,
    0xCFBA9599, 0xB8BDA50F, 0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924,
    0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D, 0x76DC4190, 0x01DB7106,
    0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F, 0x9FBFE4A5, 0xE8B8D433,
    0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 0x086D3D2D,
    0x91646C97, 0xE6635C01, 0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E,
    0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457, 0x65B0D9C6, 0x12B7E950,
    0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65,
    0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7,
    0xA4D1C46D, 0xD3D6F4FB, 0x4369E96A, 0x346ED9FC, 0xAD678846, 0xDA60B8D0,
    0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9, 0x5005713C, 0x270241AA,
    0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
    0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81,
    0xB7BD5C3B, 0xC0BA6CAD, 0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A,
    0xEAD54739, 0x9DD277AF, 0x04DB2615, 0x73DC1683, 0xE3630B12, 0x94643B84,
    0x0D6D6A3E, 0x7A6A5AA8, 0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1,
    0xF00F9344, 0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB,
    0x196C3671, 0x6E6B06E7, 0xFED41B76, 0x89D32BE0, 0x10DA7A5A, 0x67DD4ACC,
    0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5, 0xD6D6A3E8, 0xA1D1937E,
    0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
    0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55,
    0x316E8EEF, 0x4669BE79, 0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236,
    0xCC0C7795, 0xBB0B4703, 0x220216B9, 0x5505262F, 0xC5BA3BBE, 0xB2BD0B28,
    0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D,
    0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 0x9C0906A9, 0xEB0E363F,
    0x72076785, 0x05005713, 0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38,
    0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21, 0x86D3D2D4, 0xF1D4E242,
    0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777,
    0x88085AE6, 0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69,
    0x616BFFD3, 0x166CCF45, 0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2,
    0xA7672661, 0xD06016F7, 0x4969474D, 0x3E6E77DB, 0xAED16A4A, 0xD9D65ADC,
    0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 0x47B2CF7F, 0x30B5FFE9,
    0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605, 0xCDD70693,
    0x54DE5729, 0x23D967BF, 0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94,
    0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D }

local bit = {}
bit["bnot"] = function(n)
    local tbl = bit.tobits(n)
    local size = math.max(table.getn(tbl), 32)
    for i = 1, size do
        if(tbl[i] == 1) then
            tbl[i] = 0
        else
            tbl[i] = 1
        end
    end
    return bit.tonumb(tbl)
end
bit["band"] = function(m, n)
    local tbl_m = bit.tobits(m)
    local tbl_n = bit.tobits(n)
    bit.expand(tbl_m, tbl_n)
    local tbl = {}
    local rslt = math.max(table.getn(tbl_m), table.getn(tbl_n))
    for i = 1, rslt do
        if(tbl_m[i]== 0 or tbl_n[i] == 0) then
            tbl[i] = 0
        else
            tbl[i] = 1
        end
    end
    return bit.tonumb(tbl)
end
bit["bor"] = function(m, n)
    local tbl_m = bit.tobits(m)
    local tbl_n = bit.tobits(n)
    bit.expand(tbl_m, tbl_n)
    local tbl = {}
    local rslt = math.max(table.getn(tbl_m), table.getn(tbl_n))
    for i = 1, rslt do
        if(tbl_m[i]== 0 and tbl_n[i] == 0) then
            tbl[i] = 0
        else
            tbl[i] = 1
        end
    end
    return bit.tonumb(tbl)
end
bit["bxor"] = function(m, n)
    local tbl_m = bit.tobits(m)
    local tbl_n = bit.tobits(n)
    bit.expand(tbl_m, tbl_n)
    local tbl = {}
    local rslt = math.max(table.getn(tbl_m), table.getn(tbl_n))
    for i = 1, rslt do
        if(tbl_m[i] ~= tbl_n[i]) then
            tbl[i] = 1
        else
            tbl[i] = 0
        end
    end
    return bit.tonumb(tbl)
end
bit["brshift"] = function(n, bits)
    bit.checkint(n)
    local high_bit = 0
    if(n < 0) then
        n = bit.bnot(math.abs(n)) + 1
        high_bit = 2147483648
    end
    for i=1, bits do
        n = n/2
        n = bit.bor(math.floor(n), high_bit)
    end
    return math.floor(n)
end
bit["blshift"] = function(n, bits)
    bit.checkint(n)
    if(n < 0) then
        n = bit.bnot(math.abs(n)) + 1
    end
    for i=1, bits do
        n = n*2
    end
    return bit.band(n, 4294967295)
end
bit["bxor2"] = function(m, n)
    local rhs = bit.bor(bit.bnot(m), bit.bnot(n))
    local lhs = bit.bor(m, n)
    local rslt = bit.band(lhs, rhs)
    return rslt
end
bit["blogic_rshift"] = function(n, bits)
    bit.checkint(n)
    if(n < 0) then
        n = bit.bnot(math.abs(n)) + 1
    end
    for i=1, bits do
        n = n/2
    end
    return math.floor(n)
end
bit["tobits"] = function(n)
    bit.checkint(n)
    if(n < 0) then
        return bit.tobits(bit.bnot(math.abs(n)) + 1)
    end
    local tbl = {}
    local cnt = 1
    while (n > 0) do
        local last = math.fmod(n,2)
        if(last == 1) then
            tbl[cnt] = 1
        else
            tbl[cnt] = 0
        end
        n = (n-last)/2
        cnt = cnt + 1
    end
    return tbl
end
bit["tonumb"] = function(tbl)
    local n = table.getn(tbl)
    local rslt = 0
    local power = 1
    for i = 1, n do
        rslt = rslt + tbl[i]*power
        power = power*2
    end
    return rslt
end
bit["checkint"] = function(n)
    if(n - math.floor(n) > 0) then
        error("trying to use bitwise operation on non-integer!")
    end
end
bit["expand"] = function(tbl_m, tbl_n)
    local big = {}
    local small = {}
    if(table.getn(tbl_m) > table.getn(tbl_n)) then
        big = tbl_m
        small = tbl_n
    else
        big = tbl_n
        small = tbl_m
    end
    for i = table.getn(small) + 1, table.getn(big) do
        small[i] = 0
    end
end

local FCS = {}
FCS["16"] = {
    [0]=0, 4489, 8978, 12955, 17956, 22445, 25910, 29887,
    35912, 40385, 44890, 48851, 51820, 56293, 59774, 63735,
    4225, 264, 13203, 8730, 22181, 18220, 30135, 25662,
    40137, 36160, 49115, 44626, 56045, 52068, 63999, 59510,
    8450, 12427, 528, 5017, 26406, 30383, 17460, 21949,
    44362, 48323, 36440, 40913, 60270, 64231, 51324, 55797,
    12675, 8202, 4753, 792, 30631, 26158, 21685, 17724,
    48587, 44098, 40665, 36688, 64495, 60006, 55549, 51572,
    16900, 21389, 24854, 28831, 1056, 5545, 10034, 14011,
    52812, 57285, 60766, 64727, 34920, 39393, 43898, 47859,
    21125, 17164, 29079, 24606, 5281, 1320, 14259, 9786,
    57037, 53060, 64991, 60502, 39145, 35168, 48123, 43634,
    25350, 29327, 16404, 20893, 9506, 13483, 1584, 6073,
    61262, 65223, 52316, 56789, 43370, 47331, 35448, 39921,
    29575, 25102, 20629, 16668, 13731, 9258, 5809, 1848,
    65487, 60998, 56541, 52564, 47595, 43106, 39673, 35696,
    33800, 38273, 42778, 46739, 49708, 54181, 57662, 61623,
    2112, 6601, 11090, 15067, 20068, 24557, 28022, 31999,
    38025, 34048, 47003, 42514, 53933, 49956, 61887, 57398,
    6337, 2376, 15315, 10842, 24293, 20332, 32247, 27774,
    42250, 46211, 34328, 38801, 58158, 62119, 49212, 53685,
    10562, 14539, 2640, 7129, 28518, 32495, 19572, 24061,
    46475, 41986, 38553, 34576, 62383, 57894, 53437, 49460,
    14787, 10314, 6865, 2904, 32743, 28270, 23797, 19836,
    50700, 55173, 58654, 62615, 32808, 37281, 41786, 45747,
    19012, 23501, 26966, 30943, 3168, 7657, 12146, 16123,
    54925, 50948, 62879, 58390, 37033, 33056, 46011, 41522,
    23237, 19276, 31191, 26718, 7393, 3432, 16371, 11898,
    59150, 63111, 50204, 54677, 41258, 45219, 33336, 37809,
    27462, 31439, 18516, 23005, 11618, 15595, 3696, 8185,
    63375, 58886, 54429, 50452, 45483, 40994, 37561, 33584,
    31687, 27214, 22741, 18780, 15843, 11370, 7921, 3960 }
FCS["32"] = {
    [0]=0, 1996959894, -301047508, -1727442502, 124634137, 1886057615, -379345611, -1637575261,
    249268274, 2044508324, -522852066, -1747789432, 162941995, 2125561021, -407360249, -1866523247,
    498536548, 1789927666, -205950648, -2067906082, 450548861, 1843258603, -187386543, -2083289657,
    325883990, 1684777152, -43845254, -1973040660, 335633487, 1661365465, -99664541, -1928851979,
    997073096, 1281953886, -715111964, -1570279054, 1006888145, 1258607687, -770865667, -1526024853,
    901097722, 1119000684, -608450090, -1396901568, 853044451, 1172266101, -589951537, -1412350631,
    651767980, 1373503546, -925412992, -1076862698, 565507253, 1454621731, -809855591, -1195530993,
    671266974, 1594198024, -972236366, -1324619484, 795835527, 1483230225, -1050600021, -1234817731,
    1994146192, 31158534, -1731059524, -271249366, 1907459465, 112637215, -1614814043, -390540237,
    2013776290, 251722036, -1777751922, -519137256, 2137656763, 141376813, -1855689577, -429695999,
    1802195444, 476864866, -2056965928, -228458418, 1812370925, 453092731, -2113342271, -183516073,
    1706088902, 314042704, -1950435094, -54949764, 1658658271, 366619977, -1932296973, -69972891,
    1303535960, 984961486, -1547960204, -725929758, 1256170817, 1037604311, -1529756563, -740887301,
    1131014506, 879679996, -1385723834, -631195440, 1141124467, 855842277, -1442165665, -586318647,
    1342533948, 654459306, -1106571248, -921952122, 1466479909, 544179635, -1184443383, -832445281,
    1591671054, 702138776, -1328506846, -942167884, 1504918807, 783551873, -1212326853, -1061524307,
    -306674912, -1698712650, 62317068, 1957810842, -355121351, -1647151185, 81470997, 1943803523,
    -480048366, -1805370492, 225274430, 2053790376, -468791541, -1828061283, 167816743, 2097651377,
    -267414716, -2029476910, 503444072, 1762050814, -144550051, -2140837941, 426522225, 1852507879,
    -19653770, -1982649376, 282753626, 1742555852, -105259153, -1900089351, 397917763, 1622183637,
    -690576408, -1580100738, 953729732, 1340076626, -776247311, -1497606297, 1068828381, 1219638859,
    -670225446, -1358292148, 906185462, 1090812512, -547295293, -1469587627, 829329135, 1181335161,
    -882789492, -1134132454, 628085408, 1382605366, -871598187, -1156888829, 570562233, 1426400815,
    -977650754, -1296233688, 733239954, 1555261956, -1026031705, -1244606671, 752459403, 1541320221,
    -1687895376, -328994266, 1969922972, 40735498, -1677130071, -351390145, 1913087877, 83908371,
    -1782625662, -491226604, 2075208622, 213261112, -1831694693, -438977011, 2094854071, 198958881,
    -2032938284, -237706686, 1759359992, 534414190, -2118248755, -155638181, 1873836001, 414664567,
    -2012718362, -15766928, 1711684554, 285281116, -1889165569, -127750551, 1634467795, 376229701,
    -1609899400, -686959890, 1308918612, 956543938, -1486412191, -799009033, 1231636301, 1047427035,
    -1362007478, -640263460, 1088359270, 936918000, -1447252397, -558129467, 1202900863, 817233897,
    -1111625188, -893730166, 1404277552, 615818150, -1160759803, -841546093, 1423857449, 601450431,
    -1285129682, -1000256840, 1567103746, 711928724, -1274298825, -1022587231, 1510334235, 755167117 }

--String Utils :

local strutils = {}

function toCharTable(str)  --Returns table of @str's chars
    if not str then return nil end
    str = tostring(str)
  local chars = {}
  for n=1,#str do
    chars[n] = str:sub(n,n)
  end
  return chars
end
strutils.toCharTable = toCharTable

function toByteTable(str)  --Returns table of @str's bytes
    if not str then return nil end
    str = tostring(str)
  local bytes = {}
  for n=1,#str do
    bytes[n] = str:byte(n)
  end
  return bytes
end
strutils.toByteTable = toByteTable


function fromCharTable(chars)  --Returns string made of chracters in @chars
    if not chars or type(chars)~="table" then return nil end
  return table.concat(chars)
end
strutils.fromCharTable = fromCharTable


function fromByteTable(bytes)  --Returns string made of bytes in @bytes
    if not bytes or type(bytes)~="table" then return nil end
  local str = ""
  for n=1,#bytes do
    str = str..string.char(bytes[n])
  end
  return str
end
strutils.fromByteTable = fromByteTable


function contains(str,find)  --Returns true if @str contains @find
    if not str then return nil end
    str = tostring(str)
  for n=1, #str-#find+1 do
    if str:sub(n,n+#find-1) == find then return true end
  end
  return false
end
strutils.contains = contains

function startsWith(str,Start) --Check if @str starts with @Start
    if not str then return nil end
    str = tostring(str)
    return str:sub(1,Start:len())==Start
end
strutils.startsWith = startsWith

function endsWith(str,End)  --Check if @str ends with @End
    if not str then return nil end
    str = tostring(str)
    return End=='' or str:sub(#str-#End+1)==End
end
strutils.endsWith = endsWith

function trim(str)  --Trim @str of initial/trailing whitespace
    if not str then return nil end
    str = tostring(str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end
strutils.trim = trim

function firstLetterUpper(str)  --Capitilizes first letter of @str
    if not str then return nil end
    str = tostring(str)
  str = str:gsub("%a", string.upper, 1)
    return str
end
strutils.firstLetterUpper = firstLetterUpper

function titleCase(str)  --Changes @str to title case
  if not str then return nil end
  str = tostring(str)
    local function tchelper(first, rest)
    return first:upper()..rest:lower()
    end
    str = str:gsub("(%a)([%w_']*)", tchelper)
  return str
end
strutils.titleCase = titleCase

function isRepetition(str, pat)  --Checks if @str is a repetition of @pat
    if not str then return nil end
    str = tostring(str)
  return "" == str:gsub(pat, "")
end

function isRepetitionWS(str, pat)  --Checks if @str is a repetition of @pat seperated by whitespaces
    if not str then return nil end
    str = tostring(str)
  return not str:gsub(pat, ""):find"%S"
end
strutils.isRepetitionWS = isRepetitionWS

function urlDecode(str)  --Url decodes @str
    if not str then return nil end
    str = tostring(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)", function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end
strutils.urlDecode = urlDecode

function urlEncode(str)  --Url encodes @str
    if not str then return nil end
    str = tostring(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])", function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str
end
strutils.urlEncode = urlEncode

function isEmailAddress(str)  --Checks if @str is a valid email address
    if not str then return nil end
    str = tostring(str)
  if (str:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then
    return true
  else
    return false
  end
end
strutils.isEmailAddress = isEmailAddress

function chunk(str, size)  --Splits @str into chunks of length @size
  if not size then return nil end
  str = tostring(str)
  local num2App = size - (#str%size)
  str = str..(rep(char(0), num2App) or "")
  assert(#str%size==0)
  local chunks = {}
  local numChunks = #str / size
  local chunk = 0
  while chunk < numChunks do
    local start = chunk * size + 1
        chunk = chunk+1
    if start+size-1 > #str-num2App then
            if str:sub(start, #str-num2App) ~= (nil or "") then
          chunks[chunk] = str:sub(start, #str-num2App)
            end
    else
      chunks[chunk] = str:sub(start, start+size-1)
    end
  end
  return chunks
end
strutils.chunk = chunk

function find(str, match, startIndex)  --Finds @match in @str optionally after @startIndex
  if not match then return nil end
  str = tostring(str)
  local _ = startIndex or 1
  local _s = nil
  local _e = nil
  local _len = match:len()
  while true do
    local _t = str:sub( _ , _len + _ - 1)
    if _t == match then
      _s = _
      _e = _ + _len - 1
      break
    end
    _ = _ + 1
    if _ > str:len() then break end
  end
  if _s == nil then return nil else return _s, _e end
end
strutils.find = find

function seperate(str, divider)  --Separates @str on @divider
  if not divider then return nil end
  str = tostring(str)
  local start = {}
  local endS = {}
  local n=1
  repeat
    if n==1 then
      start[n], endS[n] = find(str, divider)
    else
      start[n], endS[n] = find(str, divider, endS[n-1]+1)
        end
    n=n+1
  until start[n-1]==nil
  local subs = {}
  for n=1, #start+1 do
    if n==1 then
      subs[n] = str:sub(1, start[n]-1)
    elseif n==#start+1 then
      subs[n] = str:sub(endS[n-1]+1)
    else
      subs[n] = str:sub(endS[n-1]+1, start[n]-1)
        end
  end
  return subs
end
strutils.seperate = seperate

function replace(str, from, to)  --Replaces @from to @to in @str
  if not from then return nil end
  str = tostring(str)
  local pcs = seperate(str, from)
  str = pcs[1]
  for n=2,#pcs do
    str = str..to..pcs[n]
  end
  return str
end
strutils.replace = replace

function jumble(str)  --Jumbles @str
  if not str then return nil end
  str = tostring(str)
  local chars = {}
  for i = 1, #str do
    chars[i] = str:sub(i, i)
  end
  local usedNums = ":"
  local res = ""
  local rand = 0
  for i=1, #chars do
    while true do
      rand = math.random(#chars)
      if find(usedNums, ":"..rand..":") == nil then break end
    end
    res = res..chars[rand]
    usedNums = usedNums..rand..":"
  end
  return res
end
strutils.jumble = jumble

function toBase(str, base)  --Encodes @str in @base
  if not base then return nil end
  str = tostring(str)
  local res = ""
  for i = 1, str:len() do
    if i == 1 then
      res = basen(str:byte(i), base)
    else
      res = res..":"..basen(str:byte(i), base)
    end
  end
  return res
end
strutils.toBase = toBase

function fromBase(str, base)  --Decodes @str from @base
  if not base then return nil end
  str = tostring(str)
  local bytes = seperate(str, ":")
  local res = ""
  for i = 1, #bytes do
    res = res..(string.char(basen(tonumber(bytes[i], base), 10)))
  end
  return res
end
strutils.fromBase = fromBase

function toBinary(str)  --Encodes @str in binary
  if not str then return nil end
  str = tostring(str)
  return toBase(str, 2)
end
strutils.toBinary = toBinary

function fromBinary(str)  --Decodes @str from binary
  if not str then return nil end
  str = tostring(str)
  return fromBase(str, 2)
end
strutils.fromBinary = fromBinary

function toOctal(str)  --Encodes @str in octal
  if not str then return nil end
  str = tostring(str)
  return toBase(str, 8)
end
strutils.toOctal = toOctal

function fromOctal(str)  --Decodes @str from octal
  if not str then return nil end
  str = tostring(str)
  return fromBase(str, 8)
end
strutils.fromOctal = fromOctal

function toHex(str)  --Encodes @str in hex
  if not str then return nil end
  str = tostring(str)
  return toBase(str, 16)
end
strutils.toHex = toHex

function fromHex(str)  --Decodes @str from hex
  if not str then return nil end
  str = tostring(str)
  return fromBase(str, 16)
end
strutils.fromHex = fromHex

function toBase36(str)  --Encodes @str in Base36
  if not str then return nil end
  str = tostring(str)
  return toBase(str, 36)
end
strutils.toBase36 = toBase36

function fromBase36(str)  --Decodes @str from Base36
  if not str then return nil end
  str = tostring(str)
  return fromBase(str, 36)
end
strutils.fromBase36 = fromBase36

function toBase32(str)  --Encodes @str in Base32
  if not str then return nil end
  str = tostring(str)
  local byte=0
  local bits=0
  local rez=""
  local i=0
  for i = 1, str:len() do
    byte=byte*256+str:byte(i)
    bits=bits+8
    repeat
      bits=bits-5
      local mul=(2^(bits))
      local b32n=math.floor(byte/mul)
      byte=byte-(b32n*mul)
      b32n=b32n+1
      rez=rez..string.sub(base32,b32n,b32n)
    until bits<5
  end
  if bits>0 then
    local b32n= math.fmod(byte*(2^(5-bits)),32)
    b32n=b32n+1
    rez=rez..string.sub(base32,b32n,b32n)
  end
  return rez
end
strutils.toBase32 = toBase32

function fromBase32(str)  --Decodes @str from Base32
  if not str then return nil end
  str = tostring(str)
  local b32n=0
  local bits=0
  local rez=""
  local i=0
  string.gsub(str:upper(), "["..base32.."]", function (char)
    local num = string.find(base32, char, 1, true)
    b32n=b32n*32+(num - 1)
    bits=bits+5
    while  bits>=8 do
      bits=bits-8
      local mul=(2^(bits))
      local byte = math.floor(b32n/mul)
      b32n=b32n-(byte*mul)
      rez=rez..string.char(byte)
    end
  end)
  return rez
end
strutils.fromBase32 = fromBase32

function toBase64(str)  --Encodes @str in Base64
  if not str then return nil end
  str = tostring(str)
  local bytes = {}
  local result = ""
  for spos=0,str:len()-1,3 do
    for byte=1,3 do bytes[byte] = str:byte(spos+byte) or 0 end
    result = string.format('%s%s%s%s%s',result,Base64.base64chars[Base64.rsh(bytes[1],2)],Base64.base64chars[Base64.lor(Base64.lsh((bytes[1] % 4),4), Base64.rsh(bytes[2],4))] or "=",((str:len()-spos) > 1) and Base64.base64chars[Base64.lor(Base64.lsh(bytes[2] % 16,2), Base64.rsh(bytes[3],6))] or "=",((str:len()-spos) > 2) and Base64.base64chars[(bytes[3] % 64)] or "=")
  end
  return result
end
strutils.toBase64 = toBase64

function fromBase64(str)  --Decodes @str from Base64
  if not str then return nil end
  str = tostring(str)
  local chars = {}
  local result=""
  for dpos=0,str:len()-1,4 do
    for char=1,4 do chars[char] = Base64.base64bytes[(str:sub((dpos+char),(dpos+char)) or "=")] end
    result = string.format('%s%s%s%s',result,string.char(Base64.lor(Base64.lsh(chars[1],2), Base64.rsh(chars[2],4))),(chars[3] ~= nil) and string.char(Base64.lor(Base64.lsh(chars[2],4), Base64.rsh(chars[3],2))) or "",(chars[4] ~= nil) and string.char(Base64.lor(Base64.lsh(chars[3],6) % 192, (chars[4]))) or "")
  end
  return result
end
strutils.fromBase64 = fromBase64

function rot13(str)  --Rot13s @str
  if not str then return nil end
  str = tostring(str)
  local rot = ""
  local len = str:len()
  for i = 1, len do
    local k = str:byte(i)
    if (k >= 65 and k <= 77) or (k >= 97 and k <=109) then
      rot = rot..string.char(k+13)
    elseif (k >= 78 and k <= 90) or (k >= 110 and k <= 122) then
      rot = rot..string.char(k-13)
    else
      rot = rot..string.char(k)
    end
  end
  return rot
end
strutils.rot13 = rot13

function rot47(str)  --Rot47s @str
  if not str then return nil end
  str = tostring(str)
  local rot = ""
  for i = 1, str:len() do
    local p = str:byte(i)
    if p >= string.byte('!') and p <= string.byte('O') then
      p = ((p + 47) % 127)
    elseif p >= string.byte('P') and p <= string.byte('~') then
      p = ((p - 47) % 127)
    end
    rot = rot..string.char(p)
  end
  return rot
end
strutils.rot47 = rot47

function SHA1(str) --Returns SHA1 Hash of @str
    if not str then return nil end
    str = tostring(str)
    local H0,H1,H2,H3,H4 = 0x67452301,0xEFCDAB89,0x98BADCFE,0x10325476,0xC3D2E1F0
    local msg_len_in_bits = #str * 8
    local first_append = char(0x80)
    local non_zero_message_bytes = #str +1 +8
    local current_mod = non_zero_message_bytes % 64
    local second_append = current_mod>0 and rep(char(0), 64 - current_mod) or ""
    local B1, R1 = modf(msg_len_in_bits  / 0x01000000)
    local B2, R2 = modf( 0x01000000 * R1 / 0x00010000)
    local B3, R3 = modf( 0x00010000 * R2 / 0x00000100)
    local B4    = 0x00000100 * R3
    local L64 = char( 0) .. char( 0) .. char( 0) .. char( 0)
            .. char(B1) .. char(B2) .. char(B3) .. char(B4)
    str = str .. first_append .. second_append .. L64
    assert(#str % 64 == 0)
    local chunks = #str / 64
    local W = { }
    local start, A, B, C, D, E, f, K, TEMP
    local chunk = 0
    while chunk < chunks do
        start,chunk = chunk * 64 + 1,chunk + 1
        for t = 0, 15 do
            W[t] = tSHA1.bytes_to_w32(str:byte(start, start + 3))
            start = start + 4
        end
        for t = 16, 79 do
            W[t] = tSHA1.w32_rot(1, tSHA1.w32_xor_n(W[t-3], W[t-8], W[t-14], W[t-16]))
        end
        A,B,C,D,E = H0,H1,H2,H3,H4
        for t = 0, 79 do
            if t <= 19 then
                f = tSHA1.w32_or(tSHA1.w32_and(B, C), tSHA1.w32_and(tSHA1.w32_not(B), D))
                K = 0x5A827999
            elseif t <= 39 then
                f = tSHA1.w32_xor_n(B, C, D)
                K = 0x6ED9EBA1
            elseif t <= 59 then
                f = tSHA1.w32_or3(tSHA1.w32_and(B, C), tSHA1.w32_and(B, D), tSHA1.w32_and(C, D))
                K = 0x8F1BBCDC
            else
                f = tSHA1.w32_xor_n(B, C, D)
                K = 0xCA62C1D6
            end
            A,B,C,D,E = tSHA1.w32_add_n(tSHA1.w32_rot(5, A), f, E, W[t], K),
            A, tSHA1.w32_rot(30, B), C, D
        end
        H0,H1,H2,H3,H4 = tSHA1.w32_add(H0, A),tSHA1.w32_add(H1, B),tSHA1.w32_add(H2, C),tSHA1.w32_add(H3, D),tSHA1.w32_add(H4, E)
    end
    local f = tSHA1.w32_to_hexstring
    return f(H0) .. f(H1) .. f(H2) .. f(H3) .. f(H4)
end
strutils.SHA1 = SHA1

function CRC32(str) --Returns CRC32 Hash of @str
    local crc, l, i = 0xFFFFFFFF, string.len(str)
    for i = 1, l, 1 do
        crc = bit.bxor(bit.brshift(crc, 8), CRC.crc32[bit.band(bit.bxor(crc, string.byte(str, i)), 0xFF) + 1])
    end
    return bit.bxor(crc, -1)
end
strutils.CRC32 = CRC32

function FCS16(str) --Returns FCS16 Hash of @str
    local i
    local l=string.len(str)
    local uFcs16 = 65535
    for i = 1,l do
        uFcs16 = bit.bxor(bit.brshift(uFcs16,8), FCS["16"][bit.band(bit.bxor(uFcs16, string.byte(str,i)), 255)])
    end
    return  bit.bxor(uFcs16, 65535)
end
strutils.FCS16 = FCS16

function FCS32(str) --Returns FCS32 Hash of @str
    local i
    local l = string.len(str)
    local uFcs32 = -1
    for i=1,l do
        uFcs32 = bit.bxor(bit.brshift(uFcs32,8), FCS["32"][bit.band(bit.bxor(uFcs32, string.byte(str,i)), 255)])
    end
    return bit.bnot(uFcs32)
end
strutils.FCS32 = FCS32

function encrypt(str, key)  --Encrypts @str with @key
  if not key then return nil end
  str = tostring(str)
  local alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}~"
  local _rand = math.random(#alphabet-10)
  local iv = string.sub(jumble(alphabet), _rand, _rand  + 9)
  iv = jumble(iv)
  str = iv..str
  local key = SHA1(key)
  local strLen = str:len()
  local keyLen = key:len()
  local j=1
  local result = ""
  for i=1, strLen do
    local ordStr = string.byte(str:sub(i,i))
    if j == keyLen then j=1 end
    local ordKey = string.byte(key:sub(j,j))
    result = result..string.reverse(basen(ordStr+ordKey, 36))
    j = j+1
  end
  return result
end
strutils.encrypt = encrypt

function decrypt(str, key)  --Decrypts @str with @key
  if not key then return nil end
  str = tostring(str)
  local key = SHA1(key)
  local strLen = str:len()
  local keyLen = key:len()
  local j=1
  local result = ""
  for i=1, strLen, 2 do
    local ordStr = basen(tonumber(string.reverse(str:sub(i, i+1)),36),10)
    if j==keyLen then j=1 end
    local ordKey = string.byte(key:sub(j,j))
    result = result..string.char(ordStr-ordKey)
    j = j+1
  end
  return result:sub(11)
end
strutils.decrypt = decrypt

function setRandSeed(seed)  --Sets random seed to @seed
  math.randomseed(seed)
end
strutils.setRandSeed = setRandSeed

--function Test()
--    local br = "\n----------\n"
--    setRandSeed(os.time())
--    local logFile = io.open("StrUtilTest.log", "w")
--    logFile:write(br)
--    logFile:write("toCharTable(\"Hello\")".."\n")
--    local ct = toCharTable("Hello")
--    for k,v in pairs(ct) do logFile:write(k.."-"..v.."\n") end
--    logFile:write(br)
--    logFile:write("fromCharTable()".."\n")
--    logFile:write(fromCharTable(ct).."\n")
--    logFile:write(br)
--    logFile:write("toByteTable(\"Hello\")".."\n")
--    local bt = toByteTable("Hello")
--    for k,v in pairs(bt) do logFile:write(k.."-"..v.."\n") end
--    logFile:write(br)
--    logFile:write("fromByteTable()".."\n")
--    logFile:write(fromByteTable(bt).."\n")
--    logFile:write(br)
--    logFile:write("contains(\"Hello\", \"Hell\")".."\n")
--    logFile:write(tostring(contains("Hello", "Hell")).."\n")
--    logFile:write(br)
--    logFile:write("startsWith(\"Hello\", \"H\")".."\n")
--    logFile:write(tostring(startsWith("Hello", "H")).."\n")
--    logFile:write(br)
--    logFile:write("endsWith(\"Hello\", \"o\")".."\n")
--    logFile:write(tostring(endsWith("Hello", "o")).."\n")
--    logFile:write(br)
--    logFile:write("trim(\"   Hello   \")".."\n")
--    logFile:write(trim("   Hello   ").."\n")
--    logFile:write(br)
--    logFile:write("firstLetterUpper(\"hello\")".."\n")
--    logFile:write(firstLetterUpper("hello").."\n")
--    logFile:write(br)
--    logFile:write("titleCase(\"hello world, how are you\")".."\n")
--    logFile:write(titleCase("hello world, how are you").."\n")
--    logFile:write(br)
--    logFile:write("isRepetition(\"HelloHelloHello\", \"Hello\")".."\n")
--    logFile:write(tostring(isRepetition("HelloHelloHello", "Hello")).."\n")
--    logFile:write(br)
--    logFile:write("isRepetitionWS(\"Hello Hello Hello\", \"Hello\")".."\n")
--    logFile:write(tostring(isRepetitionWS("Hello Hello Hello", "Hello")).."\n")
--    logFile:write(br)
--    logFile:write("urlEncode(\"Hello There World\")".."\n")
--    local US = urlEncode("Hello There World")
--    logFile:write(US.."\n")
--    logFile:write(br)
--    logFile:write("urlDecode()".."\n")
--    logFile:write(urlDecode(US).."\n")
--    logFile:write(br)
--    logFile:write("isEmailAddress(\"cooldude@emailhost.com\")".."\n")
--    logFile:write(tostring(isEmailAddress("cooldude@emailhost.com")).."\n")
--    logFile:write(br)
--    logFile:write("chunk(\"123456789\", 3)".."\n")
--    local chnk = chunk("123456789", 3)
--    for k,v in pairs(chnk) do logFile:write(k.."-"..v.."\n") end
--    logFile:write(br)
--    logFile:write("find(\"Hello World HeHe\", \"World\")".."\n")
--    logFile:write(find("Hello World HeHe", "World").."\n")
--    logFile:write(br)
--    logFile:write("seperate(\"1.2.3.4.5\", \".\")".."\n")
--    local pcs = seperate("1.2.3.4.5", ".")
--    for k,v in pairs(pcs) do logFile:write(k.."-"..v.."\n") end
--    logFile:write(br)
--  logFile:write("replace(\"# # # #\",\" \",\"*\")".."\n")
--  logFile:write(replace("# # # #", " ", "*").."\n")
--  logFile:write(br)
--    logFile:write("jumble(\"Hello World\")".."\n")
--    logFile:write(jumble("Hello World").."\n")
--    logFile:write(br)
--    logFile:write("toBase(\"Hello\", 13)".."\n")
--    local tb = toBase("Hello", 13)
--    logFile:write(tb.."\n")
--    logFile:write(br)
--    logFile:write("fromBase()".."\n")
--    logFile:write(fromBase(tb,13).."\n")
--    logFile:write(br)
--    logFile:write("toBinary(\"Hello\")".."\n")
--    local tb = toBinary("Hello")
--    logFile:write(tb.."\n")
--    logFile:write(br)
--    logFile:write("fromBinary()".."\n")
--    logFile:write(fromBinary(tb).."\n")
--    logFile:write(br)
--    logFile:write("toOctal(\"Hello\")".."\n")
--    local tb = toOctal("Hello")
--    logFile:write(tb.."\n")
--    logFile:write(br)
--    logFile:write("fromOctal()".."\n")
--    logFile:write(fromOctal(tb).."\n")
--    logFile:write(br)
--    logFile:write("toHex(\"Hello\")".."\n")
--    local tb = toHex("Hello")
--    logFile:write(tb.."\n")
--    logFile:write(br)
--    logFile:write("fromHex()".."\n")
--    logFile:write(fromHex(tb).."\n")
--    logFile:write(br)
--    logFile:write("toBase36(\"Hello\")".."\n")
--    local tb = toBase36("Hello")
--    logFile:write(tb.."\n")
--    logFile:write(br)
--    logFile:write("fromBase36()".."\n")
--    logFile:write(fromBase36(tb).."\n")
--    logFile:write(br)
--    logFile:write("toBase32(\"Hello\")".."\n")
--    local tb = toBase32("Hello")
--    logFile:write(tb.."\n")
--    logFile:write(br)
--    logFile:write("fromBase32()".."\n")
--    logFile:write(fromBase32(tb).."\n")
--    logFile:write(br)
--    logFile:write("toBase64(\"Hello\")".."\n")
--    local tb = toBase64("Hello")
--    logFile:write(tb.."\n")
--    logFile:write(br)
--    logFile:write("fromBase64()".."\n")
--    logFile:write(fromBase64(tb).."\n")
--    logFile:write(br)
--    logFile:write("rot13(\"Hello\")".."\n")
--    logFile:write(rot13("Hello").."\n")
--    logFile:write(br)
--    logFile:write("rot47(\"Hello\")".."\n")
--    logFile:write(rot47("Hello").."\n")
--    logFile:write(br)
--    logFile:write("SHA1(\"Hello\")".."\n")
--    logFile:write(SHA1("Hello").."\n")
--    logFile:write(br)
--    logFile:write("CRC32(\"Hello\")".."\n")
--    logFile:write(CRC32("Hello").."\n")
--    logFile:write(br)
--    logFile:write("FCS16(\"Hello\")".."\n")
--    logFile:write(FCS16("Hello").."\n")
--    logFile:write(br)
--    logFile:write("FCS32(\"Hello\")".."\n")
--    logFile:write(FCS32("Hello").."\n")
--    logFile:write(br)
--    logFile:write("encrypt(\"Hello\", \"Key\")".."\n")
--    local enc = encrypt("Hello", "Key")
--    logFile:write(enc.."\n")
--    logFile:write(br)
--    logFile:write("decrypt()".."\n")
--    logFile:write(decrypt(enc, "Key").."\n")
--    logFile:write(br)
--    logFile:close()
--end
--Test()

setRandSeed(os.time())

return strutils