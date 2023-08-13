nathanmod_storage = collision_trigger
function collision_trigger()
	local entity_id = GetUpdatedEntityID()
	local x, y      = EntityGetTransform(entity_id)

	-- Note!
	--  * For global stats use StatsGetValue("enemies_killed")
	--  * For biome stats use StatsBiomeGetValue("enemies_killed")
	--
	-- the difference is that StatsBiomeGetValue() tracks the stats diff since calling StatsResetBiome()
	-- which is what workshop_exit calls
	--
	--
	-- this does the workshop rewards for playing in a certain way
	-- 1) killed none

	local reference = EntityGetClosestWithTag(x, y, "workshop_reference")

	local time      = tonumber(StatsBiomeGetValue("playtime"))
	print(enemies_killed)
	if (time <= 60) then
		local tier = 1
		tier = (time < 5 and 5) or (time < 15 and 4) or (time < 30 and 3) or (time < 45 and 2) or tier
		if (reference ~= 0) then
			x, y = EntityGetTransform(reference)
		else
			-- we have save corruption
			-- GamePrint("Your save is corrupted!")
		end

		local eid = EntityLoad("mods/nathanmod/files/entities/pickup/speedrun_chest.xml", x, y)
		change_entity_ingame_name(eid, "$nathanmod_speedrun_chest_" .. tier)
		ComponentSetValue2(EntityGetComponent(eid, "VariableStorageComponent")[1], "value_int", tier)
	else
		print("KILLED ALL")
	end
	nathanmod_storage()
end
