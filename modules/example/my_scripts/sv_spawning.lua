--[[
Example:

function GM:PlayerGiveSWEP(ply)
    ply:IsUserGroup("Donator")
end

function GM:HUDDrawTargetID()
    return
end

Description:

In mod.lua we declared that we are going to override the function PlayerGiveSWEP (please note, that it is string validated, not using the actual function object)
so if any other plugin will try to override this function, it will either this or that other module will be skipped and error will be throwed.

]]--

local a -- quick fix so it wont complain about empty file