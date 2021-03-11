local Grid = require("game/Grid")
local json = require("lib/luaJSON/json")
-- credits to rxi on github for the lua json parser.
local GameConstants = require("game/GameConstants")
local Tile = require("game/Tile")

local TILE_IDS = {
	GameConstants.Tile.FLOOR, GameConstants.Tile.BLOCK,
 GameConstants.Tile.DEVIL_END, GameConstants.Tile.ANGEL_END
}

function loadLevel(path)
	local levelData = json.decode(readFile(path))
	return {grid = makeLevel(levelData), text = levelData.text}
end

function readFile(path)
	local file = io.open(path)
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

function makeLevel(levelData)
	local grid = Grid:new(levelData.rows + 2, levelData.cols + 2, 0, 0)
	-- fill in all the tiles of the actual level

	for i = 1, levelData.rows do
		for j = 1, levelData.cols do
			grid.tiles[i + 1][j + 1] = makeTile(levelData.map[i][j])
		end
	end
	-- fill in the first two rows with wall tiles and the last with bricks
	for j = 2, levelData.cols + 1 do
		grid.tiles[1][j] = Tile:new(GameConstants.Tile.WALL_TOP)
		grid.tiles[levelData.rows + 2][j] = Tile:new(GameConstants.Tile.BRICK_BOT)
	end

	-- fill in the first column with left bricks and the last with right facing
	-- bricks

	for i = 1, levelData.rows + 1 do
		grid.tiles[i][1] = Tile:new(GameConstants.Tile.BRICK_LEFT)
		grid.tiles[i][levelData.cols + 2] = Tile:new(GameConstants.Tile.BRICK_RIGHT)
	end

	-- fill the 2 bottom corners with empty tiles
	grid.tiles[levelData.rows + 2][1] = Tile:new()
	grid.tiles[levelData.rows + 2][levelData.cols + 2] = Tile:new()

	if levelData.devilStart then
		grid.devilStart = {
			row = levelData.devilStart[1] + 1,
			col = levelData.devilStart[2] + 1
		}
	end
	grid.angelStart = {
		row = levelData.angelStart[1] + 1,
		col = levelData.angelStart[2] + 1
	}

	-- centering the grid on the screen
	local gridHeight = GameConstants.TILE_SIZE * levelData.rows
	local gridLen = GameConstants.TILE_SIZE * levelData.cols

	-- I have no clue why this works the way it odoes and I'm too sleepy to want to find out how
	-- so I'll just leave it as is and never look back.

	grid:setPos(((GameConstants.SCREEN_WIDTH - gridLen - GameConstants.TILE_SIZE *
            			2) / 2), ((GameConstants.SCREEN_HEIGHT - gridHeight -
			GameConstants.TILE_SIZE) / 2))

	return grid
end

function makeTile(id)
	return Tile:new(TILE_IDS[id])
end

return loadLevel
