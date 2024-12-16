bubble_manager = bubble_manager or GetUpdatedEntityID()
-- if the manager exists and its not us don't try manage
if GetUpdatedEntityID() ~= bubble_manager and EntityGetIsAlive(bubble_manager) then return end
bubble_manager = GetUpdatedEntityID()
local bubble_pool = EntityGetWithTag("bubble_bubble")
local groups = {}
local rad = 32
local rad_sq = rad ^ 2
local alpha = 0.8
local smooth_factor = 0.75 -- maybe change this later
-- algo overview:
-- we have the pool which is all bubbles in a group
-- 1 we get a bubble which is our target
-- 2 we add that to our queue and our group
-- 3 while our queue is not empty
-- 4 get first bubble in queue
-- 5 find all bubbles in pool it can reach, and add them to queue and group, removing from pool
-- 6 remove our starting queue value
-- 7 goto 3
-- 8 our group is done, save it
-- 9 goto 1 if pool isn't empty
-- 10 iterate over groups
-- 11 space each bubble in group
while #bubble_pool ~= 0 do
	local target = bubble_pool[1]
	table.remove(bubble_pool, 1)
	local group = { target }
	local queue = { target }
	while #queue ~= 0 do
		local elem = queue[1]
		local x, y = EntityGetTransform(elem)
		local ptr = 1
		while ptr <= #bubble_pool do
			local test = bubble_pool[ptr]
			local tx, ty = EntityGetTransform(test)
			if (tx - x) ^ 2 + (ty - y) ^ 2 < rad_sq then
				table.insert(group, test)
				table.insert(queue, test)
				table.remove(bubble_pool, ptr)
			else
				ptr = ptr + 1
			end
		end
		table.remove(queue, 1)
	end
	table.insert(groups, group)
end

for _, group in ipairs(groups) do
	local x, y = 0, 0
	for _, elem in ipairs(group) do
		local ex, ey = EntityGetTransform(elem)
		x = x + ex
		y = y + ey
	end
	x = x / #group
	y = y / #group
	local theta_part = 2 * math.pi / #group
	table.sort(group) -- performance is already dead, this is needed for smoothing to not look bad, sort by random const >> no sort
	for bubble_index, bubble in ipairs(group) do
		local theta = theta_part * bubble_index
		local e_rad = rad / (2 * (1 - math.cos(theta_part))) ^ 0.5 * alpha -- alpha is factor to shrink by, 1 is mathematically perfect but because velocity exists it doesn't work.
		if #group == 1 then
			e_rad = 0 -- hax because 1 size group is technically stable at an infinitely large range, because it always works.
		end
		local x_offset, y_offset = e_rad * math.sin(theta), e_rad * math.cos(theta)
		local new_x, new_y = x + x_offset, y + y_offset
		local ox, oy = EntityGetTransform(bubble) -- smoother
		new_x = new_x * (1 - smooth_factor) + ox * smooth_factor
		new_y = new_y * (1 - smooth_factor) + oy * smooth_factor
		EntitySetTransform(bubble, new_x, new_y)
		EntityApplyTransform(bubble, new_x, new_y)
	end
end
