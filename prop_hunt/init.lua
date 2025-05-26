prop_hunt = {}

local modpath = core.get_modpath(core.get_current_modname()) .. "/src"

core.register_privilege("prop_hunt", {
    description = "Allows you to turn into blocks.",
    give_to_singleplayer = false,
    give_to_admin = false,
})

dofile(modpath .. "/api.lua")
dofile(modpath .. "/stick.lua")
dofile(modpath .. "/commands.lua")

--[[ Tests.
core.register_on_chat_message(function(name, message)
    local player = core.get_player_by_name(name)
    if not player then return end
    if message == "block" then
        local nodename = "default:mese"
        prop_hunt.enter(player, nodename)
    end
    if message == "exit" then
        prop_hunt.exit(player)
    end
end)
]]