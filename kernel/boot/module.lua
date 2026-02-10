--[[
        Module loader

    Used to load kernel and schema modules. Uses underlaying includer system.

    About moduleDeclare:
    It serves as a way to check plugin collisions, altough it adds a more tedious work it brings
    10x better reliability, as in helix framework, when someone installed it and downloaded like every
    avaible public plugin and smashed them together, it resulted in every plugin using/overwriting the same hook
    ultimately leading to crashando. In this way we compare every module moduleDeclare with each other and if collides
    we will notify the system operator and disable them until they are resolved or one is disabled.
]]--

Basalt.Module = Basalt.Module or {}
Basalt.Module.Data = Basalt.Module.Data or {}

function Basalt.Module.InitializeModules(callback)
    local problemsFound = 0

    local _, moduleFolders = file.Find("basalt/modules/*", "LUA", "nameasc")

    local function setAsFailing(tbl, reason)
        Basalt.Console.PrintWarning("(MOD_CONFIG_ERR) "..reason)
        tbl.STATUS = "[ FAIL ] "..reason
    end

    for i=1, #moduleFolders do
        if(file.Exists("basalt/modules/"..moduleFolders[i].."/mod.lua")) then
            local moduleData = Basalt.Includer.IncludeFile("basalt/modules/"..moduleFolders[i].."/mod.lua", Basalt.RealmType.SHARED)

            -- check if everything is existing as it should be
            if(!moduleData.ModuleName) then
                Basalt.Console.PrintWarning("(MOD_CONFIG_ERR) Not found ModuleName in ("..moduleFolders[i]..")! Using raw path name instead...")
                moduleData.ModuleName = moduleFolders[i]
                problemsFound = problemsFound + 1
            end

            Basalt.Module.Data[moduleData.ModuleName] = {}

            if(!moduleData.ModuleDeclare) then
                Basalt.Console.PrintWarning("(MOD_CONFIG_ERR) Not found ModuleDeclare for ("..moduleData.ModuleName..")!\n[ !!! ] This module will be disabled for reliability reasons!\n")
                Basalt.Module.Data[moduleData.ModuleName].STATUS = "[ FAIL ] Missing ModuleDeclare"
                problemsFound = problemsFound + 1
                continue
            end

            -- end check
            if(problemsFound == 0) then
                Basalt.Console.PrintOK("Module ("..moduleData.ModuleName..") loaded with no errors")    
            else
                Basalt.Console.PrintWarning("Module ("..moduleData.ModuleName..") loaded with non-fatal errors")
            end

            Basalt.Module.Data[moduleData.ModuleName].STATUS = "[ OK ] No errors found"
        end
    end

    -- return the number of problems if any, 0=success, > 1 means we got a problem
    if(callback) then
        callback(problemsFound)
    end
end