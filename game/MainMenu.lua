local GameConstants = require("game/GameConstants")
local MainMenu = {}
local util = require("lib/helpers")
local AnimationPlayer = require("lib/AnimationPlayer")
local Resources = require("game/Resources")
local UIContainer = require("game/UI/UIContainer")
local UIButton = require("game/UI/UIButton")
local SaveGame = require("game/Save")

local logoPos = {x = 0, y = 0}
local angelSpritePos = {x = 0, y = 0}
local devilSpritePos = {x = 0, y = 0}
local angelAnim, devilAnim

local SPRITE_SCALE = 4
local btnContainer

-- everything is drawn with respect to the menu position
local MenuPosition = {x = 0, y = -GameConstants.SCREEN_HEIGHT * 1.5}
local TRANSITION_IN_SPEED = 40
local TRANSITION_OUT_SPEED = 40
local MenuState = {
	IDLE = 1,
	TRANSITION_IN = 2,
	TRANSITION_OUT = 3,
	COLOR_SHIFT = 4
}

local currentState = MenuState.TRANSITION_IN
local transitionTimerStart = 0
local oldSave = nil -- an older save file
local nextState = nil

function MainMenu.load()
	-- look for saved games
	oldSave = SaveGame.load()
	if not oldSave then
		oldSave = {tutorial = false, level = 0}
		SaveGame.save(oldSave)
	end

	local logoLen, logoWidth = Resources.Image.Logo:getDimensions()
	logoPos.x = (GameConstants.SCREEN_WIDTH - logoLen) / 2
	logoPos.y = (GameConstants.SCREEN_HEIGHT - logoWidth) / 2

	MainMenu.stateManager = require("game/StateManager")

	devilSpritePos = {x = logoPos.x + logoLen + 70, y = logoPos.y}
	angelSpritePos = {x = logoPos.x - 80, y = logoPos.y}

	devilAnim = AnimationPlayer:new(Resources.DevilTexture, 3, 1)
	angelAnim = AnimationPlayer:new(Resources.AngelTexture, 3, 1)

	devilAnim:add("idle", "1-3", 0.15, true)
	devilAnim:play("idle")
	angelAnim:add("idle", "1-3", 0.15, true)
	angelAnim:play("idle")

	love.graphics.setBackgroundColor(util.hexToColor("#0582ca"))
	love.graphics.setColor(util.hexToColor("ffacb7"))

	btnContainer = UIContainer:new(3, 1)
	local playBtn = UIButton:new(UIButton.BTN_LARGE, "PLAY")
	playBtn:onClick(launchGame)
	local tutBtn = UIButton:new(UIButton.BTN_LARGE, "LEVEL SELECT")
	tutBtn:onClick(launchLevelSelect)
	btnContainer:setPadding(10, 10)
	btnContainer:add(playBtn)
	btnContainer:add(tutBtn)
	Resources.Audio.WhooshIn:play()
	Resources.Audio.Track:play()

end

function MainMenu.show()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(Resources.Image.Logo, MenuPosition.x + logoPos.x,
			MenuPosition.y + logoPos.y)

	devilAnim:show(MenuPosition.x + devilSpritePos.x,
			MenuPosition.y + devilSpritePos.y, 0, -SPRITE_SCALE, SPRITE_SCALE)

	angelAnim:show(MenuPosition.x + angelSpritePos.x,
			MenuPosition.y + angelSpritePos.y, 0, SPRITE_SCALE, SPRITE_SCALE)

	love.graphics.setColor(1, 1, 1, 1)
	btnContainer:show(MenuPosition.x + logoPos.x + 80,
			MenuPosition.y + logoPos.y + 100)
end

function MainMenu:handleKeyPress(key)

end

function MainMenu:update(dt)
	devilAnim:update(dt)
	angelAnim:update(dt)
	btnContainer:update(dt)

	if currentState == MenuState.TRANSITION_IN then
		MenuPosition.y = MenuPosition.y + TRANSITION_IN_SPEED
		if MenuPosition.y > 0 then
			MenuPosition.y = 0
			currentState = MenuState.IDLE
		end
	elseif currentState == MenuState.TRANSITION_OUT then
		if love.timer.getTime() - transitionTimerStart > 0.1 then
			MenuPosition.y = MenuPosition.y - TRANSITION_OUT_SPEED
		end
		if MenuPosition.y < -GameConstants.SCREEN_WIDTH then
			MainMenu.stateManager.switchState(nextState, oldSave.level or 0)
		end
	end

end

function launchGame()
	currentState = MenuState.TRANSITION_OUT
	Resources.Audio.WhooshOut:play()
	transitionTimerStart = love.timer.getTime()
	nextState = GameConstants.State.PLAYING
end

function launchLevelSelect()
	currentState = MenuState.TRANSITION_OUT
	Resources.Audio.WhooshOut:play()
	transitionTimerStart = love.timer.getTime()
	nextState = GameConstants.State.LVL_SELECT
end

return MainMenu
