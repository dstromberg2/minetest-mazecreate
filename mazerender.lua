-- Maze Generator
-- @dstromberg2

mazerender = {
	mazedef = {},
	size = {x = 0, z = 0},
	startpos = {},
	cellsize = 3,
	wallheight = 5,
	wallmaterial = 'default:cobble',
	floormaterial = 'default:wood'
}

function mazerender:findwalls(pos, celldef)
	local walls = {}
	local corners = {}

	if celldef.top == 0 or celldef.left == 0 then
		corners.tl = {x = pos.x - self.cellsize + 1, y = pos.y, z = pos.z - self.cellsize + 1}
	end
	if celldef.bottom == 0 or celldef.left == 0 then
		corners.bl = {x = pos.x - self.cellsize + 1, y = pos.y, z = pos.z + self.cellsize - 1}
	end
	if celldef.top == 0 or celldef.right == 0 then
		corners.tr = {x = pos.x + self.cellsize - 1, y = pos.y, z = pos.z - self.cellsize + 1}
	end
	if celldef.bottom == 0 or celldef.right == 0 then
		corners.br = {x = pos.x + self.cellsize - 1, y = pos.y, z = pos.z + self.cellsize - 1}
	end

	for i, corner in pairs(corners) do
		table.insert(walls, corner)
	end

	for i = 1, self.cellsize, 1 do
		if celldef.top == 0 then
			table.insert(walls, {x = corners.tl.x + i, y = corners.tl.y, z = corners.tl.z})
		end
		if celldef.bottom == 0 then
			table.insert(walls, {x = corners.bl.x + i, y = corners.bl.y, z = corners.bl.z})
		end
		if celldef.right == 0 then
			table.insert(walls, {x = corners.tr.x, y = corners.tr.y, z = corners.tr.z + i})
		end
		if celldef.left == 0 then
			table.insert(walls, {x = corners.tl.x, y = corners.tl.y, z = corners.tl.z + i})
		end
	end

	return walls
end

function mazerender:draw(mazedef, start_position)
	self.mazedef = mazedef
	self.startpos = {x = math.floor(start_position.x), y = math.ceil(start_position.y), z = math.floor(start_position.z)}

	for _, cell in ipairs(self.mazedef) do
		self.size.x = self.size.x + 1
	end
	for _, cell in ipairs(self.mazedef[1]) do
		self.size.z = self.size.z + 1
	end

	local cornerpos = {x = self.startpos.x - self.cellsize + 1, y = self.startpos.y - 1, z = self.startpos.z - self.cellsize + 1}
	for i = 0, (self.size.x * self.cellsize) + self.size.x do
		for j = 0, (self.size.z * self.cellsize) + self.size.z do
			minetest.add_node({x = cornerpos.x + i, y = cornerpos.y, z = cornerpos.z + j}, {name = self.floormaterial})
			for k = 1, self.wallheight do
				minetest.remove_node({x = cornerpos.x + i, y = cornerpos.y + k, z = cornerpos.z + j});
			end
		end
	end

	for i, row in ipairs(self.mazedef) do
		for j, cell in ipairs(row) do
			local pos = {x = self.startpos.x + ((j - 1) * 4), y = self.startpos.y, z = self.startpos.z + ((i - 1) * 4)}
			local walls = self:findwalls(pos, cell)

			for _, wallpos in ipairs(walls) do
				minetest.add_node(wallpos, {name=self.wallmaterial})
				for i = 1, self.wallheight - 1 do
					minetest.add_node({x = wallpos.x, y = wallpos.y + i, z = wallpos.z}, {name=self.wallmaterial})
				end
			end
		end
	end
end
