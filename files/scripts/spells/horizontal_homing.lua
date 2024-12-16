local e = GetUpdatedEntityID()
local x, y = EntityGetTransform(e)
local target = EntityGetClosestWithTag(x, y, "homing_target")
local tx, ty = EntityGetTransform(target)
local vel = EntityGetComponent(e, "VelocityComponent") or {}
if #vel == 0 then
	return
end
local vx, vy = ComponentGetValue2(vel[1], "mVelocity")
local ox = 1 / (math.abs(tx - x) + 5) - 1 / 5
ox = (((tx - x) > 0) and -1 or 1) * ox * 60
ComponentSetValue2(vel[1], "mVelocity", vx + ox, vy)
