local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local target = EntityGetClosestWithTag(x, y, "homing_target")
local target_x = EntityGetTransform(target)
local vel_comps = EntityGetComponent(me, "VelocityComponent") or {}
if #vel_comps == 0 then return end
local vel_x, vel_y = ComponentGetValue2(vel_comps[1], "mVelocity")
local force_x = 1 / (math.abs(target_x - x) + 5) - 1 / 5
force_x = (((target_x - x) > 0) and -1 or 1) * force_x * 60
ComponentSetValue2(vel_comps[1], "mVelocity", vel_x + force_x, vel_y)
