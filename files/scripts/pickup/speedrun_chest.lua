dofile_once("data/scripts/gun/gun_actions.lua")

function get_spell(tier)
	while true do
		local itemno = Random(1, #actions)
		local item = actions[itemno]

		if
			((item.spawn_requires_flag == nil) or HasFlagPersistent(item.spawn_requires_flag)) and (item.spawn_probability ~= "0") and (item.spawn_level:find(tostring(tier)) ~= nil) then
			return item
		end
	end
end

function generate_spell(x, y, tier)
	local item = ""
	item = get_spell(tier).id
	CreateItemActionEntity(item, x, y)
end

function drop_spells(x, y)
	local num = ComponentGetValue2(EntityGetComponent(GetUpdatedEntityID(), "VariableStorageComponent")[1], "value_int")
	for i = 1, num do
		generate_spell(x + i * 10 - num * 5, y, num)
	end
end

function do_loot(spell_box, entity_who_picked, name)
	local x, y = EntityGetTransform(spell_box)
	local rand_x
	local rand_y

	-- PositionSeedComponent
	local position_comp = EntityGetFirstComponent(spell_box, "PositionSeedComponent")
	if (position_comp) then
		rand_x = tonumber(ComponentGetValue(position_comp, "pos_x")) or x
		rand_y = tonumber(ComponentGetValue(position_comp, "pos_y")) or y
	end

	SetRandomSeed(rand_x + 509.7, rand_y + 683.1)

	drop_spells(x, y)

	EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
end

function item_pickup(spell_box)
	do_loot(spell_box)
	EntityKill(spell_box)
end

function physics_body_modified(is_destroyed)
	local spell_box = GetUpdatedEntityID()
	do_loot(spell_box)
	EntitySetComponentIsEnabled(spell_box, EntityGetComponent(spell_box, "ItemComponent")[1], false)
	EntityKill(spell_box)
end
