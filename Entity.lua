local AnimationPlayer = require("lib/AnimationPlayer")

local Entity = {}

function Entity:new(x, y)
  newEnt = {}
  self.row , self.col = r, c
  self.__index = self
  return setmetatable(newEnt, self)
end

function Entity:update(dt)
  if self.anm:isActive() then
    self.anim.update(dt)
  end
end


function Entity:show(x, y, r, sx, sy)
  if self.anm:isActive() then
    self.anim.show(x, y, r, sx, sy)
  end
end


function Entity:setTextureAtlas(path, hFrames, vFrames)
  self.anim = AnimationPlayer:new(path, hFrames, vFrames)
end


function Entity:getPos()
  return self.row , self.col
end


return Entity
