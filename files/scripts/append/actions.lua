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
		id                = "NATHANMOD_BULLET", -- danger to society
		name              = "$nathanmod_action_bullet",
		description       = "$nathanmod_actiondesc_bullet",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_PROJECTILE,
		spawn_level       = "0,1,2,3,4,5,6", -- BOMB
		spawn_probability = "1,1,1,1,0.5,0.5,0.1", -- BOMB
		price             = 140,
		mana              = 30,
		max_uses          = 8,
		never_unlimited   = true,
		action            = function()
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
		id                = "NATHANMOD_MULTIPLY_2", -- danger to society
		name              = "$nathanmod_action_multiply_2",
		description       = "$nathanmod_actiondesc_multiply_2",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "6,10", -- multiply
		spawn_probability = "1,1", -- multiply
		price             = 140,
		mana              = 30,
		recursive         = true,
		action            = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(2, recursion_level, iteration)
		end
	},
	{
		id                = "NATHANMOD_MULTIPLY_3", -- danger to society
		name              = "$nathanmod_action_multiply_3",
		description       = "$nathanmod_actiondesc_multiply_3",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "6,10", -- multiply
		spawn_probability = "1,1", -- multiply
		price             = 140,
		mana              = 40,
		recursive         = true,
		action            = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(3, recursion_level, iteration)
		end
	},
	{
		id                = "NATHANMOD_MULTIPLY_4", -- danger to society
		name              = "$nathanmod_action_multiply_4",
		description       = "$nathanmod_actiondesc_multiply_4",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "6,10", -- multiply
		spawn_probability = "1,1", -- multiply
		price             = 140,
		mana              = 50,
		recursive         = true,
		action            = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(4, recursion_level, iteration)
		end
	},
	{
		id                = "NATHANMOD_MULTIPLY_10", -- danger to society
		name              = "$nathanmod_action_multiply_10",
		description       = "$nathanmod_actiondesc_multiply_10",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "6,10", -- multiply
		spawn_probability = "1,1", -- multiply
		price             = 140,
		mana              = 60,
		recursive         = true,
		action            = function(recursion_level, iteration)
			if iteration ~= nil and iteration ~= 0 then return end
			multiply_handler(10, recursion_level, iteration)
		end
	},
	{
		id                     = "NATHANMOD_HORIZONTAL_HOMING",
		name                   = "$nathanmod_action_horizontal_homing",
		description            = "$nathanmod_actiondesc_horizontal_homing",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/horizontal_homing.xml" },
		type                   = ACTION_TYPE_MODIFIER,
		spawn_level            = "1,2,3,4",
		spawn_probability      = "0.3,0.3,0.3,0.3", -- horizontal homing
		price                  = 40,
		mana                   = 5,
		action                 = function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.damage_projectile_add = c.damage_projectile_add + 0.1
			c.extra_entities = c.extra_entities .. "mods/nathanmod/files/entities/modifier/horizontal_homing.xml,"
			draw_actions(1, true)
		end
	},
	{
		id                     = "NATHANMOD_VERTICAL_HOMING",
		name                   = "$nathanmod_action_vertical_homing",
		description            = "$nathanmod_actiondesc_vertical_homing",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/vertical_homing.xml" },
		type                   = ACTION_TYPE_MODIFIER,
		spawn_level            = "1,2,3,4",
		spawn_probability      = "0.3,0.3,0.3,0.3", -- horizontal homing
		price                  = 80,
		mana                   = 60,
		action                 = function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.damage_projectile_add = c.damage_projectile_add + 0.2
			c.extra_entities = c.extra_entities .. "mods/nathanmod/files/entities/modifier/vertical_homing.xml,"
			draw_actions(1, true)
		end
	},
	{
		id                  = "NATHANMOD_CIRCLE_CASTING",
		name                = "$nathanmod_action_circle_casting",
		description         = "$nathanmod_actiondesc_circle_casting",
		sprite              = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_projectiles = "mods/nathanmod/files/entities/projectile/circle_casting.xml",
		type                = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "1,2,3,4",
		spawn_probability   = "0.3,0.3,0.3,0.3", -- horizontal homing
		price               = 40,
		mana                = 60,
		max_uses            = 30,
		action              = function()
			c.fire_rate_wait = c.fire_rate_wait + 32
			add_projectile_trigger_hit_world("mods/nathanmod/files/entities/projectile/circle_casting.xml", 1)
		end
	},
	{
		id                     = "NATHANMOD_CONVERSION_SWAPPER",
		name                   = "$nathanmod_action_conversion_swapper",
		description            = "$nathanmod_actiondesc_conversion_swapper",
		sprite                 = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		related_extra_entities = { "mods/nathanmod/files/entities/modifier/conversion_swapper.xml" },
		type                   = ACTION_TYPE_MODIFIER,
		spawn_level            = "1,2,3,4",
		spawn_probability      = "0.3,0.3,0.3,0.3", -- horizontal homing
		price                  = 40,
		mana                   = 22,
		action                 = function()
			c.extra_entities = c.extra_entities .. "mods/nathanmod/files/entities/modifier/conversion_swapper.xml,"
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_TOXIC_TRAIL",
		name              = "$nathanmod_action_toxic_trail",
		description       = "$nathanmod_actiondesc_toxic_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 10,
		action            = function()
			c.fire_rate_wait = c.fire_rate_wait - 7
			c.trail_material = c.trail_material .. "radioactive_liquid,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_ALCOHOL_TRAIL",
		name              = "$nathanmod_action_alcohol_trail",
		description       = "$nathanmod_actiondesc_alcohol_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 15,
		action            = function()
			c.trail_material = c.trail_material .. "alcohol,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_CONFUSING_TRAIL",
		name              = "$nathanmod_action_confusing_trail",
		description       = "$nathanmod_actiondesc_confusing_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 15,
		action            = function()
			c.trail_material = c.trail_material .. "material_confusion,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_PHEREMONE_TRAIL",
		name              = "$nathanmod_action_pheremone_trail",
		description       = "$nathanmod_actiondesc_pheremone_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 70,
		max_uses          = 60,
		action            = function()
			c.trail_material = c.trail_material .. "magic_liquid_charm,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_SAND_TRAIL",
		name              = "$nathanmod_action_sand_trail",
		description       = "$nathanmod_actiondesc_sand_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 15,
		action            = function()
			c.trail_material = c.trail_material .. "sand,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_LAVA_TRAIL",
		name              = "$nathanmod_action_lava_trail",
		description       = "$nathanmod_actiondesc_lava_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 25,
		action            = function()
			c.trail_material = c.trail_material .. "lava,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_FUNGUS_TRAIL",
		name              = "$nathanmod_action_fungus_trail",
		description       = "$nathanmod_actiondesc_fungus_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 25,
		action            = function()
			local r = Random(1, 10000)
			if r == 10000 then
				c.trail_material = c.trail_material .. "fungi_creeping_secret,"
			elseif r < 100 then
				c.trail_material = c.trail_material .. "fungi_yellow,"
			else
				c.trail_material = c.trail_material .. "fungi,"
			end
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_ENHANCE_TRAIL",
		name              = "$nathanmod_action_enhance_trail",
		description       = "$nathanmod_actiondesc_enhance_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 33,
		action            = function()
			c.trail_material_amount = c.trail_material_amount + (math.log(c.trail_material_amount + 1, 2) + 1) * 3
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_REMOVE_TRAIL",
		name              = "$nathanmod_action_remove_trail",
		description       = "$nathanmod_actiondesc_remove_trail",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.3,0.3,0.3,0.3", -- horizontal homing
		price             = 40,
		mana              = 20,
		action            = function()
			c.trail_material = ""
			c.trail_material_amount = 0
			draw_actions(1, true)
		end
	},
	{
		id                  = "NATHANMOD_DIGGING_DETONATION",
		name                = "$nathanmod_action_digging_detonation",
		description         = "$nathanmod_actiondesc_digging_detonation",
		sprite              = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type                = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level         = "1,2,3,4",
		spawn_probability   = "0.8,0.8,0.8,0.8", -- digging detonation
		price               = 50,
		mana                = 45,
		related_projectiles = "mods/nathanmod/files/entities/projectile/digging_detonation.xml",
		action              = function()
			c.fire_rate_wait = c.fire_rate_wait + 13
			current_reload_time = current_reload_time + 6
			add_projectile("mods/nathanmod/files/entities/projectile/digging_detonation.xml")
		end
	},
}

for k, v in ipairs(new_actions) do
	table.insert(actions, v)
end
