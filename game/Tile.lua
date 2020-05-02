local Sprite = require('lib/loveAnim/anim')
local GameConstants = require('game/GameConstants')
local Resources = require('game/Resources')

-- local TileType = require('TileType')
local Tile = {}
local TILE_WIDTH = 64
local TILE_HEIGHT = 64

local TileSpriteSheet
local TILE_SCALE = 2

function Tile.initTexture()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  TileSpriteSheet = Sprite.newSpriteSheet(Resources.TileTexture, 12, 1)
end

function Tile:new(type)
  newCell = {type = type, pathable = true}
  self.__index = self

  if newCell.type == GameConstants.Tile.FLOOR then
    newCell.spriteIndex = math.random(3)
  elseif newCell.type == GameConstants.Tile.BLOCK then
    newCell.pathable = false
    newCell.spriteIndex = 4
  elseif newCell.type == GameConstants.Tile.WALL then
    newCell.pathable = false
    newCell.spriteIndex = 7
  elseif newCell.type == GameConstants.Tile.WALL_TOP then
    newCell.pathable = false
    newCell.spriteIndex = 8
  elseif newCell.type == GameConstants.Tile.BRICK_LEFT then
    newCell.pathable = false
    newCell.spriteIndex = 6
  elseif newCell.type == GameConstants.Tile.BRICK_RIGHT then
    newCell.pathable = false
    newCell.spriteIndex = 5
  elseif newCell.type == GameConstants.Tile.BRICK_BOT then
    newCell.pathable = false
    newCell.spriteIndex = 9
  elseif newCell.type == GameConstants.Tile.DEVIL_END then
    newCell.spriteIndex = 10
  elseif newCell.type == GameConstants.Tile.ANGEL_END then
    newCell.spriteIndex = 11
  else newCell.spriteIndex = 12 end


  return setmetatable(newCell, self)
end


function Tile:show(x, y)
  TileSpriteSheet:showFrame(self.spriteIndex, x, y, 0, TILE_SCALE, TILE_SCALE)
end

return Tile
