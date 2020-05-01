local Sprite = require('lib/loveAnim/anim')
local GameConstants = require('GameConstants')

-- local TileType = require('TileType')
local Tile = {}
local TILE_WIDTH = 64
local TILE_HEIGHT = 64

local TileSpriteSheet, tileQuads = {}

function Tile.initTexture()
  TileSpriteSheet = Sprite.newSpriteSheet('assets/images/tileset_light.png',
    10, 1)
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
  else newCell.spriteIndex = 10 end


  return setmetatable(newCell, self)
end


function Tile:show(x, y)
  TileSpriteSheet:showFrame(self.spriteIndex, x, y, 0, 2, 2)
end

return Tile
