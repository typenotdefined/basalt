--[[
        File

    Extends the current file systems.
]]--
Basalt.File = Basalt.File or {}

-- Returns for example: basalt/modules/my_module/mnf.lua if called in mnf.lua
function Basalt.File.GetCurrentFilePath()
    local info = debug.getinfo(2, "S")
    local callerFile = info && info.source or "unknown"

    if(callerFile:sub(1, 1) == "@") then
        callerFile = callerFile:sub(2)
    end

    callerFile = callerFile:gsub("^gamemodes/", "")
    callerFile = callerFile:gsub("^addons/", "")

    return callerFile
end