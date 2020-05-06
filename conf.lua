local GameConstants = require('game/GameConstants')

function love.conf(t)
  t.window.width = GameConstants.SCREEN_WIDTH
  t.window.height = GameConstants.SCREEN_HEIGHT
  t.window.title = 'Bonkyon'
  t.console = true
end
