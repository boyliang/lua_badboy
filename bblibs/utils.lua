-- 作者boyliang
-- 时间: 2015-11-26

-- 格式化输出
function sysLogFmt(fmt, ...)
  sysLog(string.format(fmt, ...))
end

-- 任意输出
function sysLogLst(...)
  local msg = ''
  for k,v in pairs({...}) do
    msg = string.format('%s %s ', msg, tostring(v))
  end
  sysLog(msg)
end

-- 模拟一次点击
function tap(x, y)
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))  --设置随机数种子
  local index = math.random(1,5)
  x = x + math.random(-2,2)
  y = y + math.random(-2,2)
  touchDown(index,x, y)
  mSleep(math.random(60,80))                --某些特殊情况需要增大延迟才能模拟点击效果
  touchUp(index, x, y)
  mSleep(20)
end

-- 模拟滑动操作，从点(x1, y1)划到到(x2, y2)
function swip(x1,y1,x2,y2)
    local step, x, y, index = 20, x1 , y1, math.random(1,5)
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
        if math.abs(x-x2) >= step then x = x + move(x1,x2) end
        if math.abs(y-y2) >= step then y = y + move(y1,y2) end
        touchMove(index, x, y)
        mSleep(20)
    end

    touchMove(index, x2, y2)
    mSleep(30)
    touchUp(index, x2, y2)
end

-- 多点颜色对比，格式为{{x,y,color},{x,y,color}...} 
function cmpColor(array, s, isKeepScreen)
  s = s or 90
  s = math.floor(0xff * (100 - s) * 0.01)
  isKeepScreen = isKeepScreen or false
  
  local lockscreen = function(flag)
    if isKeepScreen == true then
      keepScreen(flag)
    end
  end

  lockscreen(true)
  for i = 1, #array do
    local lr,lg,lb = getColorRGB(array[i][1], array[i][2])
    local rgb = array[i][3]

    local r = math.floor(rgb/0x10000)
    local g = math.floor(rgb%0x10000/0x100)
    local b = math.floor(rgb%0x100)

    if math.abs(lr-r) > s or math.abs(lg-g) > s or math.abs(lb-b) > s then
      lockscreen(false)
      return false
    end
  end

  lockscreen(false)
  return true
end