-- this module contains a bunch of common use data structures
-- (just 2D arrays and stacks for now)

local ds = {}

local Array2D = {}

function Array2D:new(rows, cols)
  newArr = {}
  for i = 1, rows do
    newArr[i] = {}
    for j = 1, cols do
      newArr[i][j] = 0
    end
  end
  return newArr
end

local stack = {}

function stack:new()
  newStack = {_values = {}}
  self.__index = self
  return setmetatable(newStack, stack)
end

function stack:push(...)
  local args = {...}
  for _, value in ipairs(args) do
    table.insert(self._values, value)
  end
end

function stack:pop()
  if #self._values > 0 then
    return table.remove(self._values)
  else
    return nil
  end
end

ds.arr2d = Array2D
ds.stack = stack

return ds
