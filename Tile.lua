local Sprite = require('lib/loveAnim/anim')

-- local TileType = require('TileType')
local Tile = {}
local TILE_WIDTH = 64
local TILE_HEIGHT = 64

local TileSpriteSheet, tileQuads = {}

function Tile.initTexture()
  TileSpriteSheet = Sprite.newSpriteSheet('assets/images/tileset_light.png',
    4, 1)
end

function Tile:new(p)
  newCell = {pathable = p}
  self.__index = self

  if newCell.pathable then
    newCell.type = math.random(3)
  else newCell.type = 4 end

  return setmetatable(newCell, self)
end

-- replace this with something that renders a tile animation... i'll cry

function Tile:show(x, y)
  TileSpriteSheet:showFrame(self.type, x, y, 0, 2, 2)
end

return Tile
