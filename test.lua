local util = require("lib/helpers")
-- local ds = require("../lib/ds")
-- local json = require('lib/luaJSON/json')
--
-- local stack = ds.stack:new()
-- stack:push(2)
--
-- local arr = {1, 2, 3, 5}
--
-- function readFile(path)
--   local file = io.open(path)
--   if not file then return nil end
--   local content = file:read('*a')
--   file:close()
--   return content
-- end
--
-- local lvl = json.decode(readFile('levels/level1.json'))
--
local r,g,b = util.hexToColor('6886c5')
print(r ..', ' .. g ..', '.. b)

grd = {
  {}, {}, {}
}

local x = false
for i = 1, 3 do
    if x then break end
  for j = 1, 1 do
    if grd[i][j] == nil then
      print(i, j)
      x = true break
    end
  end
end
