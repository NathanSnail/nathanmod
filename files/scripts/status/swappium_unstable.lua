local me = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(me)
local enemies = EntityGetInRadiusWithTag(x, y, 256, "enemy")
if #enemies < 2 then return end
local target_1 = enemies[Random(1, #enemies)]
local target_2 = enemies[Random(1, #enemies)]
local from_x, from_y = EntityGetTransform(target_1)
local to_x, to_y = EntityGetTransform(target_2)
EntitySetTransform(target_1, to_x, to_y)
EntitySetTransform(target_2, from_x, from_y)
EntityLoad("data/entities/particles/teleportation_source.xml", from_x, from_y)
EntityLoad("data/entities/particles/teleportation_target.xml", to_x, to_y)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", from_x, from_y)
GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", to_x, to_y)
