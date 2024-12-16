local me = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(me)
local enemies = EntityGetInRadiusWithTag(x, y, 256, "enemy")
if #enemies == 0 then return end
local target = enemies[Random(1, #enemies)]
local new_x, new_y = EntityGetTransform(target)
EntitySetTransform(me, new_x, new_y)
EntitySetTransform(target, x, y)
EntityLoad("data/entities/particles/teleportation_source.xml", x, y)
EntityLoad("data/entities/particles/teleportation_target.xml", new_x, new_y)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", x, y)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", new_x, new_y)
