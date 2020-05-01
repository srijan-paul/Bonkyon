local Tile = require('Tile')
local ds = require('lib/ds')
local GameConstants = require('GameConstants')

local Grid = {}


function Grid:new(r, c)
  newGrid = {rows = r, cols = c}
  newGrid.tiles = {}
  newGrid.entityMap = {}

  self.x, self.y = 0, 0

  for i = 1, r do
    newGrid.tiles[i] = {}
    newGrid.entityMap[i] = {}
    for j = 1, c do
      newGrid.tiles[i][j] = nil
    end
  end

  Tile.initTexture()
  self.__index = self
  return setmetatable(newGrid, self)
end


function Grid:setPos(x, y)
  self.x = x
  self.y = y
end


function Grid:show()
  -- I need to composite the tileMap into a single canvas
  local xOff, yOff = 0, 0
  local x, y = self.x, self.y
  for i = 1, self.rows  do
    for j = 1, self.cols  do
      self.tiles[i][j]:show(x + xOff, y + yOff)
      xOff = xOff + GameConstants.TILE_SIZE
    end
    xOff = 0
    yOff = yOff + GameConstants.TILE_SIZE
  end

end


function Grid:getTilePos(r, c)
  return self.x + (GameConstants.TILE_SIZE * (c - 1)),
    self.y + (GameConstants.TILE_SIZE * (r - 1))
end


return Grid
