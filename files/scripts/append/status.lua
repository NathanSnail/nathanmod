local new_effects = {
	{
		id = "NATHANMOD_BOOSTIUM",
		ui_name = "$nathanmod_status_boostium",
		ui_description = "$nathanmod_statusdesc_boostium",
		ui_icon = "", -- TODO: sprite
		effect_entity = "mods/nathanmod/files/entities/status/boostium.xml",
		is_harmful = false,
	},
	{
		id = "NATHANMOD_SWAPPIUM",
		ui_name = "$nathanmod_status_swappium",
		ui_description = "$nathanmod_statusdesc_swappium",
		ui_icon = "", -- TODO: sprite
		effect_entity = "mods/nathanmod/files/entities/status/swappium.xml",
		is_harmful = false,
	},
	{
		id = "NATHANMOD_SWAPPIUM_UNSTABLE",
		ui_name = "$nathanmod_status_swappium_unstable",
		ui_description = "$nathanmod_statusdesc_swappium_unstable",
		ui_icon = "", -- TODO: sprite
		effect_entity = "mods/nathanmod/files/entities/status/swappium_unstable.xml",
		is_harmful = false,
	},
}

for _, effect in ipairs(new_effects) do
	table.insert(status_effects, effect)
end
