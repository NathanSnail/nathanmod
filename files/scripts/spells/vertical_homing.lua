local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local target = EntityGetClosestWithTag(x, y, "homing_target")
local _, target_y = EntityGetTransform(target)
local vel = EntityGetComponent(me, "VelocityComponent") or {}
if #vel == 0 then return end
local vel_x, vel_y = ComponentGetValue2(vel[1], "mVelocity")
local force_y = 1 / (math.abs(target_y - y) + 5) - 1 / 5
force_y = (((target_y - y) > 0) and -1 or 1) * force_y * 60
ComponentSetValue2(vel[1], "mVelocity", vel_x, vel_y + force_y)
