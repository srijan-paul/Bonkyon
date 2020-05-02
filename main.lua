local util = require("lib/Helpers")
local Resources = require('game/Resources')
local GameConstants = require('game/GameConstants')
local Level = require('game/Level')
local StateManager = require('game/StateManager')

local level
local menu = require('game/MainMenu')

function love.load(arg)
  -- set filter so the image imports are not blurry
  Resources.load()

  love.graphics.setFont(Resources.PixelFont)
  love.window.setTitle('Bonkyon')
  love.window.setMode(GameConstants.SCREEN_WIDTH, GameConstants.SCREEN_HEIGHT)
  love.graphics.setBackgroundColor(util.hexToColor('323232'))
  StateManager:init()
  -- the hexToColor function should not be used extensively in a game's update
  -- loop for performance reasons
  -- initialize the jump sound
end


function love.draw()
  StateManager.drawState()
end


function love.update(dt)
  StateManager.updateState(dt)
end


function love.keypressed(key)
  StateManager.handleKeyPress(key)
end


function gameOver()
  love.graphics.print('GAME OVEER')
end
