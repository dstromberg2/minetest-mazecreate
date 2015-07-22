-- Maze Generator
-- @dstromberg2

mazegen = {
	size = {x = 0, z = 0},
	total_cells = 0,
	cells = {},
	path = {},
	path_length = 0,
	unvisited = {}
}

function mazegen:setSize(x, z)
	self.size.x = x
	self.size.z = z
	self.total_cells = x * z

	for i = 1, x, 1 do
		self.cells[i] = {}
		self.unvisited[i] = {}
		for j = 1, z, 1 do
			self.cells[i][j] = {top = 0, bottom = 0, left = 0, right = 0}
			self.unvisited[i][j] = true
		end
	end	
end

function mazegen:findNeighbors(pos)
	local potential = {
		{pos[1] - 1, pos[2], 'top', 'bottom'},
		{pos[1], pos[2] + 1, 'right', 'left'},
		{pos[1] + 1, pos[2], 'bottom', 'top'},
		{pos[1], pos[2] - 1, 'left', 'right'}
	}
	local neighbors = {}
	local count = 0

	for l = 1, 4, 1 do
		if potential[l][1] > 0 and potential[l][1] < self.y + 1 
			and potential[l][2] > 0 and potential[l][2] < self.x + 1 
			and self.unvisited[potential[l][1]][potential[l][2]] == true then
				table.insert(neighbors, potential[l])
				count = count + 1
		end
	end

	return neighbors, count
end

function mazegen:generate(x, z)
	self:setSize(x, z)

	local current_cell = {1, 1}

	table.insert(self.path, current_cell)
	self.unvisited[current_cell[1]][current_cell[2]] = false
	
	local visited = 1
	while visited < self.total_cells do

		local neighbors, count = self:findNeighbors(current_cell)

		if count > 0 then
			local next = neighbors[math.random(count)]
			
			self.cells[current_cell[1]][current_cell[2]][next[3]] = 1
			self.cells[next[1]][next[2]][next[4]] = 1

			self.unvisited[next[1]][next[2]] = false
			visited = visited + 1
			current_cell = {next[1], next[2]}
			table.insert(self.path, current_cell)
			self.path_length = self.path_length + 1
		else
			current_cell = table.remove(self.path, self.path_length)
			self.path_length = self.path_length - 1
		end
	end

	return self.cells
end
