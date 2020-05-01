local Grid = require('Grid')
local json = require('lib/luaJSON/json')
local GameConstants = require('GameConstants')
local Tile = require('Tile')

local TILE_IDS = {
  GameConstants.Tile.FLOOR, GameConstants.Tile.BLOCK
}

function loadLevel(path)
  local levelData = json.decode(readFile(path))
  return makeLevel(levelData)
end


function readFile(path)
  local file = io.open(path)
  if not file then return nil end
  local content = file:read('*a')
  file:close()
  return content
end


function makeLevel(levelData)
  local grid = Grid:new(levelData.rows + 2, levelData.cols + 2, 0, 0)
  -- fill in all the tiles of the actual level

  for i = 1, levelData.rows do
    for j = 1, levelData.cols do
      grid.tiles[i + 1][j + 1] = makeTile(levelData.map[i][j])
    end
  end
  -- fill in the first two rows with wall tiles and the last with bricks
  for j = 2, levelData.cols + 1 do
    grid.tiles[1][j] = Tile:new(GameConstants.Tile.WALL_TOP)
    grid.tiles[levelData.rows + 2][j] = Tile:new(GameConstants.Tile.BRICK_BOT)
  end

  -- fill in the first column with left bricks and the last with right facing
  -- bricks

  for i = 1 , levelData.rows + 1 do
    grid.tiles[i][1] = Tile:new(GameConstants.Tile.BRICK_LEFT)
    grid.tiles[i][levelData.cols + 2] = Tile:new(GameConstants.Tile.BRICK_RIGHT)
  end

  grid.tiles[levelData.rows + 2][1] = Tile:new()
  grid.tiles[levelData.rows + 2][levelData.cols + 2] = Tile:new()

  return grid
end


function makeTile(id)
  return Tile:new(TILE_IDS[id])
end

return loadLevel
