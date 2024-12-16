local me = EntityGetRootEntity(GetUpdatedEntityID())
local char_datas = EntityGetComponent(me, "CharacterDataComponent") or {}
if #char_datas == 0 then return end
ComponentSetValue2(
	char_datas[1],
	"mFlyingTimeLeft",
	ComponentGetValue2(char_datas, "mFlyingTimeLeft") + 0.01
)
