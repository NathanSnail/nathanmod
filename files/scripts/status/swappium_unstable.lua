local e = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(e)
local r = EntityGetInRadiusWithTag(x, y, 256, "enemy")
if #r < 2 then
	return
end
local s1 = r[Random(1, #r)]
local s2 = r[Random(1, #r)]
local x, y = EntityGetTransform(s1)
local nx, ny = EntityGetTransform(s2)
EntitySetTransform(s1, nx, ny)
EntitySetTransform(s2, x, y)
EntityLoad("data/entities/particles/teleportation_source.xml", x, y)
EntityLoad("data/entities/particles/teleportation_target.xml", nx, ny)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", x, y)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", nx, ny)
