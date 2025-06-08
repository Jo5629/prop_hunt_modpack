local function hunter(player, arena)
    local inv = player:get_inventory()
    local sword = ItemStack("default:sword_steel")
    sword:get_meta():set_float("range", 3)
    sword:get_meta():set_tool_capabilities({
        full_punch_interval = 0.8,
        groupcaps={
            snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=9999, maxlevel=2},
        },
        damage_groups = {fleshy=6},
    })
    inv:add_item("main", sword)

    if arena.ENABLED_RADAR then
        inv:add_item("main", "prop_hunt:radar")
    end

    prop_hunt.freeze(player, arena)
    arena.hunter_huds[player:get_player_name()] = player:hud_add({
        hud_elem_type = "image",
        alignment = {x = 0, y = 0},
        position = {x = 0.5, y = 0.5},
        scale = {x = 80, y = 80},
        text = "[fill:64x64:#000000",
        z_index = -100,
    })
end

local function prop(player, arena)
    local inv = player:get_inventory()
    inv:add_item("main", "prop_hunt:stick")

    if arena.ENABLED_STUN then
        local stun = ItemStack("prop_hunt:stun")
        stun:get_meta():set_string('description', tostring(arena.STUN_RADIUS) .. "-Block Stun")
        inv:add_item("main", stun)
    end
end

arena_lib.on_load("prop_hunt", function(arena)
    for pname, def in pairs(arena.players) do
        local player = core.get_player_by_name(pname)
        if def.teamID == 1 then
            hunter(player, arena)
        end
        if def.teamID == 2 then
            prop(player, arena)
        end
        player:get_inventory():add_item("main", "default:apple 5")
    end
    arena_lib.HUD_send_msg_team("title", arena, 1, "Waiting for the props to hide...")
    arena_lib.HUD_send_msg_team("hotbar", arena, 2, "Hide from the hunters!")
end)

local function remove_huds(arena)
    for name, id in pairs(arena.hunter_huds) do
        local player = core.get_player_by_name(name)
        if player then
            player:hud_remove(id)
            prop_hunt.unfreeze(player, arena)
        end
        arena.hunter_huds[name] = nil
    end
end

arena_lib.on_start("prop_hunt", function(arena)
    arena.started = 1
    arena_lib.HUD_hide("title", arena)
    arena_lib.HUD_send_msg_all("hotbar", arena, "Time Left: " .. arena.initial_time)
    remove_huds(arena)
end)

arena_lib.on_quit('prop_hunt', function(arena, pname)
    local player = core.get_player_by_name(pname)
    if player then
        prop_hunt.unfreeze(player, arena)
        prop_hunt.exit(player)
    end
end)

local timer = 0
arena_lib.on_time_tick("prop_hunt", function(arena)
    arena_lib.HUD_send_msg_all("hotbar", arena, "Time Left: " .. arena.current_time)
    if arena.ENABLED_NOISEMAKER then
        timer = timer + 1
        if timer >= arena.TIMER_NOISEMAKER then
            for _, pname in pairs(arena_lib.get_players_in_team(arena, 2)) do
                local player = core.get_player_by_name(pname)
                if player then
                    audio_lib.play_sound("noisemaker", {object = player})
                end
            end
            timer = 0
        end
    end
end)

arena_lib.on_timeout("prop_hunt", function(arena)
    arena_lib.load_celebration("prop_hunt", arena, 2)
    arena_lib.HUD_hide("hotbar", arena)
end)

arena_lib.on_end("prop_hunt", function(arena, winners, is_forced)
    arena.started = 0
    remove_huds(arena)
    for pname, def in pairs(arena.players) do
        local player = core.get_player_by_name(pname)
        core.after(0.2, function()
            if player and def.teamID == 2 then
                prop_hunt.exit(player)
                player:set_pos(vector.offset(player:get_pos(), 0, 1.15, 0))
            end
        end)
    end
end)

arena_lib.on_death("prop_hunt", function(arena, pname, reason)
    local player = core.get_player_by_name(pname)
    if player then prop_hunt.exit(player) end
    arena_lib.remove_player_from_arena(pname, 1)
    if arena.teams[1] == 0 then
        arena_lib.load_celebration("prop_hunt", arena, 2)
    end
    if arena.teams[2] == 0 then
        arena_lib.load_celebration("prop_hunt", arena, 1)
    end
end)