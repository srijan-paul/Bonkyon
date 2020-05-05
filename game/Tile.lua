local Sprite = require('lib/loveAnim/anim')
local GameConstants = require('game/GameConstants')
local Resources = require('game/Resources')

-- local TileType = require('TileType')
local Tile = {}

local TileSpriteSheet
local TILE_SCALE = 2

function Tile.initTexture()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    TileSpriteSheet = Sprite.newSpriteSheet(Resources.TileTexture, 14, 1)
end

function Tile:new(type)
    newCell = {type = type, pathable = true}
    self.__index = self
    setmetatable(newCell, self)
    newCell:setType(type)
    return newCell
end

function Tile:show(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    TileSpriteSheet:showFrame(self.spriteIndex, x, y, 0, TILE_SCALE, TILE_SCALE)
end


function Tile:setType(type)
    self.type = type
    
    if self.type == GameConstants.Tile.FLOOR then
        self.spriteIndex = math.random(3)
    elseif self.type == GameConstants.Tile.BLOCK then
        self.pathable = false
        self.spriteIndex = 4
    elseif newCell.type == GameConstants.Tile.WALL then
        self.pathable = false
        self.spriteIndex = 7
    elseif self.type == GameConstants.Tile.WALL_TOP then
        self.pathable = false
        self.spriteIndex = 8
    elseif self.type == GameConstants.Tile.BRICK_LEFT then
        self.pathable = false
        self.spriteIndex = 6
    elseif self.type == GameConstants.Tile.BRICK_RIGHT then
        self.pathable = false
        self.spriteIndex = 5
    elseif self.type == GameConstants.Tile.BRICK_BOT then
        self.pathable = false
        self.spriteIndex = 9
    elseif self.type == GameConstants.Tile.DEVIL_END then
        self.spriteIndex = 10
    elseif self.type == GameConstants.Tile.ANGEL_END then
        self.spriteIndex = 11
    elseif self.type == GameConstants.Tile.ANGEL_WIN then
        self.spriteIndex = 13
    elseif self.type == GameConstants.Tile.DEVIL_WIN then
        self.spriteIndex = 12
    else
        self.spriteIndex = 14
    end
end

return Tile
