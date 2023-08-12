ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/nathanmod/files/scripts/append/actions.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/nathanmod/files/scripts/append/perks.lua")
ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/nathanmod/files/scripts/append/status.lua")

local new_content = ModTextFileGetContent("mods/nathanmod/files/translations.csv")
local content = ModTextFileGetContent("data/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. "\n" .. new_content)

ModMaterialsFileAdd("mods/nathanmod/files/materials.xml")
