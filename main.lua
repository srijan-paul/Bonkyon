local util = require("lib/Helpers")
local Resources = require('game/Resources')
local GameConstants = require('game/GameConstants')
local Level = require('game/Level')

local pixelFont
local level
local jumpSound

local menu = require('game/MainMenu')


function love.load(arg)
  -- set filter so the image imports are not blurry
  Resources.load()
  menu.load()
  love.graphics.setFont(Resources.PixelFont)
  love.window.setTitle('Bonkyon')
  love.window.setMode(GameConstants.SCREEN_WIDTH, GameConstants.SCREEN_HEIGHT)
  love.graphics.setBackgroundColor(util.hexToColor('212121'))

  -- the hexToColor function should not be used extensively in a game's update
  -- loop for performance reasons
  -- initialize the jump sound
  level = Level:new(1)
  level:load()
  jumpSound = love.audio.newSource('assets/sounds/jump.wav', 'static')
  jumpSound:setVolume(0.3) -- 30% of ordinary volume
end


function love.draw()
  level:draw()
  -- menu.show()
end


function love.update(dt)
  level:update(dt)
end


function love.keypressed(key)
  level:handleKeyPress(key)
end



function gameOver()
  love.graphics.print('GAME OVEER')
end
