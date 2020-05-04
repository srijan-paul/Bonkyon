local util = require('lib/Helpers')
local Resources = require('game/Resources')
local StateManager = require('game/StateManager')
local Tile = require('game/Tile')

function love.load(arg)
    Resources.load()
    Tile.initTexture()
    love.graphics.setFont(Resources.Fonts.MenuFont)
    love.graphics.setBackgroundColor(util.hexToColor('212121'))
    StateManager:init()

    -- the hexToColor function should not be used extensively in a game's update
    -- loop for performance reasons
    -- initialize the jump sound
end

function love.draw() StateManager.drawState() end

function love.update(dt) StateManager.updateState(dt) end

function love.keypressed(key) StateManager.handleKeyPress(key) end
