local Resources = require('game/Resources')
local GameConstants = require('game/GameConstants')
local anim = require('lib/loveAnim/anim')

local UIButton = {BTN_LARGE = 1, BTN_SMALL = 2}
local BTN_DEFAULT_SCALE = 1.5
local BTN_ATLAS_LARGE, BTN_ATLAS_SMALL

local ButtonState = {IDLE = 1, HOVER = 2, PRESSED = 3}
local BUTTON_PRESS_HEIGHT_OFFSET = 3
local TEXT_PIXEL_OFFSET = 5

function UIButton.init()
    BTN_ATLAS_LARGE = anim.newSpriteSheet(Resources.UITexture.Button, 4, 1)
    BTN_ATLAS_SMALL = anim.newSpriteSheet(Resources.UITexture.BtnSmall, 4, 1)
end

function UIButton:new(size, txt)
    local newBtn = {text = txt}
    self.__index = self
    setmetatable(newBtn, self)
    self.scaleX, self.scaleY = BTN_DEFAULT_SCALE, BTN_DEFAULT_SCALE
    self.currentFrame = 1

    self.state = ButtonState.IDLE
    self.pressed = false

    if size == UIButton.BTN_LARGE then
        self.spriteSheet = BTN_ATLAS_LARGE
    else
        self.spriteSheet = BTN_ATLAS_SMALL
    end

    self._width = self.spriteSheet.frameWidth
    self._height = self.spriteSheet.frameHeight

    local textWidth = Resources.Fonts.MenuFont:getWidth(txt)
    local textHeight = Resources.Fonts.MenuFont:getHeight(txt) +
                           TEXT_PIXEL_OFFSET

    -- text is centered

    self.textOffsetX = (self._width * self.scaleX - textWidth) / 2
    self.textOffsetY = (self._height * self.scaleY - textHeight) / 2

    -- the text Y position shifts down when the button is pressed so I need 
    -- to store the original Y position in a variable. Let's call that
    -- textOffsetYCopy because I'm so good naming variables.

    self.textOffsetTempY = BUTTON_PRESS_HEIGHT_OFFSET + self.textOffsetY
    self.textOffsetYCopy = self.textOffsetY

    return newBtn
end

function UIButton._checkHover(btn, x, y)
    return (love.mouse.getX() >= x and love.mouse.getX() < x + btn:width() and
               love.mouse.getY() >= y and love.mouse.getY() < y + btn:height())
end

function UIButton:show(x, y)
    if UIButton._checkHover(self, x, y) then
        self.state = ButtonState.HOVER
        if love.mouse.isDown(1) then
            self.state = ButtonState.PRESSED
            self.pressed = true
        elseif self.pressed then
            if Resources.Audio.Button:isPlaying() then
                Resources.Audio.Button:stop()
            end
            Resources.Audio.Button:play()
            if self.clickHandler then self.clickHandler() end
            self.pressed = false
        end
    else
        self.state = ButtonState.IDLE
    end

    self.spriteSheet:showFrame(self.currentFrame, x, y, 0, self.scaleX, self.scaleY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.text, x + self.textOffsetX, y + self.textOffsetY)
end

function UIButton:update(dt)
    if self.state == ButtonState.HOVER then
        self.currentFrame = 2
        self.textOffsetY = self.textOffsetYCopy
    elseif self.state == ButtonState.IDLE then
        self.currentFrame = 1
        self.textOffsetY = self.textOffsetYCopy
    else
        self.currentFrame = 3
        self.textOffsetY = self.textOffsetTempY * self.scaleY
    end
end

function UIButton:onClick(func) self.clickHandler = func end

function UIButton:width() return self._width * self.scaleX end

function UIButton:height() return self._height * self.scaleY end

return UIButton
