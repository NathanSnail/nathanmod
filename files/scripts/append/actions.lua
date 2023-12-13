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
	local old_draw = dont_draw_actions
	for i = 1, tot_mul - 1 do
		dont_draw_actions = true
		target.action(recursion_level, iteration)
	end
	dont_draw_actions = old_draw
	current_reload_time = old_recharge
	c.fire_rate_wait = old_cast
	target.action(recursion_level, iteration)
end

local function copy(v)
	if type(v) == "table" then
		local new = {}
		for k, v in pairs(v) do
			new[k] = copy(v)
		end
		return new
	end
	return v
end

nathanmod_copyed_cast_state = {}

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
	{
		id                = "NATHANMOD_ADD_TRIGGER",
		name              = "$nathanmod_action_add_trigger",
		description       = "$nathanmod_actiondesc_add_trigger",
		sprite            = "mods/nathanmod/files/sprites/spells/bounce_evil.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 45,
		action            = function()
			local old_proj_spawn = add_projectile
			local old_trigger_spawn = add_projectile_trigger_hit_world
			local old_timer_spawn = add_projectile_trigger_timer
			local old_death_spawn = add_projectile_trigger_death
			local function do_trigger(file)
				add_projectile = old_proj_spawn
				add_projectile_trigger_hit_world = old_trigger_spawn
				add_projectile_trigger_timer = old_timer_spawn
				add_projectile_trigger_death = old_death_spawn
				BeginProjectile(file)
				BeginTriggerHitWorld()
				draw_shot(create_shot(1), true)
				EndTrigger()
				EndProjectile()
			end
			add_projectile = do_trigger
			add_projectile_trigger_hit_world = do_trigger
			add_projectile_trigger_timer = do_trigger
			add_projectile_trigger_death = do_trigger
			draw_actions(1, true)
			add_projectile = old_proj_spawn
			add_projectile_trigger_hit_world = old_trigger_spawn
			add_projectile_trigger_timer = old_timer_spawn
			add_projectile_trigger_death = old_death_spawn
		end
	},
	{
		id                = "NATHANMOD_SPARK_TRIGGER_TIMER",
		name              = "$nathanmod_action_spark_trigger_timer",
		description       = "$nathanmod_actiondesc_spark_trigger_timer",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 45,
		action            = function()
			if reflecting then
				Reflection_RegisterProjectile("data/entities/projectiles/deck/light_bullet.xml")
				return
			end
			BeginProjectile("data/entities/projectiles/deck/light_bullet.xml")
			BeginTriggerHitWorld()
			draw_shot(create_shot(1), true)
			EndTrigger()
			BeginTriggerTimer(10)
			draw_shot(create_shot(1), true)
			EndTrigger()
			EndProjectile()
		end
	},
	{
		id                = "NATHANMOD_SPARK_TRIGGER_DOUBLE",
		name              = "$nathanmod_action_spark_trigger_double",
		description       = "$nathanmod_actiondesc_spark_trigger_double",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 45,
		action            = function()
			if reflecting then
				Reflection_RegisterProjectile("data/entities/projectiles/deck/light_bullet.xml")
				return
			end
			BeginProjectile("data/entities/projectiles/deck/light_bullet.xml")
			BeginTriggerHitWorld()
			draw_shot(create_shot(1), true)
			EndTrigger()
			BeginTriggerHitWorld()
			draw_shot(create_shot(1), true)
			EndTrigger()
			EndProjectile()
		end
	},
	{
		id                = "NATHANMOD_COPY_CAST_STATE",
		name              = "$nathanmod_action_copy_cast_state",
		description       = "$nathanmod_actiondesc_spark_trigger_double",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 45,
		action            = function()
			if reflecting then
				return
			end
			nathanmod_copyed_cast_state = copy(c)
		end
	},
	{
		id                = "NATHANMOD_PASTE_CAST_STATE",
		name              = "$nathanmod_action_paste_cast_state",
		description       = "$nathanmod_actiondesc_spark_trigger_double",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 45,
		action            = function()
			if reflecting then
				return
			end
			for k, v in pairs(nathanmod_copyed_cast_state or {}) do
				c[k] = v
			end
		end
	},
	{
		id                = "NATHANMOD_WRAP_HALF",
		name              = "$nathanmod_action_wrap_half",
		description       = "$nathanmod_actiondesc_wrap_half",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 0,
		action            = function()
			if reflecting or force_stop_draws then
				return
			end
			move_discarded_to_deck() -- relearn all the wand mechanics
		end
	},
	{
		id                = "NATHANMOD_INFERNO_SHOT",
		name              = "$nathanmod_action_inferno_shot",
		description       = "$nathanmod_actiondesc_inferno_shot",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 15,
		action            = function()
			c.damage_fire_add = c.damage_fire_add + 0.3
			c.fire_rate_wait = c.fire_rate_wait + 6
			current_reload_time = current_reload_time - 6
			c.lifetime_add = c.lifetime_add - 13
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_AIR_TRIGGER",
		name              = "$nathanmod_action_air_trigger",
		description       = "$nathanmod_actiondesc_air_trigger",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_DRAW_MANY,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 20,
		action            = function()
			if reflecting then return end
			draw_shot(create_shot(1), true)
		end
	},
	{
		id                = "NATHANMOD_FORMATION_NONE",
		name              = "$nathanmod_action_formation_none",
		description       = "$nathanmod_actiondesc_formation_none",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 0,
		action            = function()
			c.pattern_degrees = 0
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_NO_HARM",
		name              = "$nathanmod_action_no_harm",
		description       = "$nathanmod_actiondesc_no_harm",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 5,
		action            = function()
			local old_dmgs = {
				c.damage_melee_add,
				c.damage_projectile_add,
				c.damage_electricity_add,
				c.damage_fire_add,
				c.damage_explosion_add,
				c.damage_ice_add,
				c.damage_slice_add,
				c.damage_healing_add,
				c.damage_curse_add,
				c.damage_drill_add,
			}
			draw_actions(1, true)
			c.damage_melee_add = old_dmgs[1]
			c.damage_projectile_add = old_dmgs[2]
			c.damage_electricity_add = old_dmgs[3]
			c.damage_fire_add = old_dmgs[4]
			c.damage_explosion_add = old_dmgs[5]
			c.damage_ice_add = old_dmgs[6]
			c.damage_slice_add = old_dmgs[7]
			c.damage_healing_add = old_dmgs[8]
			c.damage_curse_add = old_dmgs[9]
			c.damage_drill_add = old_dmgs[10]
		end
	},
	{
		id                = "NATHANMOD_DO_NOTHING",
		name              = "$nathanmod_action_do_nothing",
		description       = "$nathanmod_actiondesc_do_nothing",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_DRAW_MANY,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 10,
		mana              = 0,
		action            = function()
			draw_actions(1, true)
		end
	},
	{
		id                = "NATHANMOD_BLINK_SHOT",
		name              = "$nathanmod_action_blink_shot",
		description       = "$nathanmod_actiondesc_blink_shot",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 20,
		action            = function()
			c.damage_slice_add = c.damage_slice_add + 0.8
			c.fire_rate_wait = c.fire_rate_wait + 8
			current_reload_time = current_reload_time + 12
			c.speed_multiplier = math.max(math.min(c.speed_multiplier + 1.5, 20), 0) -- slightly silly
			c.lifetime_add = c.lifetime_add - 86                            -- 60 + 25 - 86 => -1
		end
	},
	{
		id                  = "NATHANMOD_BUBBLE_BUBBLE",
		name                = "$nathanmod_action_bubble_bubble",
		description         = "$nathanmod_actiondesc_bubble_bubble",
		sprite              = "data/ui_gfx/gun_actions/bubbleshot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bubbleshot_unidentified.png",
		related_projectiles = { "mods/nathanmod/files/entities/projectile/bubble_bubble.xml" },
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "2,3,4,5", -- bubble bubble
		spawn_probability   = "1,0.6,1,0.5", -- BUBBLESHOT
		price               = 100,
		mana                = 25,
		action              = function()
			add_projectile("mods/nathanmod/files/entities/projectile/bubble_bubble.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10
			c.fire_rate_wait = c.fire_rate_wait - 16
			current_reload_time = current_reload_time + 8
		end,
	},
	{
		id                = "NATHANMOD_DRAW_DISPLACER",
		name              = "$nathanmod_action_draw_displacer",
		description       = "$nathanmod_actiondesc_draw_displacer",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_DRAW_MANY,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 10,
		mana              = 0,
		action            = function()
			local data = deck[1]
			if data ~= nil then
				table.insert(discarded, data)
				table.remove(deck, 1)
			end
			draw_actions(1, true)
			local data = discarded[#discarded]
			if data ~= nil then
				table.insert(deck, 1, data)
				table.remove(discarded, #discarded)
			end
		end
	},
	{
		id                = "NATHANMOD_HAND_SHIFTER",
		name              = "$nathanmod_action_hand_shifter",
		description       = "$nathanmod_actiondesc_hand_shifter",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 10,
		mana              = 15,
		action            = function()
			if #hand >= 2 then
				local data = hand[#hand - 1]
				table.insert(discarded, data)
				table.remove(hand, #hand - 1)
			end
			for i = 1, 2 do
				if #discarded >= 1 then
					local data = discarded[1]
					table.insert(hand, data)
					table.remove(discarded, 1)
				end
			end
		end
	},
	{
		id                = "NATHANMOD_FULL_SALVO",
		name              = "$nathanmod_action_full_salvo",
		description       = "$nathanmod_actiondesc_full_salvo",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_DRAW_MANY,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 10,
		mana              = 15,
		action            = function()
			local count = 2 * (#deck + #hand + #discarded)
			for i = 1, count do
				BeginProjectile("mods/nathanmod/files/entities/projectile/empty.xml")
				BeginTriggerDeath() -- so called "nolla" when the gun system works:
				draw_shot(create_shot(1), true)
				EndTrigger()
				EndProjectile()
			end

		end
	},
	{
		id                = "NATHANMOD_PI",
		name              = "$nathanmod_action_pi",
		description       = "$nathanmod_actiondesc_pi",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 10,
		mana              = 15,
		action            = function()
			local data = deck[1]
			if data == nil then return end
			data.action()
			table.insert(discarded, data)
			table.remove(deck, 1)
		end
	},
	{
		id                = "NATHANMOD_ACI",
		name              = "$nathanmod_action_aci",
		description       = "$nathanmod_actiondesc_aci",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 10,
		mana              = 15,
		action            = function()
			playing_permanent_card = not playing_permanent_card
			draw_action(true) -- cool one which doesn't do the
			playing_permanent_card = not playing_permanent_card
		end
	},
	{
		id                = "NATHANMOD_ACIV",
		name              = "$nathanmod_action_aciv",
		description       = "$nathanmod_actiondesc_aciv",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_OTHER,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 10,
		mana              = 15,
		action            = function()
			playing_permanent_card = not playing_permanent_card
			for i = 1, 4 do
				draw_action(true) -- cool one which doesn't do the
			end
			playing_permanent_card = not playing_permanent_card
		end
	},
	-- {
	-- 	id                = "NATHANMOD_DBG",
	-- 	name              = "$nathanmod_action_dbg",
	-- 	description       = "$nathanmod_actiondesc_dbg",
	-- 	sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
	-- 	type              = ACTION_TYPE_OTHER,
	-- 	spawn_level       = "1,2,3,4",
	-- 	spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
	-- 	price             = -100,
	-- 	mana              = 0,
	-- 	action            = function()
	-- 		print(tostring(#hand))
	-- 	end
	-- },
	-- {
	-- 	id                = "NATHANMOD_SLEEP",
	-- 	name              = "$nathanmod_action_sleep",
	-- 	description       = "$nathanmod_actiondesc_sleep",
	-- 	sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
	-- 	type              = ACTION_TYPE_OTHER,
	-- 	spawn_level       = "1,2,3,4",
	-- 	spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
	-- 	price             = -100,
	-- 	mana              = 0,
	-- 	action            = function()
	-- 		cur_time = GameGetRealWorldTimeSinceStarted()
	-- 		while GameGetRealWorldTimeSinceStarted() - 10 < cur_time do
	-- 			c.pattern_degrees = 0x12345678
	-- 		end
	-- 	end
	-- },
	{
		id                = "NATHANMOD_FORMATION_ABSURD",
		name              = "$nathanmod_action_formation_absurd",
		description       = "$nathanmod_actiondesc_formation_absurd",
		sprite            = "data/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		type              = ACTION_TYPE_DRAW_MANY,
		spawn_level       = "1,2,3,4",
		spawn_probability = "0.8,0.8,0.8,0.8", -- digging detonation
		price             = 50,
		mana              = 0,
		action            = function()
			c.pattern_degrees = 178
			draw_actions(2, true)
		end
	},
	{ -- vanilla removed spell
		id          = "TELEPATHY_FIELD",
		name 		= "$action_telepathy_field",
		description = "$actiondesc_telepathy_field",
		sprite 		= "data/ui_gfx/gun_actions/telepathy_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/telepathy_field_unidentified.png",
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "", -- TELEPATHY_FIELD
		spawn_probability                 = "", -- TELEPATHY_FIELD
		price = 150,
		mana = 60,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/telepathy_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
}

for k, v in ipairs(new_actions) do
	table.insert(actions, v)
end
