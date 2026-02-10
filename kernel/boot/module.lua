--[[
        Module loader

    Used to load kernel and schema modules. Uses underlaying includer system.
]]--

Basalt.Module = Basalt.Module or {}
Basalt.Module.Data = Basalt.Module.Data or {}

function Basalt.Module.InitializeModules(callback)
    local problemsFound

    local _, moduleFolders = file.Find("basalt/modules/*", "LUA", "nameasc")

    local function setAsFailing(tbl, reason)
        Basalt.Console.PrintWarning("(MOD_CONFIG_ERR) "..reason)
        tbl.STATUS = "[ FAIL ] "..reason
    end

    for i=1, #moduleFolders do
        if(file.Exists("basalt/modules/"..moduleFolders[i].."/mod.lua")) then
            local moduleData = Basalt.Includer.IncludeFile("basalt/modules/"..moduleFolders[i].."/mod.lua", Basalt.RealmType.SHARED)

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
                return
            end

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