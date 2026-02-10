--[[
        Boot

    This file serves as a main entry point to the framework.
]]--

DeriveGamemode("base")

_G.Basalt = _G.Basalt or {}

GM.Name = "Basalt"
GM.Author = "UniQodex"
Basalt.VERSION = "0.01"
Basalt.PREVIEW = true 

function GM:GetGameDescription()
    return "Basalt: Half-Life Roleplay"
end

MsgC(Color(55,155,255), "[ Basalt ] ", Color(230,230,230), "Initializing...\n")

Basalt.RealmType = {
    SERVER = 1,
    SHARED = 2,
    CLIENT = 3
}

-- load libs from basalt/kernel/boot folder, needed for basic functions such as file includer and such
function Basalt.IncludeKernelLib(filePath, realm, callback)
    if(!isstring(filePath)) then 
        MsgC(Color(55,155,255), "[ Basalt ] ", Color(255,55,55), "[ ERROR ] ", Color(180,40,40), "filePath is not type of string!\n")
        ErrorNoHaltWithStack("Argument filePath is not type of string!")
        return false 
    end

    if(!isnumber(realm)) then
        MsgC(Color(55,155,255), "[ Basalt ] ", Color(255,55,55), "[ ERROR ] ", Color(180,40,40), "realm is not type of number!\n")
        ErrorNoHaltWithStack("Argument realm is not type of number!")
        return false
    end

    local function canCall()
        if(callback) then
            callback()
        end
    end

    filePath = "basalt/kernel/boot/"..filePath..".lua"

    if(realm == Basalt.RealmType.SERVER) then
        if(SERVER) then
            include(filePath)
            canCall()
            return
        end
    elseif(realm == Basalt.RealmType.SHARED) then
        if(SERVER) then
            AddCSLuaFile(filePath)
        end

        include(filePath)
        canCall()
        return
    elseif(realm == Basalt.RealmType.CLIENT) then
        if(SERVER) then
            AddCSLuaFile(filePath)
            canCall()
            return 
        else
            include(filePath)
            canCall()
            return
        end
    end
end

Basalt.IncludeKernelLib("console", Basalt.RealmType.SHARED)

Basalt.Console.PrintInfo("Initializing kernel...")

local ok = Basalt.Console.PrintOK

Basalt.IncludeKernelLib("includer", Basalt.RealmType.SHARED, function() ok("Includer loaded") end)
Basalt.IncludeKernelLib("file", Basalt.RealmType.SHARED, function() ok("File loaded") end)
Basalt.IncludeKernelLib("module", Basalt.RealmType.SHARED, function() ok("Module loaded") end)

Basalt.Console.PrintOK("Kernel libs loaded")

Basalt.Console.PrintInfo("Initializing kernel modules...")

Basalt.Module.InitializeModules(function(problemsFound)
    if(problemsFound >= 1) then
        Basalt.Console.PrintWarning("Failed to initialize some modules! Found ("..problemsFound..") errors!")
    else
        ok("Modules initialized...")
    end
end)