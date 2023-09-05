dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
edit_component(entity_id, "ProjectileComponent", function(comp, vars)
	vars.friendly_fire = true
	vars.collide_with_shooter_frames = 0
	vars.bounce_fx_file = "mods/nathanmod/files/entities/misc/bounce_evil.xml"
end)
