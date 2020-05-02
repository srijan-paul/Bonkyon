local GameConstants = require('game/GameConstants')
local MainMenu = {}
local util = require('lib/helpers')
local AnimationPlayer = require('lib/AnimationPlayer')
local Resources = require('game/Resources')

local logoPos = {x = 0, y = 0}
local angelSpritePos = {x = 0, y = 0}
local devilSpritePos = {x = 0, y = 0}
local angelAnim, devilAnim

local SPRITE_SCALE = 4

function MainMenu.load()
  local logoLen, logoWidth = Resources.Image.Logo:getDimensions()
  logoPos.x = (GameConstants.SCREEN_WIDTH - logoLen) / 2
  logoPos.y = (GameConstants.SCREEN_HEIGHT - logoWidth) / 2
  MainMenu.stateManager = require('game/StateManager')
  devilSpritePos = {x = logoPos.x + logoLen + 70, y = logoPos.y}
  angelSpritePos = {x = logoPos.x - 80, y = logoPos.y}

  devilAnim = AnimationPlayer:new(Resources.DevilTexture, 3, 1)
  angelAnim = AnimationPlayer:new(Resources.AngelTexture, 3, 1)

  devilAnim:add('idle', '1-3', 0.15, true)
  devilAnim:play('idle')
  angelAnim:add('idle', '1-3', 0.15, true)
  angelAnim:play('idle')

  love.graphics.setBackgroundColor(util.hexToColor('#2980b9'))
  love.graphics.setColor(util.hexToColor('ffacb7'))
end


function MainMenu.show()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(Resources.Image.Logo, logoPos.x, logoPos.y)
  devilAnim:show(devilSpritePos.x, devilSpritePos.y , 0
  , -SPRITE_SCALE, SPRITE_SCALE)
  angelAnim:show(angelSpritePos.x, angelSpritePos.y , 0,
   SPRITE_SCALE, SPRITE_SCALE)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Press Enter to start !', logoPos.x + 50, logoPos.y + 100)
end


function MainMenu:handleKeyPress(key)
  if key == 'return' then
    MainMenu.stateManager.switchState(GameConstants.State.PLAYING, 1)
  end
end


function MainMenu:update(dt)
  devilAnim:update(dt)
  angelAnim:update(dt)
end


return MainMenu
