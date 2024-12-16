local e = GetUpdatedEntityID()
local x, y = EntityGetTransform(e)
local target = EntityGetClosestWithTag(x, y, "homing_target")
local tx, ty = EntityGetTransform(target)
local vel = EntityGetComponent(e, "VelocityComponent") or {}
if #vel == 0 then return end
local vx, vy = ComponentGetValue2(vel[1], "mVelocity")
local oy = 1 / (math.abs(ty - y) + 5) - 1 / 5
oy = (((ty - y) > 0) and -1 or 1) * oy * 60
ComponentSetValue2(vel[1], "mVelocity", vx, vy + oy)
