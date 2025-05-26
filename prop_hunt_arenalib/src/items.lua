local msg_player = core.chat_send_player
local function colorize_msg(name, color, message)
    return msg_player(name, core.colorize(color, message))
end

core.register_tool(":prop_hunt:radar", {
    description = "Radar",
    inventory_image = "radar.png",
    range = 0,
    on_use = function(itemstack, user, pointed_thing)
        if itemstack:get_wear() == 0 then
            local name = user:get_player_name()
            local arena = arena_lib.get_arena_by_player(name)
            if not arena or arena.started ~= 1 then
                colorize_msg(name, "#FF0000", "Game has not started or does not exist!")
                return
            end
            local found, foundobj = false, nil
            local objs = core.get_objects_inside_radius(user:get_pos(), arena.RADAR_DISTANCE)
            for _, obj in pairs(objs) do
                if obj:is_player() and obj:get_player_name() ~= name then
                    found, foundobj = true, obj
                    break
                end
            end
            if found and foundobj then
                audio_lib.play_sound("radar_ping", {to_player = name})
                local id = user:hud_add({
                    hud_elem_type = "waypoint",
                    name = "PLAYER",
                    text = "m",
                    number = 0x85FF00,
                    world_pos = foundobj:get_pos()
                })
                core.after(3, function()
                    if user then
                        user:hud_remove(id)
                    end
                end)
                colorize_msg(name, "#85FF00", "Found a player!")
            else
               colorize_msg(name, "#FF0000", "Did not find a player.")
            end

            local dstep = math.floor(65534 / arena.RADAR_COOLDOWN)
            prop_hunt.update_wear.start_update(name, "prop_hunt:radar", dstep, true)

            itemstack:set_wear(65534)
            return itemstack
        end
    end
})

core.register_tool(":prop_hunt:stun", {
    description = "Stun",
    inventory_image = "stun.png",
    range = 0,
    on_use = function(itemstack, user, pointed_thing)
        if itemstack:get_wear() == 0 then
            local name = user:get_player_name()
            local arena = arena_lib.get_arena_by_player(name)
            if not arena or arena.started ~= 1 then
                colorize_msg(name, "#FF0000", "Game has not started or does not exist!")
                return
            end

            for _, obj in pairs(core.get_objects_inside_radius(user:get_pos(), arena.STUN_RADIUS)) do
                if obj:is_player() and arena.players[obj:get_player_name()].teamID == 1 then
                    audio_lib.play_sound("taser", {object = obj})
                    prop_hunt.freeze(obj, arena)
                    arena_lib.HUD_send_msg("title", obj:get_player_name(), "FROZEN!", arena.STUN_FROZEN)
                    core.after(arena.STUN_FROZEN, function()
                        if obj then
                            prop_hunt.unfreeze(obj, arena)
                        end
                    end)
                end
            end

            local dstep = math.floor(65534 / arena.STUN_COOLDOWN)
            prop_hunt.update_wear.start_update(name, "prop_hunt:stun", dstep, true)

            itemstack:set_wear(65534)
            return itemstack
        end
    end
})

core.register_alias("radar", "prop_hunt:radar")
core.register_alias("stun", "prop_hunt:stun")