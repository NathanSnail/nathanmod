local e = GetUpdatedEntityID()
for k, v in ipairs(EntityGetComponent(e, "MagicConvertMaterialComponent") or {}) do
	local fa = ComponentGetValue2(v, "from_material_array")
	local f = ComponentGetValue2(v, "from_material")
	print(fa, f)
	ComponentSetValue2(v, "from_material_array", ComponentGetValue2(v, "to_material_array"))
	ComponentSetValue2(v, "from_material", ComponentGetValue2(v, "to_material"))
	ComponentSetValue2(v, "to_material_array", fa)
	ComponentSetValue2(v, "to_material", f)
end
