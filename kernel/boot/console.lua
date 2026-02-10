--[[
        Console

    Provides simple functions that prints out nicely formatted and readable console messages.
]]--

Basalt.Console = Basalt.Console or {}

local colGray = Color(130,130,130)
local colBlue = Color(55,155,255)
local colWhite = Color(230,230,230)
local colGreen = Color(55,255,55)
local colRed = Color(255,55,55)
local colRedDarker = Color(180,40,40)
local colOrange = Color(255,155,55)
local colOrangeDarker = Color(230,100,0)
local colDebug = Color(0,255,255)
local colDebugDarker = Color(0,155,255)

-- Returns a formatted string with current time of the host system
function Basalt.Console.GetTime()
    return os.date("%d/%m/%y - %H:%M")
end

function Basalt.Console.PrintInfo(msg)
    MsgC(colGray, Basalt.Console.GetTime().." | ", colBlue, "[ Basalt ] ", colWhite, tostring(msg).."\n")
end

function Basalt.Console.PrintDebug(msg)
    if(!Basalt.PREVIEW) then return end
    MsgC(colGray, Basalt.Console.GetTime().." | ", colBlue, "[ Basalt ] ", colDebug, "[ DEBUG ] ", colDebugDarker, tostring(msg).."\n")
end

function Basalt.Console.PrintWarning(msg)
    MsgC(colGray, Basalt.Console.GetTime().." | ", colBlue, "[ Basalt ] ", colOrange, "[ WARNING ] ", colOrangeDarker, tostring(msg).."\n")
end

function Basalt.Console.PrintOK(msg)
    MsgC(colGray, Basalt.Console.GetTime().." | ", colBlue, "[ Basalt ] ", colGreen, "[ OK ] ", colWhite, tostring(msg).."\n")
end

function Basalt.Console.PrintError(msg)
    MsgC(colGray, Basalt.Console.GetTime().." | ", colBlue, "[ Basalt ] ", colRed, "[ ERROR ] ", colRedDarker, tostring(msg).."\n")
    ErrorNoHaltWithStack(tostring(msg))
end