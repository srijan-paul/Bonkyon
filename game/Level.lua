local Twin = require("game/Player")
local Tile = require("game/Tile")
local GameConstants = require("game/GameConstants")
local util = require('lib/Helpers')
local loadLevel = require("game/LevelLoader")
local Resources = require("game/Resources")

-- there is a lot of dirty code in this file
-- apologies to anyone trying to understand any of this.
-- Note to self : Refactor as I go in future projects

local LevelState = {
    TRANSITION_IN = 0,
    ACTIVE = 1,
    TRANSITION_OUT = 2,
    GAME_OVER = 3,
    RESTART = 4,
}

local Level = {}
local levelYPos = -GameConstants.SCREEN_HEIGHT
local TRANSITION_SPEED = 40
local LEVEL_MIN_HEIGHT = -GameConstants.SCREEN_HEIGHT
local LEVEL_SWITCH_WAIT_TIME = 1
local gameOverRectLen = 0
local GAME_OVER_FADE_OUT_SPEED = 30


function Level:new(lv)
    local newLevel = {}
    newLevel.levelIndex = lv
    newLevel.state = LevelState.TRANSITION_IN
    self.__index = self
    return setmetatable(newLevel, self)
end


function Level:load()
    self.stateManager = require("game/StateManager")
    local path = "levels/level" .. self.levelIndex .. ".json"
    self.grid = loadLevel(path)
    self.grid:init()
    self.devilTwin = Twin:new(Twin.DEVIL)
    self.angelTwin = Twin:new(Twin.ANGEL)
    
    self.devilTwin:init(self.grid, self.grid.devilStart.row, self.grid.devilStart.col)
    self.angelTwin:init(self.grid, self.grid.angelStart.row, self.grid.angelStart.col)
    Resources.Audio.WhooshIn:play()
end


function Level:show()
    self.grid:show(0, levelYPos)
    self.devilTwin:show(grid, 0, levelYPos)
    self.angelTwin:show(grid, 0, levelYPos)
    
    if self.state == LevelState.GAME_OVER then
        love.graphics.setColor(0.172, 0.258, 0.407)
        love.graphics.rectangle('fill', 0, 0, gameOverRectLen, GameConstants.SCREEN_HEIGHT)
        gameOverRectLen = gameOverRectLen + GAME_OVER_FADE_OUT_SPEED
        if gameOverRectLen > GameConstants.SCREEN_WIDTH then
            self.state = LevelState.RESTART
            gameOverRectLen = GameConstants.SCREEN_WIDTH
            self:reset()
        end
    elseif self.state == LevelState.RESTART then
        love.graphics.setColor(0.172, 0.258, 0.407)
        love.graphics.rectangle('fill', 0, 0, gameOverRectLen, GameConstants.SCREEN_HEIGHT)
        gameOverRectLen = gameOverRectLen - GAME_OVER_FADE_OUT_SPEED   
        if gameOverRectLen < 0 then
            self.state = LevelState.ACTIVE
            gameOverRectLen = 0
            Resources.Audio.Track:play()
        end
    end
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
                self.stateManager.switchState(GameConstants.State.PLAYING, self.levelIndex + 1)
            end
        end
    elseif self.state == LevelState.GAME_OVER then
        
        end
    
    self.devilTwin:update(dt)
    self.angelTwin:update(dt)
    
    -- it would be better to make this event driven but for a small game like
    -- this it doesn't make THAT big of a difference. Even so...
    -- TODO: maket this portion of the code event driven
    if self.state == LevelState.ACTIVE then
        if self:checkGameOver() then
            self:gameOver()
        end
        if self:checkWin() then
            self:launchNextLevel()
        end
    end
end


function Level:handleKeyPress(key)
    if self.state ~= LevelState.ACTIVE then
        return
    end
    if key == "a" then
        self.devilTwin:moveRight(self.grid)
        self.angelTwin:moveLeft(self.grid)
    elseif key == "d" then
        self.devilTwin:moveLeft(self.grid)
        self.angelTwin:moveRight(self.grid)
    elseif key == "w" then
        self.devilTwin:moveDown(self.grid)
        self.angelTwin:moveUp(self.grid)
    elseif key == "s" then
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
    self.grid:changeTileType(self.angelTwin.row, self.angelTwin.col, GameConstants.Tile.ANGEL_WIN)
    self.grid:changeTileType(self.devilTwin.row, self.devilTwin.col, GameConstants.Tile.DEVIL_WIN)
    Resources.Audio.Win:play()
    self.transitionTimerStart = love.timer.getTime()
end


function Level:transitionTimerTimeout()
    if not self.transitionTimerStart then
        return false
    end
    if love.timer.getTime() - self.transitionTimerStart > LEVEL_SWITCH_WAIT_TIME then
        Resources.Audio.WhooshOut:play()
        return true
    end
    return false
end


function Level:gameOver()
    self.state = LevelState.GAME_OVER
    Resources.Audio.Track:pause()
    Resources.Audio.GameOver:play()
end


function Level:checkGameOver()
    if self:isOnWinTile(self.angelTwin) then
        if not self:isOnWinTile(self.devilTwin) then
            return true
        end
    end
    if self:isOnWinTile(self.devilTwin) then
        if not self:isOnWinTile(self.angelTwin) then
            return true
        end
    end
    if (self.grid:getTileType(self.angelTwin.row, self.angelTwin.col)
        == GameConstants.Tile.DEVIL_END) then
        return true
    end
    if (self.grid:getTileType(self.devilTwin.row, self.devilTwin.col)
        == GameConstants.Tile.ANGEL_END) then
        return true
    end
end


function Level:checkWin()
    return self:isOnWinTile(self.angelTwin) and self:isOnWinTile(self.devilTwin)
end


function Level:reset()
    self.devilTwin:moveTo(self.grid, self.grid.devilStart.row, self.grid.devilStart.col)
    self.angelTwin:moveTo(self.grid, self.grid.angelStart.row, self.grid.angelStart.col)
end

return Level
