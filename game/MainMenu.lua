local GameConstants = require('game/GameConstants')
local MainMenu = {}
local Resources = require('game/Resources')

local logoPos = {x = 0, y = 0}


function MainMenu.load()
  local logoLen, logoWidth = Resources.Image.Logo:getDimensions()
  logoPos.x = (GameConstants.SCREEN_WIDTH - logoLen) / 2
  logoPos.y = (GameConstants.SCREEN_HEIGHT - logoWidth) / 2
end


function MainMenu.show()
  love.graphics.draw(Resources.Image.Logo, logoPos.x, logoPos.y)
end


return MainMenu
