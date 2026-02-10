--[[
        Includer

    Used for including files and folders based on file prefix realms.
    Also handles loading modules and managing their state.
]]--

Basalt.Includer = Basalt.Includer or {}

local fileExists = file.Exists
local fileFind = file.Find

-- Function to include a file, specifying file realm ahead of time saves times so we dont have to do string operations on that file
local AddCSLuaFile = AddCSLuaFile
local include = include
function Basalt.Includer.IncludeFile(filePath, realm)
    if(!isstring(filePath)) then 
        MsgC(Color(55,155,255), "[ Basalt ] ", Color(255,55,55), "[ ERROR ] ", Color(180,40,40), "filePath is not type of string!\n")
        ErrorNoHaltWithStack("Argument filePath is not type of string!")
        return false 
    end

    if(realm) then
        if(!isnumber(realm)) then
            MsgC(Color(55,155,255), "[ Basalt ] ", Color(255,55,55), "[ ERROR ] ", Color(180,40,40), "realm is not type of number!\n")
            ErrorNoHaltWithStack("Argument realm is not type of number!")
            return false
        end 
    end

    if(isnumber(realm)) then
        if(realm == Basalt.RealmType.SERVER) then
            if(SERVER) then
                include(filePath)
                return
            end
        elseif(realm == Basalt.RealmType.SHARED) then
            if(SERVER) then
                AddCSLuaFile(filePath)
            end

            include(filePath)
            return
        elseif(realm == Basalt.RealmType.CLIENT) then
            if(SERVER) then
                AddCSLuaFile(filePath)
                return 
            else
                include(filePath)
                return
            end
        end
    else
        local fileName = string.GetFileFromFilename(filePath)
        local filePrefix = fileName:sub(1,3)

        if(filePrefix == "sv_") then
            if(SERVER) then
                include(filePath)
                return 
            end
        elseif(filePrefix == "sh_") then
            if(SERVER) then
                AddCSLuaFile(filePath)
            end

            include(filePath)
            return 
        elseif(filePrefix == "cl_") then
            if(SERVER) then
                AddCSLuaFile(filePath)
                return 
            else
                include(filePath)
                return
            end
        end
    end
end

local bInclude = Basalt.Includer.IncludeFile
function Basalt.Includer.IncludeFolder(folderPath, recursive, useDef, callback)
    if(!isstring(folderPath)) then 
        MsgC(Color(55,155,255), "[ Basalt ] ", Color(255,55,55), "[ ERROR ] ", Color(180,40,40), "folderPath is not type of string!\n")
        ErrorNoHaltWithStack("Argument folderPath is not type of string!")
        return false 
    end

    local foundFiles, foundFolders = fileFind(folderPath.."/*", "LUA")

    -- manifest file (def.lua) is used to define (global) variables and is loaded first before all the lua files in current folder
    -- so basically create global table for that folder like Basalt.MyLib
    if(useDef) then
        if(fileExists(folderPath.."/def.lua", "LUA")) then
            bInclude(folderPath.."/def.lua", Basalt.RealmType.SHARED)
        end 
    end

    for i=1, #foundFiles do
        if(foundFiles[i] == "def.lua") then continue end
        bInclude(folderPath.."/"..foundFiles[i])
    end

    if(recursive) then
        for i=1, #foundFolders do
            Basalt.Includer.IncludeFolder(folderPath.."/"..foundFolders[i], true, useDef)
        end
    end

    if(callback) then
        callback(folderPath)
    end
end