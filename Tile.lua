local Sprite = require('lib/loveAnim/anim')
local GameConstants = require('GameConstants')

-- local TileType = require('TileType')
local Tile = {}
local TILE_WIDTH = 64
local TILE_HEIGHT = 64

local TileSpriteSheet, tileQuads = {}

function Tile.initTexture()
  TileSpriteSheet = Sprite.newSpriteSheet('assets/images/tileset_light.png',
    5, 1)
end

function Tile:new(type)
  newCell = {type = type, pathable = true}
  self.__index = self

  if newCell.type == GameConstants.Tile.FLOOR then
    newCell.spriteIndex = math.random(3)
  elseif newCell.type == GameConstants.Tile.BLOCK then
    newCell.pathable = false
    newCell.spriteIndex = 4
  elseif newCell.type == GameConstants.Tile.DEVIL_EXIT then
    newCell.spriteIndex = 5
  end

  return setmetatable(newCell, self)
end

-- replace this with something that renders a tile animation... i'll cry

function Tile:show(x, y)
  TileSpriteSheet:showFrame(self.spriteIndex, x, y, 0, 2, 2)
end

return Tile
