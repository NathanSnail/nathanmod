-- dofile("data/scripts/perks/perk.lua")

local new_perks = {
	{ --TODO: Sprite
		id = "NATHANMOD_MINI_MINA",
		ui_name = "$nathanmod_perk_mini_mina",
		ui_description = "$nathanmod_perkdesc_mini_mina",
		ui_icon = "data/ui_gfx/perk_icons/gold_is_forever.png",
		perk_icon = "data/items_gfx/perks/gold_is_forever.png",
		stackable = true,
		stackable_maximum = 5, -- we really should stop before this but it looks really funny when mina is microscopic
		usable_by_enemies = true,
		func = function(_, entity_who_picked, _)
			local sprites = EntityGetComponent(entity_who_picked, "SpriteComponent")
			if sprites ~= nil and #sprites >= 1 then
				for _, sprite in ipairs(sprites) do
					-- ComponentSetValue2(v, "has_special_scale", true) breaks turning
					ComponentSetValue2(sprite, "special_scale_x", ComponentGetValue2(sprite, "special_scale_x") * 0.75)
					ComponentSetValue2(sprite, "special_scale_y", ComponentGetValue2(sprite, "special_scale_y") * 0.75)
				end
			end
			local hitboxs = EntityGetComponent(entity_who_picked, "HitboxComponent")
			if hitboxs ~= nil and #hitboxs >= 1 then
				for _, hitbox in ipairs(hitboxs) do
					for _, key in ipairs({ "aabb_min_x", "aabb_max_x", "aabb_min_y", "aabb_max_y" }) do
						ComponentSetValue2(hitbox, key, ComponentGetValue2(hitbox, key) * 0.75)
					end
				end
			end
			local char_datas = EntityGetComponent(entity_who_picked, "CharacterDataComponent")
			if char_datas ~= nil and #char_datas >= 1 then
				for _, char_data in ipairs(char_datas) do
					ComponentSetValue2(
						char_data,
						"collision_aabb_min_x",
						ComponentGetValue2(char_data, "collision_aabb_min_x") * 0.75
					)
					ComponentSetValue2(
						char_data,
						"collision_aabb_min_y",
						ComponentGetValue2(char_data, "collision_aabb_min_y") * 0.75
					)
					ComponentSetValue2(
						char_data,
						"collision_aabb_max_x",
						ComponentGetValue2(char_data, "collision_aabb_max_x") * 0.75
					)
					ComponentSetValue2(
						char_data,
						"collision_aabb_max_y",
						ComponentGetValue2(char_data, "collision_aabb_max_y") * 0.75
					)
				end
			end
			local x, y, r, sx, sy = EntityGetTransform(entity_who_picked)
			EntitySetTransform(entity_who_picked, x, y, r, sx * 0.75, sy * 0.75)
			local children = EntityGetAllChildren(entity_who_picked)
			for _, child in ipairs(children or {}) do
				if EntityHasTag(child, "player_arm_r") then
					sprites = EntityGetComponent(child, "SpriteComponent")
					if sprites ~= nil and #sprites >= 1 then
						for _, sprite in ipairs(sprites) do
							ComponentSetValue2(sprite, "has_special_scale", true)
							ComponentSetValue2(
								sprite,
								"special_scale_x",
								ComponentGetValue2(sprite, "special_scale_x") * 0.75
							)
							ComponentSetValue2(
								sprite,
								"special_scale_y",
								ComponentGetValue2(sprite, "special_scale_y") * 0.75
							)
						end
					end
				end
			end
			-- game sets player arm scale so we cant make this look good
		end,
		func_remove = function(entity_who_picked)
			local sprites = EntityGetComponent(entity_who_picked, "SpriteComponent")
			if sprites ~= nil and #sprites >= 1 then
				for _, sprite in ipairs(sprites) do
					-- ComponentSetValue2(v, "has_special_scale", true) breaks turning
					ComponentSetValue2(sprite, "special_scale_x", ComponentGetValue2(sprite, "special_scale_x") / 0.75)
					ComponentSetValue2(sprite, "special_scale_y", ComponentGetValue2(sprite, "special_scale_y") / 0.75)
				end
			end
			local hitboxs = EntityGetComponent(entity_who_picked, "HitboxComponent")
			if hitboxs ~= nil and #hitboxs >= 1 then
				for _, hitbox in ipairs(hitboxs) do
					for _, key in ipairs({ "aabb_min_x", "aabb_max_x", "aabb_min_y", "aabb_max_y" }) do
						ComponentSetValue2(hitbox, key, ComponentGetValue2(hitbox, key) / 0.75)
					end
				end
			end
			local char_datas = EntityGetComponent(entity_who_picked, "CharacterDataComponent")
			if char_datas ~= nil and #char_datas >= 1 then
				for _, char_data in ipairs(char_datas) do
					ComponentSetValue2(
						char_data,
						"collision_aabb_min_x",
						ComponentGetValue2(char_data, "collision_aabb_min_x") / 0.75
					)
					ComponentSetValue2(
						char_data,
						"collision_aabb_min_y",
						ComponentGetValue2(char_data, "collision_aabb_min_y") / 0.75
					)
					ComponentSetValue2(
						char_data,
						"collision_aabb_max_x",
						ComponentGetValue2(char_data, "collision_aabb_max_x") / 0.75
					)
					ComponentSetValue2(
						char_data,
						"collision_aabb_max_y",
						ComponentGetValue2(char_data, "collision_aabb_max_y") / 0.75
					)
				end
			end
			local x, y, r, sx, sy = EntityGetTransform(entity_who_picked)
			EntitySetTransform(entity_who_picked, x, y, r, sx * 0.75, sy * 0.75)
			local children = EntityGetAllChildren(entity_who_picked)
			for _, child in ipairs(children or {}) do
				if EntityHasTag(child, "player_arm_r") then
					sprites = EntityGetComponent(child, "SpriteComponent")
					if sprites ~= nil and #sprites >= 1 then
						for _, sprite in ipairs(sprites) do
							ComponentSetValue2(sprite, "has_special_scale", false)
							ComponentSetValue2(
								sprite,
								"special_scale_x",
								ComponentGetValue2(sprite, "special_scale_x") / 0.75
							)
							ComponentSetValue2(
								sprite,
								"special_scale_y",
								ComponentGetValue2(sprite, "special_scale_y") / 0.75
							)
						end
					end
				end
			end
			-- game sets player arm scale so we cant make this look good
		end,
	},
	{ --TODO: Sprite
		id = "NATHANMOD_GIANT_STOMACH",
		ui_name = "$nathanmod_perk_giant_stomach",
		ui_description = "$nathanmod_perkdesc_giant_stomach",
		ui_icon = "data/ui_gfx/perk_icons/gold_is_forever.png",
		perk_icon = "data/items_gfx/perks/gold_is_forever.png",
		stackable_maximum = 3, -- 4 is infinite status effects, can get via dupes but that is your fault if you do that
		stackable = true,
		func = function(_, entity_who_picked, _)
			EntityAddComponent2(entity_who_picked, "LuaComponent", {
				execute_every_n_frame = 10,
				script_source_file = "mods/nathanmod/files/scripts/perks/giant_stomach.lua",
				_tags = "perk_component",
			})
		end,
		func_remove = function(entity_who_picked)
			local perk_comps = EntityGetComponent(entity_who_picked, "LuaComponent", "perk_component")
			for _, comp in ipairs(perk_comps or {}) do
				EntityRemoveComponent(entity_who_picked, comp)
			end
		end,
	},
}

for _, v in ipairs(new_perks) do
	table.insert(perk_list, v)
end
