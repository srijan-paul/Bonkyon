local util = require("Helpers")
local Grid = require("Grid")
local Twin = require('Player')
local Tile = require('Tile')
local GameConstants = require('GameConstants')

local pixelFont
local gridPos = {x = 300, y = 200}


function love.load(arg)
  pixelFont = love.graphics.newFont("assets/font/font.ttf", 20)
  love.graphics.setFont(pixelFont)
  love.window.setMode(1024, 576)
  -- initialize the grid
  grid = Grid:new(4, 3, 0, 0)
  grid:setPos(300, 200)

  -- create the twins
  devilTwin = Twin:new()
  angelTwin = Twin:new()

  -- set filter so the image imports are not blurry
  love.graphics.setDefaultFilter("nearest", "nearest")

  devilTwin:init(grid, 2, 3, Twin.type.DEVIL)
  angelTwin:init(grid, 3, 3, Twin.type.ANGEL)

  grid.tiles[1][3] = Tile:new(GameConstants.Tile.BLOCK)
  grid.tiles[1][2] = Tile:new(GameConstants.Tile.BLOCK)
  grid.tiles[4][2] = Tile:new(GameConstants.Tile.DEVIL_EXIT)

  love.graphics.setBackgroundColor(util.hexToColor('4d4c7d'))

  -- the hexToColor function should not be used extensively in a game's update
  -- loop for performance reasons
end


function love.draw()
  grid:show(gridPos.x, gridPos.y)
  devilTwin:show(grid)
  angelTwin:show(grid)
end


function love.update(dt)
  devilTwin:update(dt)
  angelTwin:update(dt)
end


function love.keypressed(key)

  if key == 'a' then
    devilTwin:moveLeft(grid)
    angelTwin:moveRight(grid)
  elseif key == 'd' then
    devilTwin:moveRight(grid)
    angelTwin:moveLeft(grid)
  elseif key == 'w' then
    devilTwin:moveUp(grid)
    angelTwin:moveDown(grid)
  elseif key == 's' then
    devilTwin:moveDown(grid)
    angelTwin:moveUp(grid)
  end

  devilTwin:updatePos(grid)
  angelTwin:updatePos(grid)
end



function gameOver()
  love.graphics.print('GAME OVEER')
end
