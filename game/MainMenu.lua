local GameConstants = require('game/GameConstants')
local MainMenu = {}

local logoPos = {x = 0, y = 0}

function MainMenu.load()
  MainMenu.logo = love.graphics.newImage('assets/images/bonkyon_logo_final.png')
  local logoLen, logoWidth = MainMenu.logo:getDimensions()
  logoPos.x = (GameConstants.SCREEN_WIDTH - logoLen) / 2
  logoPos.y = (GameConstants.SCREEN_HEIGHT - logoWidth) / 2
end

function MainMenu.show()
  love.graphics.draw(MainMenu.logo, logoPos.x, logoPos.y)
end

return MainMenu
 
