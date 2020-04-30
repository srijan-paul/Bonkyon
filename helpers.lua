local ds = require("lib/ds")

local Helpers = {}

function Helpers.hexToColor(hexcode)
  local start = 0
  if hexcode:sub(1, 1) == '#' then start = 1 end
  local r = Helpers.parseHex(hexcode:sub(start + 1, start + 2)) / 255
  local g = Helpers.parseHex(hexcode:sub(start + 3, start + 4)) / 255
  local b = Helpers.parseHex(hexcode:sub(start + 5, start + 6)) / 255
  return r,g,b
end

function Helpers.parseHex(hex)
  local decimal, k = 0, 1
  local stack = ds.stack:new()

  for i = 1,#hex do
    stack:push(hex:sub(i, i))
  end

  for i = 1, #hex do
    local char = stack:pop()
    local ascii = string.byte(char)

    if (ascii >= 97 and ascii <= 102) then
      char =  10 + ascii - 97
    elseif (ascii >= 65 and ascii <= 71) then
      char = 10 + ascii - 65
    end

    decimal = decimal + k * char
    k = k * 16
  end

  return decimal
end

return Helpers
