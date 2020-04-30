local Animation = require("lib/loveAnim/anim")

local Entity = {}

function Entity:new(x, y)
  newEnt = {}
  self.row , self.col = r, c
  self.__index = self
  return setmetatable(newEnt, self)
end

function Entity:update()

end

function Entity:show()

end

function Entity:getPos()
  return self.row , self.col
end

return Entity
