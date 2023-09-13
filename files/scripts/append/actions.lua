-- dofile("data/scripts/gun/gun_actions.lua")
-- dofile("data/scripts/gun/gun.lua")
local map_mul = {
	["NATHANMOD_MULTIPLY_10"] = 10,
	["NATHANMOD_MULTIPLY_4"]  = 4,
	["NATHANMOD_MULTIPLY_3"]  = 3,
	["NATHANMOD_MULTIPLY_2"]  = 2,
}
local map_max = {
	[10] = 2,
	[4] = 3,
	[3] = 3,
	[2] = 4,
}

local function multiply_handler(base, recursion_level, iteration)
	local old_recharge = current_reload_time
	local old_cast = c.fire_rate_wait
	local target
	local tot_mul = base
	local off = 1
	while off <= #deck do
		local data = deck[off]
		local num = map_mul[data.id]
		if num == nil then
			target = data
			break
		end
		if off < map_max[num] then
			tot_mul = tot_mul * num
		end
		off = off + 1
	end
	c.pattern_degrees = (tot_mul ^ 0.3) * 4
	if target == nil then return end
	for i = 1, off do
		local mv = deck[1]
		table.insert(hand, mv)
		table.remove(deck, 1)
	end
	for i = 1, tot_mul - 1 do
		dont_draw_actions = true
		target.action(recursion_level, iteration)
	end
	dont_draw_actions = false
	current_reload_time = old_recharge
	c.fire_rate_wait = old_cast
	target.action(recursion_level, iteration)
end

local new_actions = {
	{
		id                     = "NATHANMOD_PROJECTILE_GRAVITY",
		name                   = "$nathanmod_action_projectile_gravity",
		description            = "$nathanmod_actiondesc_projectile_gravity",
		sprite                 = "mods/nathanmod/files/sprites/spells/projectile_gravity.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/projectile_gravity.xml" },
		type                   = ACTION_TYPE_MODIFIER,
		spawn_level            = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability      = "1,1,1,1,0.5,0.5,0.1", -- BOMB
		price                  = 70,
		mana                   = 35,
		action                 = function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.extra_entities = c.extra_entities .. "mods/nathanmod/files/entities/modifier/projectile_gravity.xml,"
			draw_actions(1, true)
		end
	},
	{
		id                     = "NATHANMOD_BOUNCE_EVIL",
		name                   = "$nathanmod_action_bounce_evil",
		description            = "$nathanmod_actiondesc_bounce_evil",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/bounce_evil.xml" },
		type                   = ACTION_TYPE_MODIFIER,
		spawn_level            = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability      = "1,1,1,1,0.5,0.5,0.1", -- BOMB
		price                  = 140,
		mana                   = -25,             -- still worse than add mana
		action                 = function()
			c.fire_rate_wait = c.fire_rate_wait - 5
			current_reload_time = current_reload_time - 7
			c.bounces = c.bounces + 1
			c.extra_entities = c.extra_entities .. "mods/nathanmod/files/entities/modifier/bounce_evil.xml,"
			draw_actions(1, true)
		end
	},
	{
		id                     = "NATHANMOD_BULLET", -- danger to society
		name                   = "$nathanmod_action_bullet",
		description            = "$nathanmod_actiondesc_bullet",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/bounce_evil.xml" },
		type                   = ACTION_TYPE_PROJECTILE,
		spawn_level            = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability      = "1,1,1,1,0.5,0.5,0.1", -- BOMB
		price                  = 140,
		mana                   = 30,
		max_uses               = 8,
		never_unlimited        = true,
		action                 = function()
			add_projectile("data/entities/projectiles/machinegun_bullet_slower.xml")
			if (#hand == 0) or reflecting then return end
			if #deck == 0 then
				deck[1] = hand[#hand] -- i have not seen a worse programming language
			else
				table.insert(deck, 1, hand[#hand])
			end
			table.remove(hand, #hand)
			if deck[1].uses_remaining ~= nil then
				deck[1].uses_remaining = deck[1].uses_remaining - 1
			end
		end
	},
	{
		id                     = "NATHANMOD_MULTIPLY_2", -- danger to society
		name                   = "$nathanmod_action_multiply_2",
		description            = "$nathanmod_actiondesc_multiply_2",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/bounce_evil.xml" },
		type                   = ACTION_TYPE_OTHER,
		spawn_level            = "6,10", -- multiply
		spawn_probability      = "1,1", -- multiply
		price                  = 140,
		mana                   = 30,
		recursive              = true,
		action                 = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(2, recursion_level, iteration)
		end
	},
	{
		id                     = "NATHANMOD_MULTIPLY_3", -- danger to society
		name                   = "$nathanmod_action_multiply_3",
		description            = "$nathanmod_actiondesc_multiply_3",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/bounce_evil.xml" },
		type                   = ACTION_TYPE_OTHER,
		spawn_level            = "6,10", -- multiply
		spawn_probability      = "1,1", -- multiply
		price                  = 140,
		mana                   = 40,
		recursive              = true,
		action                 = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(3, recursion_level, iteration)
		end
	},
	{
		id                     = "NATHANMOD_MULTIPLY_4", -- danger to society
		name                   = "$nathanmod_action_multiply_4",
		description            = "$nathanmod_actiondesc_multiply_4",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/bounce_evil.xml" },
		type                   = ACTION_TYPE_OTHER,
		spawn_level            = "6,10", -- multiply
		spawn_probability      = "1,1", -- multiply
		price                  = 140,
		mana                   = 50,
		recursive              = true,
		action                 = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(4, recursion_level, iteration)
		end
	},
	{
		id                     = "NATHANMOD_MULTIPLY_10", -- danger to society
		name                   = "$nathanmod_action_multiply_10",
		description            = "$nathanmod_actiondesc_multiply_10",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/bounce_evil.xml" },
		type                   = ACTION_TYPE_OTHER,
		spawn_level            = "6,10", -- multiply
		spawn_probability      = "1,1", -- multiply
		price                  = 140,
		mana                   = 60,
		recursive              = true,
		action                 = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(10, recursion_level, iteration)
		end
	},
}

for k, v in ipairs(new_actions) do
	table.insert(actions, v)
end
