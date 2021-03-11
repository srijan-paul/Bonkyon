local Resources = require("game/Resources")
local StateManager = require("game/StateManager")
local Tile = require("game/Tile")

function love.load(arg)
	Resources.load()
	Tile.initTexture()
	love.graphics.setFont(Resources.Fonts.MenuFont)
	StateManager:init()
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
