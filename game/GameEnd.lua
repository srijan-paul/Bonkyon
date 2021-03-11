local GameConstants = require("game/GameConstants")
local Resources = require("game/Resources")
local Util = require("lib/helpers")
local GameEnd = {}
local msg =
		"Thanks for playing this garbage.\nIt was a small proof of concept for what this puzzler would be like to play.\nSo it isn't polished or complete.\nLet me know if you would like to see this idea expanded upon\nwith more levels and interesting elements."

local yPos, yVel = -GameConstants.SCREEN_HEIGHT * 1.5, 40

function GameEnd.load()
	yPos = -GameConstants.SCREEN_HEIGHT
	love.graphics.setBackgroundColor(Util.hexToColor("2c4268"))
	love.graphics.setFont(Resources.Fonts.PixelFont)
	Resources.Audio.WhooshIn:play()
end

function GameEnd.update(dt)
	if yPos < 0 then
		yPos = yPos + yVel
	end
end
function GameEnd.show()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(msg, 50, 100 + yPos)
	love.graphics.setColor(1, 1, 0.5, 1)
	love.graphics.print("Twitter : @inJuly16\n", 50, 400 + yPos)
end

return GameEnd
