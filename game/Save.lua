local TSerial = require("lib/Tserial/TSerial")
local GameSaver = {}

function GameSaver.save(state)
	local str = TSerial.pack(state)
	love.filesystem.write("savegame.txt", str)
end

function GameSaver.load()
	local oldSave = love.filesystem.getInfo("savegame.txt")
	if oldSave then
		return TSerial.unpack(love.filesystem.read("savegame.txt"))
	end
	return nil
end

return GameSaver
