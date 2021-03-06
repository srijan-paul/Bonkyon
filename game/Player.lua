local AnimationPlayer = require("lib/AnimationPlayer")
local Globals = require("game/GameConstants")
local Resources = require("game/Resources")

local Player = {ANGEL = 1, DEVIL = 2}

local FLASH_DURATION = 0.2

function Player:new(type)
    newPlayer = {}
    newPlayer.type = type
    self.__index = self
    self.flashing = true
    self.lastFlashTime = 0
    self.flashMode = false
    return setmetatable(newPlayer, self)
end

function Player:init(grid, row, col)
    self.row, self.col = row, col
    self.currentPos = {x = 0, y = 0}
    self.desiredPos = {x = 0, y = 0}
    self.scale = 3

    self.moveSpeed = 10
    if self.type == Player.DEVIL then
        self.anim = AnimationPlayer:new(Resources.DevilTexture, 3, 1)
    else
        self.anim = AnimationPlayer:new(Resources.AngelTexture, 3, 1)
    end

    self.anim:add("idle", "1-2", 0.2, true)
    self.anim:add("squashed", "3-3", 1, false)

    love.graphics.setColor(1, 1, 1)
    self.anim:play("idle")
    self.spriteDir = {x = -1, y = -1}
    -- whether the Player is facing left (-1) or right(1)

    self.currentPos.x, self.currentPos.y = self:getPosOnGrid(grid)
    self.desiredPos.x, self.desiredPos.y = self:getPosOnGrid(grid)
end

function Player:show(grid, xOff, yOff)
    if self.flashing then
        love.graphics.setColor(1, 1, 0, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    if self.anim.currentAnim then
        self.anim:show(
            self.currentPos.x + (xOff or 0),
            self.currentPos.y + (yOff or 0),
            0,
            self.spriteDir.x * self.scale,
            self.scale
        )
    end
end

function Player:getPosOnGrid(grid)
    local posX, posY = grid:getTilePos(self.row, self.col)
    if self.spriteDir.x == -1 then
        posX = posX + 44
    end
    return posX + 10, posY
end

function Player:playAnim(anim)
    self.anim:play(anim)
end

function Player:update(dt)
    --
    if self.flashMode then
        local time = love.timer.getTime()
        if time - self.lastFlashTime > FLASH_DURATION then
            self.lastFlashTime = time
            self.flashing = not self.flashing
        end
    else
        self.flashing = false
    end

    if self.currentPos.x > self.desiredPos.x then
        -- if Player moved past the desired spot
        if self.spriteDir.x == 1 then
            self.currentPos.x = self.desiredPos.x
        else
            self.currentPos.x = self.currentPos.x - self.moveSpeed
            self:playAnim("squashed")
        end
    elseif self.currentPos.x < self.desiredPos.x then
        if self.spriteDir.x == -1 then
            self.currentPos.x = self.desiredPos.x
        else
            self.currentPos.x = self.currentPos.x + self.moveSpeed
            self:playAnim("squashed")
        end
    end

    if self.currentPos.y > self.desiredPos.y then
        if self.spriteDir.y == 1 then
            self.currentPos.y = self.desiredPos.y
        else
            self.currentPos.y = self.currentPos.y - self.moveSpeed
            self:playAnim("squashed")
        end
    elseif self.currentPos.y < self.desiredPos.y then
        if self.spriteDir.y == -1 then
            self.currentPos.y = self.desiredPos.y
        else
            self.currentPos.y = self.currentPos.y + self.moveSpeed
            love.graphics.print("logging")
            self:playAnim("squashed")
        end
    end

    if self.currentPos.x == self.desiredPos.x and self.desiredPos.y == self.desiredPos.y then
        self:playAnim("idle")
    end

    self.anim:update(dt)
end

function Player:isMoving()
    return (self.currentPos.x ~= self.desiredPos.x or self.currentPos.y ~= self.desiredPos.y)
end

function Player:moveLeft(grid)
    if self.col > 1 and grid.tiles[self.row][self.col - 1].pathable then
        self.col = self.col - 1
    end
    self.spriteDir.x = -1
end

function Player:moveRight(grid)
    if self.col < grid.cols and grid.tiles[self.row][self.col + 1].pathable then
        self.col = self.col + 1
    end
    self.spriteDir.x = 1
end

function Player:moveUp(grid)
    if self.row > 1 and grid.tiles[self.row - 1][self.col].pathable then
        self.row = self.row - 1
    end
    self.spriteDir.y = -1
end

function Player:moveDown(grid)
    if self.row < grid.rows and grid.tiles[self.row + 1][self.col].pathable then
        self.row = self.row + 1
    end
    self.spriteDir.y = 1
end

function Player:updatePos(grid)
    self.desiredPos.x, self.desiredPos.y = self:getPosOnGrid(grid)
end


function Player:moveTo(grid, row, col)
    self.row, self.col = row, col
    self.currentPos.x, self.currentPos.y = self:getPosOnGrid(grid)
    self.desiredPos.x, self.desiredPos.y = self:getPosOnGrid(grid)
end


return Player
