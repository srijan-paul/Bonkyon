local GameConstants = require('game/GameConstants')
local menu = require('game/MainMenu')
local Level = require('game/Level')
local LevelSelect = require('game/LevelSelect')

local StateManager = {currentState = nil, _state = GameConstants.State.MENU}

function StateManager.init()
    StateManager.currentState = menu
    StateManager.currentState:load()
end

function StateManager.switchState(state, arg)
    StateManager._state = state
    if state == GameConstants.State.PLAYING then
        StateManager.currentState = Level:new(arg)
        StateManager.currentState:load()
    elseif state == GameConstants.State.LVL_SELECT then
        StateManager.currentState = LevelSelect
        StateManager.currentState:load()
    end
end

function StateManager.handleKeyPress(key)
    StateManager.currentState:handleKeyPress(key)
end

function StateManager.updateState(dt) StateManager.currentState:update(dt) end

function StateManager.drawState() StateManager.currentState:show() end

return StateManager
