-- Maze Generator
-- @dstromberg2

local modpath = minetest.get_modpath("mazecreate")
dofile(modpath.."/mazegen.lua")
dofile(modpath.."/mazerender.lua")
local mazegen = mazegen
local mazerender = mazerender

minetest.register_chatcommand('createmaze', {
	params = '',
	description = 'Create Maze',
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false
		end

		local mazedef = mazegen:generate(10, 10)
		mazerender:draw(mazedef, player:getpos())
	end
})

minetest.register_chatcommand('clearmaze', {
	params = '',
	description = 'Clear for testing',
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local pos = player:getpos()
		local startpos = {x = math.floor(pos.x), y = math.ceil(pos.y), z = math.floor(pos.z)}
		local forremove = minetest.find_nodes_in_area({x = startpos.x - 100, y = startpos.y - 20, z = startpos.z - 100}, {x = startpos.x + 100, y = startpos.y + 20, z = startpos.z + 100}, {"default:cobble", "default:wood"})
		for i,node in ipairs(forremove) do
			minetest.remove_node(node)
		end
	end
})
