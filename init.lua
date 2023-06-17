ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/nathanmod/files/scripts/append/actions.lua")

local new_content = ModTextFileGetContent("mods/nathanmod/files/translations.csv")
local content = ModTextFileGetContent("data/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. "\n" .. new_content)
