local GameConstants = require('game/GameConstants')
local menu = require('game/MainMenu')
local Level = require('game/Level')
local LevelSelect = require('game/LevelSelect')
local GameEnd = require('game/GameEnd')

local StateManager = {currentState = nil, _state = GameConstants.State.MENU}

function StateManager.init()
    StateManager.currentState = menu
    StateManager.currentState:load()
end

-- I should really optimize these state thingies but 
-- I didn't add a way to switch back from game to menu
-- or level select to menu. So the load gets called
-- only ocne anyways lol

function StateManager.switchState(state, arg)
    StateManager._state = state
    if state == GameConstants.State.PLAYING then
        StateManager.currentState = Level:new(arg)
        StateManager.currentState:load()
    elseif state == GameConstants.State.LVL_SELECT then
        StateManager.currentState = LevelSelect
        StateManager.currentState:load()
    else 
        StateManager.currentState = GameEnd
        StateManager.currentState:load()
    end
end

function StateManager.handleKeyPress(key)
    StateManager.currentState:handleKeyPress(key)
end

function StateManager.updateState(dt) StateManager.currentState:update(dt) end

function StateManager.drawState() StateManager.currentState:show() end

return StateManager
