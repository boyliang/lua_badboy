local pos = {}

pos.degree = function(color1, color2)
  local fl = math.floor
  local r,g,b = fl(color1/0x10000),fl(color1%0x10000/0x100),fl(color1%0x100)
  local r1,g1,b1 = fl(color2/0x10000),fl(color2%0x10000/0x100),fl(color2%0x100)
  
  return math.ceil(((1 - math.abs(r - r1) / 0xff) / 3 + (1 - math.abs(g - g1) / 0xff) / 3 + (1 - math.abs(b - b1) / 0xff) / 3) * 100)
end

--newpos对象
function pos:new(x, y, color)
  local options = {}
	options.x = x or 0
	options.y = y or 0
	options.color = color or 0x000000
  setmetatable(options, self)
	self.__index = self
  return options
end

--距离
function pos:distanceBetween(t)
	return  math.sqrt(math.abs(self.x - t.x) * math.abs(self.x - t.x) + math.abs(self.y - t.y) * math.abs(self.y - t.y))
end

--点击
function pos:click(sleep, slepp1)
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))  --设置随机数种子
  local index = math.random(1,5)
  local x = self.x + math.random(-2,2)
  local y = self.y + math.random(-2,2)
  touchDown(index, x, y)
  
  if sleep ~= nil then
	 mSleep(sleep)
  else
	 mSleep(math.random(60,80))                --某些特殊情况需要增大延迟才能模拟点击效果
  end
  
  touchUp(index, x, y)
  if sleep1 ~= nil then
	mSleep(sleep1)
  else
	mSleep(20)
  end
end

--滑动
function pos:touchMoveTo(t, step, sleep1, sleep2)
  local step = step or 20
  local sleep1 = sleep1 or 500
  local sleep2 = sleep2 or 20
    local x, y, x2, y2, index = self.x, self.y, t.x , t.y, math.random(1,5)
    touchDown(index, x, y)

    local function move(from, to) 
      if from > to then
        do 
          return -1 * step 
        end
      else 
        return step 
      end 
    end
  

    while (math.abs(x-x2) >= step) or (math.abs(y-y2) >= step) do
        if math.abs(x-x2) >= step then 
      x = x + move(x,x2)
    end
        if math.abs(y-y2) >= step then 
      y = y + move(y,y2) 
    end
        touchMove(index, x, y)
        mSleep(sleep2)
    end

    touchMove(index, x2, y2)
    mSleep(sleep1)
    touchUp(index, x2, y2)
end

--角度
function pos:angleBetween(t)
	return math.asin(math.abs(self.x - t.x) / math.abs(self.y - t.y)) * 180 / math.pi
end

--根据角度和距离找点
function pos:polarProjection(distance, angle)
	local addX = math.cos(angle * math.pi / 180) * distance
	local addY = math.sin(angle * math.pi / 180) * distance
	return pos:new(self.x + addX, self.y + addY)
end


--单点颜色点击
function pos:isColorClick(s)
  local fl,abs = math.floor,math.abs
	local c = self.color
	s = s or 90
  s = fl(0xff*(100-s)*0.01)
  local r,g,b = fl(c/0x10000),fl(c%0x10000/0x100),fl(c%0x100)
  local rr,gg,bb = getColorRGB(self.x,self.y)
  if abs(r-rr)<s and abs(g-gg)<s and abs(b-bb)<s then
      self:click()
  end
end

return pos