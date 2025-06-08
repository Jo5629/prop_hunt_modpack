prop_hunt = {}

local modpath = core.get_modpath(core.get_current_modname()) .. "/src"

core.register_privilege("prop_hunt", {
    description = "Allows you to turn into blocks.",
    give_to_singleplayer = false,
    give_to_admin = false,
})

--[[
core.register_on_newplayer(function(player)
	local playername = player:get_player_name()
	local privs = core.get_player_privs(playername)
	privs["prop_hunt"] = true
	core.set_player_privs(playername, privs)
end)
]]

dofile(modpath .. "/api.lua")
dofile(modpath .. "/stick.lua")
dofile(modpath .. "/commands.lua")