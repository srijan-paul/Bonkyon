local Grid = require("game/Grid")
local Twin = require('game/Player')
local Tile = require('game/Tile')
local Util = require('lib/helpers')
local GameConstants = require('game/GameConstants')
local loadLevel = require('game/LevelLoader')
local Resources = require('game/Resources')


local LevelState = {
  TRANSITION_IN = 0,
  ACTIVE = 1,
  TRANSITION_OUT = 2
}

local Level = {}
local levelYPos = -GameConstants.SCREEN_HEIGHT
local TRANSITION_SPEED = 40

function Level:new(lv)
  newLevel = {}
  newLevel.levelIndex = lv
  newLevel.state = LevelState.TRANSITION_IN
  self.__index = self
  return setmetatable(newLevel, self)
end


function Level:load()
  local path = 'levels/level' .. self.levelIndex .. '.json'
  self.grid = loadLevel(path)
  self.grid:init()
  self.devilTwin = Twin:new(Twin.DEVIL)
  self.angelTwin = Twin:new(Twin.ANGEL)

  self.devilTwin:init(self.grid, self.grid.devilStart.row,
    self.grid.devilStart.col)
  self.angelTwin:init(self.grid, self.grid.angelStart.row,
    self.grid.angelStart.col)

    -- love.graphics.setBackgroundColor(Util.hexToColor('#485460'))
    Resources.Audio.WhooshIn:play()
end


function Level:show()
    self.grid:show(0, levelYPos)
    self.devilTwin:show(grid, 0, levelYPos)
    self.angelTwin:show(grid, 0, levelYPos)
end


function Level:update(dt)
  if self.state == LevelState.TRANSITION_IN then
    levelYPos = levelYPos + TRANSITION_SPEED
    if levelYPos > 0 then
      levelYPos = 0
      self.state = LevelState.ACTIVE
    end
  end
  self.devilTwin:update(dt)
  self.angelTwin:update(dt)
end


function Level:handleKeyPress(key)
  if self.state ~= LevelState.ACTIVE then return end
    if key == 'a' then
      self.devilTwin:moveRight(self.grid)
      self.angelTwin:moveLeft(self.grid)
    elseif key == 'd' then
      self.devilTwin:moveLeft(self.grid)
      self.angelTwin:moveRight(self.grid)
    elseif key == 'w' then
      self.devilTwin:moveDown(self.grid)
      self.angelTwin:moveUp(self.grid)
    elseif key == 's' then
      self.devilTwin:moveUp(self.grid)
      self.angelTwin:moveDown(self.grid)
    end
    self.devilTwin:updatePos(self.grid)
    self.angelTwin:updatePos(self.grid)
    if (self.devilTwin:isMoving() or self.angelTwin:isMoving()) then
      if Resources.Audio.Jump:isPlaying() then
        Resources.Audio.Jump:stop()
      end
      Resources.Audio.Jump:play()
    end
end


return Level
