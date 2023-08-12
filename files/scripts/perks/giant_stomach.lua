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
			EntityIngestMaterial(p, d[k], 0.71) -- 100 ~= 7s, we want 0.05s which is +0.3s/s. 100/7s*0.05s=0.71
		end
	end
end

-- stop certain death
for k, c in ipairs(ic) do
	ComponentSetValue2(c, "ingestion_size", l)
	ComponentSetValue2(c, "m_ingestion_cooldown_frames", l2)
end

-- ComponentObjectGetValue2(600,"ingestion_effects","30")
