local e = EntityGetRootEntity(GetUpdatedEntityID())
local c = EntityGetComponent(e, "CharacterDataComponent")[1]
if c == nil then
	return
end
ComponentSetValue2(c, "mFlyingTimeLeft", ComponentGetValue2(c, "mFlyingTimeLeft") + 0.01)
