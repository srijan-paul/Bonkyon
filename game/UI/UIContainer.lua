local UIButton = require('game/UI/UIButton')
local UIContainer = {}

function UIContainer:new(row, col)
  newUI = {rows = row, cols = col}
  self.__index = self
  self.marginX, self.marginY = 0, 0
  newUI.xPad, newUI.yPad = 0, 0
  newUI.grid = {}

  for i = 1, newUI.rows do
    newUI.grid[i] = {}
    for j = 1, newUI.cols do
      newUI.grid[i][j] = nil
    end
  end

  return setmetatable(newUI, self)
end


function UIContainer:show(x, y)
  local xOff, yOff = 0, 0
  for i = 1, self.rows do
    for j = 1, self.cols do
      local btn = self.grid[i][j]
      if btn then
        btn:show(x + xOff, y + yOff)
        xOff = xOff + btn:width() + self.xPad
      end
       -- xOff = xOff + self.xPad
    end
    xOff = 0
    if self.grid[i][1] then yOff = self.grid[i][1]:height() end
    yOff = yOff + self.yPad
  end
end


function UIContainer:update(dt)
  for i = 1, self.rows do
    for j = 1, self.cols do
      local btn = self.grid[i][j]
      if btn then btn:update(dt) end
    end
  end
end


function UIContainer:add(btn, row, col)
  local defaultRow, defaultCol = 1, 1
  local slotFound = false

  for i = 1, self.rows do
    for j = 1, self.cols do
      if slotFound then break end
      if self.grid[i][j] == nil then
        defaultRow, defaultCol = i , j
        slotFound = true
        break
      end
    end
  end

  self.grid[row or defaultRow][col or defaultCol] = btn
end


function UIContainer:setPadding(x, y)
  self.xPad = x
  self.yPad = y
end

return UIContainer
