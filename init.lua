ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/nathanmod/files/scripts/append/actions.lua") -- spells
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/nathanmod/files/scripts/append/perks.lua") -- perks
ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/nathanmod/files/scripts/append/status.lua") -- status effects
ModLuaFileAppend("data/scripts/buildings/workshop_trigger_check_stats.lua","mods/nathanmod/files/scripts/append/hm.lua") -- holy mountain rewards
ModMaterialsFileAdd("mods/nathanmod/files/materials.xml") -- materials & reactions

local new_content = ModTextFileGetContent("mods/nathanmod/files/translations.csv")
local content = ModTextFileGetContent("data/translations/common.csv") .. "\n" .. new_content .. "\n"
content = content:gsub("\r",""):gsub("\n\n","\n")
ModTextFileSetContent("data/translations/common.csv", content) -- translations

