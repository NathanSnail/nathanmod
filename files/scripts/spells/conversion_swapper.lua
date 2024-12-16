local me = GetUpdatedEntityID()
for _, magic_converter_comp in ipairs(EntityGetComponent(me, "MagicConvertMaterialComponent") or {}) do
	local from_array = ComponentGetValue2(magic_converter_comp, "from_material_array")
	local from_material = ComponentGetValue2(magic_converter_comp, "from_material")
	ComponentSetValue2(
		magic_converter_comp,
		"from_material_array",
		ComponentGetValue2(magic_converter_comp, "to_material_array")
	)
	ComponentSetValue2(
		magic_converter_comp,
		"from_material",
		ComponentGetValue2(magic_converter_comp, "to_material")
	)
	ComponentSetValue2(magic_converter_comp, "to_material_array", from_array)
	ComponentSetValue2(magic_converter_comp, "to_material", from_material)
end
