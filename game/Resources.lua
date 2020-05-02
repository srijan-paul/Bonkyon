local name = require "lib/loveAnim/anim"
local Resources = {
  Audio = {},
  Image = {}
}


function Resources.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Resources.TileTexture = love.graphics.newImage('assets/images/tileset_light.png')
  Resources.DevilTexture = love.graphics.newImage('assets/images/devilGuy.png')
  Resources.AngelTexture = love.graphics.newImage('assets/images/angelGuy.png')
  Resources.PixelFont = love.graphics.newFont('assets/font/font.ttf', 20)
  Resources.Audio.Jump = love.audio.newSource('assets/sounds/jump.wav', 'static')
  Resources.Audio.Jump:setVolume(0.3)
  Resources.Image.Logo = love.graphics.newImage('assets/images/bonkyon_logo_final.png')
end


return Resources
