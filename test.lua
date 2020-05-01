local util = require("Helpers")
local ds = require("../lib/ds")
local json = require('lib/luaJSON/json')

local stack = ds.stack:new()
stack:push(2)

local arr = {1, 2, 3, 5}

function readFile(path)
  local file = io.open(path)
  if not file then return nil end
  local content = file:read('*a')
  file:close()
  return content
end

local lvl = json.decode(readFile('levels/level1.json'))

local r,g,b = util.hexToColor('120136')
print(lvl.map[1][2])
