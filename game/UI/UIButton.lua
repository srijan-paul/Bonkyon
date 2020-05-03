local anim = require('lib/loveAnim/anim')
local Resources = require('game/Resources')

local UIButton = {}
local btnTexture
local ButtonState = {
  IDLE = 1,
  HOVER = 2,
  PRESSED = 3
}

local BUTTON_HEIGHT, BUTTON_WIDTH
local BUTTON_PRESS_HEIGHT_OFFSET = 3
local TEXT_PIXEL_OFFSET = 5

function UIButton:new(txt)
  if not btnTexture then
    btnTexture = anim.newSpriteSheet(Resources.UITexture.Button, 4, 1)
    BUTTON_HEIGHT = btnTexture.frameHeight
    BUTTON_WIDTH = btnTexture.frameWidth
  end

  newBtn = {text = txt}
  self.__index = self
  self.scaleX, self.scaleY = 1.5, 1.5
  self.currentFrame = 1

  self.state = ButtonState.IDLE
  self.preState = nil -- previous state

  local textWidth, textHeight = Resources.Fonts.MenuFont:getWidth(txt),
     Resources.Fonts.MenuFont:getHeight(txt) + TEXT_PIXEL_OFFSET

  self.textOffsetX = (BUTTON_WIDTH * self.scaleX - textWidth) / 2
  self.textOffsetY = (BUTTON_HEIGHT * self.scaleY - textHeight) / 2

  -- the text Y position shifts down when the button is pressed so I need \
  -- to store the original Y position in a variable. Let's call that
  -- textOffsetYCopy because I'm so good naming variables.

  self.textOffsetTempY = BUTTON_PRESS_HEIGHT_OFFSET + self.textOffsetY
  self.textOffsetYCopy = self.textOffsetY
  return setmetatable(newBtn, self)
end


-- checks if the mouse cursor is inside the button
function UIButton._checkHover(btn, x, y)
  return (love.mouse.getX() >= x
      and love.mouse.getX() < x + BUTTON_WIDTH * btn.scaleX
      and love.mouse.getY() >= y
      and love.mouse.getY() < y + BUTTON_HEIGHT * btn.scaleY)
end


function UIButton:show(x, y)
  if UIButton._checkHover(self, x, y) then
    self.state = ButtonState.HOVER
    if love.mouse.isDown(1) then self.state = ButtonState.PRESSED end
  else self.state = ButtonState.IDLE end

  btnTexture:showFrame(self.currentFrame, x, y, 0, self.scaleX, self.scaleY)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(self.text, x + self.textOffsetX, y + self.textOffsetY)
end


function UIButton:scale(x, y)
  self.scaleX , self.scaleY = x, y or x
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


-- this function needs some fixing
function UIButton:setTextPos(x, y)
  self.textOffsetX , self.textOffsetY = x, y
  self.textOffsetTempY = BUTTON_PRESS_HEIGHT_OFFSET + self.textOffsetY
  self.textOffsetYCopy = self.textOffsetY
end


function UIButton:onClick(func)
  self.clickHandler = func
end


function UIButton:width()
  return BUTTON_WIDTH * self.scaleX
end


function UIButton:height()
  return BUTTON_HEIGHT * self.scaleY
end


return UIButton
