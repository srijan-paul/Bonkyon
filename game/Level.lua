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
    RESTART = 4
}

local Level = {}
local levelYPos = -GameConstants.SCREEN_HEIGHT
local TRANSITION_SPEED = 40
local LEVEL_MIN_HEIGHT = -GameConstants.SCREEN_HEIGHT
local LEVEL_SWITCH_WAIT_TIME = 1
local gameOverRectLen = 0
local GAME_OVER_FADE_OUT_SPEED = 30
local TEXT_POS_X, TEXT_POS_Y = 10, 10
local TEXT_RECT_HEIGHT, TEXT_RECT_WIDTH = 100, GameConstants.SCREEN_WIDTH

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
    local levelData = loadLevel(path)
    self.grid = levelData.grid
    self.text = levelData.text -- tutorial text to explain how the game works
    self.grid:init()

    self.angelTwin = Twin:new(Twin.ANGEL)
    self.angelTwin:init(self.grid, self.grid.angelStart.row,
                        self.grid.angelStart.col)

    if self.grid.devilStart then
        self.devilTwin = Twin:new(Twin.DEVIL)
        self.devilTwin:init(self.grid, self.grid.devilStart.row,
                            self.grid.devilStart.col)
    end
    if self.text then love.graphics.setFont(Resources.Fonts.PixelFont) end
    Resources.Audio.WhooshIn:play()
end

function Level:show()
    self.grid:show(0, levelYPos)
    -- this is where I start hating myself for writing this garbage code.
   
    if self.devilTwin then self.devilTwin:show(grid, 0, levelYPos) end
    self.angelTwin:show(grid, 0, levelYPos)

    if self.text then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, levelYPos, TEXT_RECT_WIDTH, TEXT_RECT_HEIGHT)
        love.graphics.setColor(1.0, 0.878, 0.4, 1)
        love.graphics.print(self.text, TEXT_POS_X, TEXT_POS_Y + levelYPos)
    end

    if self.state == LevelState.GAME_OVER then
        love.graphics.setColor(0.172, 0.258, 0.407)
        love.graphics.rectangle('fill', 0, 0, gameOverRectLen,
                                GameConstants.SCREEN_HEIGHT)
        gameOverRectLen = gameOverRectLen + GAME_OVER_FADE_OUT_SPEED
        if gameOverRectLen > GameConstants.SCREEN_WIDTH then
            self.state = LevelState.RESTART
            gameOverRectLen = GameConstants.SCREEN_WIDTH
            self:reset()
        end
    elseif self.state == LevelState.RESTART then
        love.graphics.setColor(0.172, 0.258, 0.407)
        love.graphics.rectangle('fill', 0, 0, gameOverRectLen,
                                GameConstants.SCREEN_HEIGHT)
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
                self.stateManager.switchState(GameConstants.State.PLAYING,
                                              self.levelIndex + 1)
            end
        end
    end

    if self.devilTwin then self.devilTwin:update(dt) end
    self.angelTwin:update(dt)

    -- it would be better to make this event driven but for a small game like
    -- this it doesn't make THAT big of a difference. Even so...
    -- TODO: maket this portion of the code event driven
    if self.state == LevelState.ACTIVE then
        if self:checkGameOver() then self:gameOver() end
        if self:checkWin() then self:launchNextLevel() end
    end
end

function Level:handleKeyPress(key)
    if self.state ~= LevelState.ACTIVE then return end
    if not (key == 'a' or key == 'd'or key =='w' or key =='s') then return end
    moveTwin(self.angelTwin, key, self.grid)
    moveTwin(self.devilTwin, key, self.grid)

    if ((not self.devilTwin or self.devilTwin:isMoving()) or
        self.angelTwin:isMoving()) then
        if Resources.Audio.Jump:isPlaying() then
            Resources.Audio.Jump:stop()
        end
        Resources.Audio.Jump:play()
    end
end

function Level:isOnWinTile(twin)
    if not twin then return true end
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
    self.grid:changeTileType(self.angelTwin.row, self.angelTwin.col,
                             GameConstants.Tile.ANGEL_WIN)

    if not self.devilTwin then return end
    self.grid:changeTileType(self.devilTwin.row, self.devilTwin.col,
                             GameConstants.Tile.DEVIL_WIN)
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
    self.state = LevelState.GAME_OVER
    Resources.Audio.Track:pause()
    Resources.Audio.GameOver:play()
end

function Level:checkGameOver()
    if self:isOnWinTile(self.angelTwin) then
        if not self:isOnWinTile(self.devilTwin) then return true end
    end

    if (self.grid:getTileType(self.angelTwin.row, self.angelTwin.col) ==
        GameConstants.Tile.DEVIL_END) then return true end

    if not self.devilTwin then return false end
    if self:isOnWinTile(self.devilTwin) then
        if not self:isOnWinTile(self.angelTwin) then return true end
    end
    if (self.grid:getTileType(self.devilTwin.row, self.devilTwin.col) ==
        GameConstants.Tile.ANGEL_END) then return true end

end

function Level:checkWin()
    return self:isOnWinTile(self.angelTwin) and self:isOnWinTile(self.devilTwin)
end

function Level:reset()

    if self.devilTwin then
        self.devilTwin:moveTo(self.grid, self.grid.devilStart.row,
                              self.grid.devilStart.col)
    end
    self.angelTwin:moveTo(self.grid, self.grid.angelStart.row,
                          self.grid.angelStart.col)
end

function moveTwin(twin, key, grid)
    if not twin then return end
    if twin.type == Twin.DEVIL then
        if key == 'w' then twin:moveDown(grid) end
        if key == 's' then twin:moveUp(grid) end
        if key == 'a' then twin:moveRight(grid) end
        if key == 'd' then twin:moveLeft(grid) end
    else
        if key == 's' then twin:moveDown(grid) end
        if key == 'w' then twin:moveUp(grid) end
        if key == 'd' then twin:moveRight(grid) end
        if key == 'a' then twin:moveLeft(grid) end
    end
    twin:updatePos(grid)
end

return Level
