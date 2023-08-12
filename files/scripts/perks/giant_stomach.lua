-- its not possible to use nxml to parse the ingestion effects, because we dont know what mod adds them
giant_stomach_ghost = giant_stomach_ghost or EntityLoad("mods/nathanmod/files/entities/misc/giant_stomach_ghost.xml")
known = known or {}

local p = GetUpdatedEntityID()
local cs = EntityGetComponent(p, "StatusEffectDataComponent") or {}
local ic = EntityGetComponent(p, "IngestionComponent") or {}
local l
local l2
for k, c in ipairs(ic) do
	l = ComponentGetValue2(c, "ingestion_size")
	l2 = ComponentGetValue2(c, "m_ingestion_cooldown_frames")
end
for k, c in ipairs(cs) do
	local l = ComponentGetValue2(c, "ingestion_effects")
	local d = ComponentGetValue2(c, "ingestion_effect_causes")
	for k, v in ipairs(l) do
		if v > 0.1 and d[k] ~= 0 then
			if known[d[k]] == nil then
				local old_c = EntityGetComponent(giant_stomach_ghost, "StatusEffectDataComponent")[1]
				local old = ComponentGetValue2(old_c, "ingestion_effects")
				EntityIngestMaterial(giant_stomach_ghost, d[k], 1)
				for k, v in ipairs(ComponentGetValue2(old_c, "ingestion_effects")) do
					if v - old[k] > 0.00001 then -- i am untrusting that nolla will not switch this up on me
						known[d[k]] = v
					end
				end
				-- EntityRemoveIngestionStatusEffect(giant_stomach_ghost,) we dont know the string id :sob: this means that thiings can go wrong (vomiting ghost) so we replace comp
				EntityRemoveComponent(giant_stomach_ghost, old_c)
				EntityAddComponent2(giant_stomach_ghost, "StatusEffectDataComponent")
			end
			print(known[d[k]], d[k])
			EntityIngestMaterial(p, d[k], 0.71 * 0.075 / known[d[k]]) -- 100 ~= 7s for LC, we want 0.05s which is +0.3s/s. 100/7s*0.05s=0.71
		end
	end
end

-- stop certain death
for k, c in ipairs(ic) do
	ComponentSetValue2(c, "ingestion_size", l)
	ComponentSetValue2(c, "m_ingestion_cooldown_frames", l2)
end

-- ComponentObjectGetValue2(600,"ingestion_effects","30")
