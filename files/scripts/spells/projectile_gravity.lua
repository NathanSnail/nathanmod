dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local shooter = ComponentGetValue2(EntityGetComponent(entity_id, "ProjectileComponent")[1], "mWhoShot")

local projectiles = EntityGetWithTag("projectile")

if #projectiles > 0 then
	for _, projectile in ipairs(projectiles) do
		local px, py = EntityGetTransform(projectile)

		local distance = math.abs(x - px) + math.abs(y - py)
		local distance_full = 30

		if (distance < distance_full * 1.25) and (entity_id ~= projectile) then
			distance = math.sqrt((x - px) ^ 2 + (y - py) ^ 2)
			direction = 0 - math.atan2((y - py), (x - px))

			if distance < distance_full then
				local velocitycomponents = EntityGetComponent(projectile, "VelocityComponent")

				local gravity_percent = math.max((distance_full - distance) / distance_full, 0.2)
				local gravity_coeff = 100

				if velocitycomponents ~= nil then
					edit_component(projectile, "VelocityComponent", function(comp, _)
						local vel_x, vel_y = ComponentGetValue2(comp, "mVelocity")

						local offset_x = math.cos(direction) * (gravity_coeff * gravity_percent)
						local offset_y = 0 - math.sin(direction) * (gravity_coeff * gravity_percent)

						vel_x = vel_x + offset_x
						vel_y = vel_y + offset_y

						ComponentSetValue2(comp, "mVelocity", vel_x, vel_y)
					end)
					edit_component(projectile, "ProjectileComponent", function(comp, _)
						local projectile_shooter = ComponentGetValue2(comp, "mWhoShot")

						if shooter == projectile_shooter then
							return
						end

						ComponentSetValue2(comp, "friendly_fire", true)
						ComponentSetValue2(comp, "collide_with_shooter_frames", 0)
					end)
				end
			end
		end
	end
end
