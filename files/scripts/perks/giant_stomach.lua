-- its not possible to use nxml to parse the ingestion effects, because we dont know what mod adds them
giant_stomach_ghost = giant_stomach_ghost or EntityLoad("mods/nathanmod/files/entities/misc/giant_stomach_ghost.xml")
known = known or {}

local player = GetUpdatedEntityID()
local status_data_comps = EntityGetComponent(player, "StatusEffectDataComponent") or {}
local ingestion_comps = EntityGetComponent(player, "IngestionComponent") or {}
local ingestion_size
local ingestion_cooldown
for _, ingestion_comp in ipairs(ingestion_comps) do
	ingestion_size = ComponentGetValue2(ingestion_comp, "ingestion_size")
	ingestion_cooldown = ComponentGetValue2(ingestion_comp, "m_ingestion_cooldown_frames")
end
for _, status_data_comp in ipairs(status_data_comps) do
	local ingestion_effects = ComponentGetValue2(status_data_comp, "ingestion_effects")
	local ingestion_effect_causes = ComponentGetValue2(status_data_comp, "ingestion_effect_causes")
	for effect_index, ingestion_effect in ipairs(ingestion_effects) do
		if ingestion_effect > 0.1 and ingestion_effect_causes[effect_index] ~= 0 then
			if known[ingestion_effect_causes[effect_index]] == nil then
				local old_c = EntityGetComponent(giant_stomach_ghost, "StatusEffectDataComponent")[1]
				local old = ComponentGetValue2(old_c, "ingestion_effects")
				EntityIngestMaterial(giant_stomach_ghost, ingestion_effect_causes[effect_index], 1)
				for ghost_effect_index, ghost_effect in ipairs(ComponentGetValue2(old_c, "ingestion_effects")) do
					if ghost_effect - old[ghost_effect_index] > 0.00001 then -- i am untrusting that nolla will not switch this up on me
						known[ingestion_effect_causes[ghost_effect_index]] = ghost_effect
					end
				end
				-- EntityRemoveIngestionStatusEffect(giant_stomach_ghost,) we dont know the string id :sob: this means that thiings can go wrong (vomiting ghost) so we replace comp
				EntityRemoveComponent(giant_stomach_ghost, old_c)
				EntityAddComponent2(giant_stomach_ghost, "StatusEffectDataComponent")
			end
			EntityIngestMaterial(
				player,
				ingestion_effect_causes[effect_index],
				0.71 * 0.075 / known[ingestion_effect_causes[effect_index]]
			) -- 100 ~= 7s for LC, we want 0.05s which is +0.3s/s. 100/7s*0.05s=0.71
		end
	end
end

-- stop certain death
for _, ingestion_comp in ipairs(ingestion_comps) do
	ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
	ComponentSetValue2(ingestion_comp, "m_ingestion_cooldown_frames", ingestion_cooldown)
end

-- ComponentObjectGetValue2(600,"ingestion_effects","30")
