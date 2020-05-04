local AnimationPlayer = require('lib/AnimationPlayer')

local Entity = {}

function Entity:new(r, c)
    local newEnt = {}
    self.row, self.col = r, c
    self.__index = self
    self.collision = false
    return setmetatable(newEnt, self)
end

function Entity:update(dt) if self.anim:isActive() then self.anim:update(dt) end end

function Entity:setCollision(bool) self.collision = bool end

function Entity:show(x, y, r)
    if self.anim:isActive() then self.anim:show(x, y, r, 2, 2) end
end

function Entity:setTextureAtlas(path, hFrames, vFrames)
    self.anim = AnimationPlayer:new(path, hFrames, vFrames)
end

function Entity:getPos() return self.row, self.col end

return Entity
