local Twin = require('game/Player')
local Tile = require('game/Tile')
local GameConstants = require('game/GameConstants')
local loadLevel = require('game/LevelLoader')
local Resources = require('game/Resources')

local LevelState = {TRANSITION_IN = 0, ACTIVE = 1, TRANSITION_OUT = 2}

local Level = {}
local levelYPos = -GameConstants.SCREEN_HEIGHT
local TRANSITION_SPEED = 40
local LEVEL_MIN_HEIGHT = -GameConstants.SCREEN_HEIGHT
local LEVEL_SWITCH_WAIT_TIME = 1

function Level:new(lv)
    local newLevel = {}
    newLevel.levelIndex = lv
    newLevel.state = LevelState.TRANSITION_IN
    self.__index = self
    return setmetatable(newLevel, self)
end

function Level:load()
    self.stateManager = require('game/StateManager')
    local path = 'levels/level' .. self.levelIndex .. '.json'
    self.grid = loadLevel(path)
    self.grid:init()
    self.devilTwin = Twin:new(Twin.DEVIL)
    self.angelTwin = Twin:new(Twin.ANGEL)

    self.devilTwin:init(self.grid, self.grid.devilStart.row,
                        self.grid.devilStart.col)
    self.angelTwin:init(self.grid, self.grid.angelStart.row,
                        self.grid.angelStart.col)

    Resources.Audio.WhooshIn:play()
end

function Level:show()
    self.grid:show(0, levelYPos)
    self.devilTwin:show(grid, 0, levelYPos)
    self.angelTwin:show(grid, 0, levelYPos)
end

function Level:update(dt)
    if self.state == LevelState.TRANSITION_IN then
        levelYPos = levelYPos + TRANSITION_SPEED
        if levelYPos > 0 then
            levelYPos = 0
            self.state = LevelState.ACTIVE
        end
    elseif self.state == LevelState.TRANSITION_OUT then
        if self:transitionTimerTimeout() then
            levelYPos = levelYPos - TRANSITION_SPEED
            if levelYPos < LEVEL_MIN_HEIGHT then
                self.stateManager.switchState(GameConstants.State.PLAYING,
                                              self.levelIndex + 1)
            end
        end
    end

    self.devilTwin:update(dt)
    self.angelTwin:update(dt)

    -- it would be better to make this event driven but for a small game like
    -- this it doesn't make THAT big of a difference

    if self:isOnWinTile(self.devilTwin) and self.state == LevelState.ACTIVE then
        if self:isOnWinTile(self.angelTwin) then
            self:launchNextLevel()
        else
            self:gameOver()
        end
    elseif self:isOnWinTile(self.angelTwin) and self.state == LevelState.ACTIVE then
        self:gameOver()
    end
end

function Level:handleKeyPress(key)
    if self.state ~= LevelState.ACTIVE then return end
    if key == 'a' then
        self.devilTwin:moveRight(self.grid)
        self.angelTwin:moveLeft(self.grid)
    elseif key == 'd' then
        self.devilTwin:moveLeft(self.grid)
        self.angelTwin:moveRight(self.grid)
    elseif key == 'w' then
        self.devilTwin:moveDown(self.grid)
        self.angelTwin:moveUp(self.grid)
    elseif key == 's' then
        self.devilTwin:moveUp(self.grid)
        self.angelTwin:moveDown(self.grid)
    end
    self.devilTwin:updatePos(self.grid)
    self.angelTwin:updatePos(self.grid)
    if (self.devilTwin:isMoving() or self.angelTwin:isMoving()) then
        if Resources.Audio.Jump:isPlaying() then
            Resources.Audio.Jump:stop()
        end
        Resources.Audio.Jump:play()
    end
end

function Level:isOnWinTile(twin)
    if twin.type == Twin.DEVIL then
        return self.grid:getTileType(twin.row, twin.col) ==
                   GameConstants.Tile.DEVIL_END
    else
        return self.grid:getTileType(twin.row, twin.col) ==
                   GameConstants.Tile.ANGEL_END
    end
end

function Level:launchNextLevel()
    self.state = LevelState.TRANSITION_OUT
    Resources.Audio.Win:play()
    self.transitionTimerStart = love.timer.getTime()
end

function Level:transitionTimerTimeout()
    if not self.transitionTimerStart then return false end
    if love.timer.getTime() - self.transitionTimerStart > LEVEL_SWITCH_WAIT_TIME then
        Resources.Audio.WhooshOut:play()
        return true
    end
    return false
end

function Level:gameOver()
    Resources.Audio.Track:pause()
    Resources.Audio.GameOver:play()
end

function Level:checkGameOver()
    return (self.grid.getTileType(self.angelTwin.row, self.angelTwin.col) ==
               Tile.DEVIL_END or
               self.grid.getTileType(self.devilTwin.row, self.devilTwin.col) ==
               Tile.ANGEL_END)
end

return Level
