local name = require "lib/loveAnim/anim"
local Resources = {}

function Resources.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Resources.TileTexture = love.graphics.newImage('assets/images/tileset_light.png')
  Resources.DevilTexture = love.graphics.newImage('assets/images/devilGuy.png')
  Resources.AngelTexture = love.graphics.newImage('assets/images/angelGuy.png')
  Resources.PixelFont = love.graphics.newFont('assets/font/font.ttf', 20)
end

return Resources
