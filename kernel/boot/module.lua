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
    local loadedHooks = {}

    local _, moduleFolders = file.Find("basalt/modules/*", "LUA", "nameasc")

    for i=1, #moduleFolders do
        local isFatal = false
        local isNonFatal = false

        if(file.Exists("basalt/modules/"..moduleFolders[i].."/mod.lua", "LUA")) then
            local moduleData = Basalt.Includer.IncludeFile("basalt/modules/"..moduleFolders[i].."/mod.lua", Basalt.RealmType.SHARED)

            if(!moduleData.Name) then
                Basalt.Console.PrintWarning("(MOD_CONFIG_ERR) Not found Name in module '"..moduleFolders[i].."'! Using raw path name instead...")
                moduleData.Name = moduleFolders[i]

                problemsFound = problemsFound + 1
                isNonFatal = true
            end

            Basalt.Module.Data[moduleData.Name] = {}

            if(!moduleData.Declare) then -- fatal
                Basalt.Console.PrintWarning("(MOD_CONFIG_ERR) Not found Declare for module '"..moduleData.Name.."'!\nThis module will be disabled for reliability reasons!\n")

                Basalt.Module.Data[moduleData.Name].STATUS = "[ FAIL ] Missing Declare"
                problemsFound = problemsFound + 1
                isFatal = true
            end

            if(!moduleData.Author) then
                moduleData.Author = "Unknown"

                Basalt.Console.PrintWarning("(MOD_CONFIG_WARN) Not found 'Author' for module '"..moduleData.Name.."'...")
                problemsFound = problemsFound + 1
                isNonFatal = true
            end

            if(!moduleData.Description) then -- incomplete module, forces to write descriptions for their module, name 'hud' is not sufficient, explain what your 'hud' does atleast
                moduleData.Description = "Unknown"

                Basalt.Console.PrintWarning("(MOD_CONFIG_WARN) Not found 'Description' for module '"..moduleData.Name.."'...")
                problemsFound = problemsFound + 1
                isNonFatal = true
            end

            -- Resolve collisions
            for j=1, #moduleData.Declare do -- can fatal
                local dhooks = moduleData.Declare[j]
                if(loadedHooks[dhooks]) then
                    Basalt.Console.PrintWarning("(MOD_COLLISION) Hook '"..dhooks.."' in module '"..moduleData.Name.."' collides with module '"..loadedHooks[dhooks].."'!\nThis module will not be loaded!")
                    Basalt.Module.Data[moduleData.Name] = { STATUS = "[ FAIL ] Hook collision: "..dhooks }
                    problemsFound = problemsFound + 1
                    isFatal = true
                    break
                end
            end

            if(isFatal) then
                Basalt.Console.PrintWarning("(MOD_CONFIG_FATAL) Module '"..moduleData.Name.."' will not be loaded due to fatal errors!")
                continue

            end

            if(isNonFatal) then
                Basalt.Console.PrintWarning("(MOD_CONFIG_NFATAL) Module '"..moduleData.Name.."' has generated a non-fatal errors...")
            end

            table.CopyFromTo(moduleData, Basalt.Module.Data[moduleData.Name])

            for j=1, #moduleData.Declare do
                local dhooks = moduleData.Declare[j]
                loadedHooks[dhooks] = moduleData.Name
            end

            Basalt.Includer.IncludeFolder("basalt/modules/"..moduleFolders[i])

            Basalt.Module.Data[moduleData.Name].STATUS = "[ OK ] Module loaded"
        else -- mod.lua not found:
            Basalt.Console.PrintWarning("(MOD_CONFIG_NTFOUND) Module mod config not found for '"..moduleFolders[i].."'!\nThis module will not be loaded!\n")
            problemsFound = problemsFound + 1
            continue
        end
    end

    -- return the number of problems if any, 0=success, > 1 means we got a problem
    if(callback) then
        callback(problemsFound)
    end
end