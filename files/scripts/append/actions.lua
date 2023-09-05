-- dofile("data/scripts/gun/gun_actions.lua")
-- dofile("data/scripts/gun/gun.lua")

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
	}
}

for k, v in ipairs(new_actions) do
	table.insert(actions, v)
end
