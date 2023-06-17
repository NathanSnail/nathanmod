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
		mana                   = 5,
		max_uses               = 3,
		action                 = function()
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.extra_entities = c.extra_entities .. "mods/nathanmod/files/entities/modifier/projectile_gravity.xml,"
			draw_actions(1,true)
		end
	}
}

for k, v in ipairs(new_actions) do
	table.insert(actions, v)
end
