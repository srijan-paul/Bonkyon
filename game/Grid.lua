local Tile = require("game/Tile")
local ds = require("lib/ds")
local GameConstants = require("game/GameConstants")

local Grid = {}

function Grid:new(r, c)
    newGrid = {rows = r, cols = c}
    newGrid.tiles = {}
    newGrid.entityMap = {}
    
    self.x, self.y = 0, 0
    
    for i = 1, r do
        newGrid.tiles[i] = {}
        newGrid.entityMap[i] = {}
        for j = 1, c do
            newGrid.tiles[i][j] = nil
        end
    end
    
    self.__index = self
    return setmetatable(newGrid, self)
end

function Grid:setPos(x, y)
    self.x = x
    self.y = y
end

function Grid:init()
    self._canvas = love.graphics.newCanvas(GameConstants.SCREEN_WIDTH, GameConstants.SCREEN_HEIGHT)
    
    self._canvas:renderTo(
        function()
            local xOff, yOff = 0, 0
            local x, y = self.x, self.y
            for i = 1, self.rows do
                for j = 1, self.cols do
                    self.tiles[i][j]:show(x + xOff, y + yOff)
                    xOff = xOff + GameConstants.TILE_SIZE
                end
                xOff = 0
                yOff = yOff + GameConstants.TILE_SIZE
            end
        end
)
end

function Grid:show(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self._canvas, x, y)
end

function Grid:getTilePos(r, c)
    return self.x + (GameConstants.TILE_SIZE * (c - 1)),
        self.y + (GameConstants.TILE_SIZE * (r - 1))
end

function Grid:getTileType(r, c)
    if self.tiles[r] and self.tiles[r][c] then
        return self.tiles[r][c].type
    end
end

function Grid:getTile(r, c)
    if not self.tiles[r] then return nil end
    return self.tiles[r][c]
end

function Grid:changeTileType(r, c, type)
    local tile = self:getTile(r, c)
    if tile then
        tile:setType(type)
        self:init()
    end
end

return Grid
