local Grid = require("game/Grid")
local Twin = require('game/Player')
local Tile = require('game/Tile')
local GameConstants = require('game/GameConstants')
local loadLevel = require('game/LevelLoader')
local Resources = require('game/Resources')

local Level = {}


function Level:new(lv)
  newLevel = {}
  newLevel.levelIndex = 1
  self.__index = self
  return setmetatable(newLevel, self)
end


function Level:load()
  local path = 'levels/level' .. self.levelIndex .. '.json'
  self.grid = loadLevel(path)
  self.devilTwin = Twin:new(Twin.DEVIL)
  self.angelTwin = Twin:new(Twin.ANGEL)

  self.devilTwin:init(self.grid, self.grid.devilStart.row,
    self.grid.devilStart.col)
  self.angelTwin:init(self.grid, self.grid.angelStart.row,
    self.grid.angelStart.col)
end


function Level:draw()
    self.grid:show()
    self.devilTwin:show(grid)
    self.angelTwin:show(grid)
end

function Level:update(dt)
  self.devilTwin:update(dt)
  self.angelTwin:update(dt)
end


function Level:handleKeyPress(key)
    if key == 'a' then
      self.devilTwin:moveLeft(self.grid)
      self.angelTwin:moveRight(self.grid)
    elseif key == 'd' then
      self.devilTwin:moveRight(self.grid)
      self.angelTwin:moveLeft(self.grid)
    elseif key == 'w' then
      self.devilTwin:moveUp(self.grid)
      self.angelTwin:moveDown(self.grid)
    elseif key == 's' then
      self.devilTwin:moveDown(self.grid)
      self.angelTwin:moveUp(self.grid)
    end

    self.devilTwin:updatePos(self.grid)
    self.angelTwin:updatePos(self.grid)
    if (self.devilTwin:isMoving() or self.angelTwin:isMoving()) then
      Resources.Audio.Jump:play()
    end
end


return Level
