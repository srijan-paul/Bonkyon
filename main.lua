local util = require("lib/Helpers")
local Grid = require("game/Grid")
local Twin = require('game/Player')
local Tile = require('game/Tile')
local GameConstants = require('game/GameConstants')
local loadLevel = require('game/LevelLoader')
local Entity = require('game/Entity')

local pixelFont

local jumpSound


function love.load(arg)
  pixelFont = love.graphics.newFont("assets/font/font.ttf", 20)
  love.graphics.setFont(pixelFont)
  love.window.setTitle('Bonkyon')
  love.window.setMode(GameConstants.SCREEN_WIDTH, GameConstants.SCREEN_HEIGHT)
  -- initialize the grid
  grid = loadLevel('levels/level1.json')

  -- create the twins
  devilTwin = Twin:new()
  angelTwin = Twin:new()


  -- set filter so the image imports are not blurry
  love.graphics.setDefaultFilter("nearest", "nearest")

  devilTwin:init(grid, grid.devilStart.row, grid.devilStart.col, Twin.type.DEVIL)
  angelTwin:init(grid, grid.angelStart.row, grid.angelStart.col, Twin.type.ANGEL)

  love.graphics.setBackgroundColor(util.hexToColor('212121'))

  -- the hexToColor function should not be used extensively in a game's update
  -- loop for performance reasons
  -- initialize the jump sound
  jumpSound = love.audio.newSource('assets/sounds/jump.wav', 'static')
  jumpSound:setVolume(0.3) -- 30% of ordinary volume
end


function love.draw()
  -- TODO remove these hardcoded values
  grid:show(100, 100)
  love.graphics.setColor(0.5, 1, 0, 1)
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
  if (devilTwin:isMoving() or angelTwin:isMoving()) then
    jumpSound:play()
  end
end



function gameOver()
  love.graphics.print('GAME OVEER')
end
