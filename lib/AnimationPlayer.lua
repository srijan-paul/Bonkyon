local Anim = require("lib/loveAnim/anim")
local AnimationPlayer = {}

-- coding stuff like this by hand is so painful...

function AnimationPlayer:new(path, hFrames, vFrames)
  newPlayer = {
    _sheet = nil ,
    anims = {},
    currentAnim = nil
  }
  newPlayer._sheet = Anim.newSpriteSheet(path, hFrames, vFrames)
  self.__index = self
  return setmetatable(newPlayer, self)
end


function AnimationPlayer:add(key, str, time, loop)
  assert(type(str) == 'string')
  splitIndex = str:find('-')
  assert(splitIndex ~= nil)
  startIndex = tonumber(str:sub(1, splitIndex - 1))
  endIndex = tonumber(str:sub(splitIndex + 1, splitIndex + 1))
  self.anims[key] = Anim:new(self._sheet, startIndex, endIndex, time, loop)
end


function AnimationPlayer:play(key)
  if self.anims[key] == self.currentAnim then return end
  self.currentAnim = self.anims[key]
end


function AnimationPlayer:show(x, y, r, sx, sy)
  self.currentAnim:show(x, y, r, sx, sy)
end


function AnimationPlayer:update(dt)
  self.currentAnim:update(dt)
end


function AnimationPlayer:isActive()
  return self.currentAnim ~= nil
end


function AnimationPlayer:isPlaying(key)
  if key == nil then
    if self.currentAnim then return true else return false end
  end
  return self.anims[key] == currentAnim
end


return AnimationPlayer
