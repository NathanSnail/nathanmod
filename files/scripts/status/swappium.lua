local e = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(e)
local r = EntityGetInRadiusWithTag(x, y, 256, "enemy")
if #r == 0 then
	return
end
local s = r[Random(1, #r)]
local nx, ny = EntityGetTransform(s)
EntitySetTransform(e, nx, ny)
EntitySetTransform(s, x, y)
EntityLoad("data/entities/particles/teleportation_source.xml", x, y)
EntityLoad("data/entities/particles/teleportation_target.xml", nx, ny)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", x, y)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", nx, ny)
