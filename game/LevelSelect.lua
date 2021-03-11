-- This is the pinaccle of how bad a codebase can get. 
-- I really should have thought about a more clean way of
-- impkementing UIs and buttons but now I did this terriblenss
-- and there's tonnes of repeating code between the menu
-- and level select screen. This whole project
-- has been a mess with tangled , dirty and inefficient code.
-- At least it works...
local UIContainer = require("game/UI/UIContainer")
local UIButton = require("game/UI/UIButton")
local GameConstants = require("game/GameConstants")
local Resources = require("game/Resources")

local LevelSelect = {}

local State = {IDLE = 1, TRANSITION_IN = 2, TRANSITION_OUT = 3}

local MenuPosition = {x = 0, y = -GameConstants.SCREEN_HEIGHT * 1.5}
local currentState = State.TRANSITION_IN
local transitionTimerStart = 0
local oldSave = nil
local btnContainer = nil
local transitionTimerStart = 0
-- I hate to harcode this in but I also hate myself so here 
-- it goes anyway
local CONTAINER_ROWS, CONTAINER_COLS = 2, 4
local CONTAINER_POS_X, CONTAINER_POS_Y = 400, 200

local TRANSITION_IN_SPEED = 40
local TRANSITION_OUT_SPEED = 40
local levelIndex = nil

function LevelSelect.load()
	levelIndex = nil
	LevelSelect.stateManager = require("game/StateManager")
	btnContainer = UIContainer:new(2, 4)
	btnContainer:setPadding(20, 20)
	local levelBtns = {}
	local lvlCount = 1
	for i = 1, CONTAINER_ROWS do
		for j = 1, CONTAINER_COLS do
			local btn = UIButton:new(UIButton.BTN_SMALL, lvlCount)
			btn:onClick(function()
				launchLevel(((i - 1) * CONTAINER_COLS + j) - 1)
			end)
			lvlCount = lvlCount + 1
			btnContainer:add(btn)
		end
	end
	Resources.Audio.WhooshIn:play()
end

function LevelSelect.update(dt)
	btnContainer:update(dt)
	if currentState == State.TRANSITION_IN then
		MenuPosition.y = MenuPosition.y + TRANSITION_IN_SPEED
		if MenuPosition.y > 0 then
			MenuPosition.y = 0
			currentState = State.IDLE
		end
	elseif currentState == State.TRANSITION_OUT then
		if love.timer.getTime() - transitionTimerStart > 0.1 then
			MenuPosition.y = MenuPosition.y - TRANSITION_OUT_SPEED
		end
		if MenuPosition.y < -GameConstants.SCREEN_WIDTH then
			LevelSelect.stateManager.switchState(GameConstants.State.PLAYING, levelIndex)
		end
	end
end

function LevelSelect.show()
	btnContainer:show(CONTAINER_POS_X, CONTAINER_POS_Y + MenuPosition.y)
end

function launchLevel(arg)
	levelIndex = arg
	print(arg .. " is the level indexx")
	currentState = State.TRANSITION_OUT
	Resources.Audio.WhooshOut:play()
	transitionTimerStart = love.timer.getTime()
	nextState = GameConstants.State.PLAYING
end

return LevelSelect
