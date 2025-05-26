local function rightclick(player)
    prop_hunt.snap(player)
end

core.register_tool("prop_hunt:stick", {
    description = "Prop Hunt Stick\n- Punch nodes with this to change into them.\n- Shift and punch to exit.\n- Rightclick to snap to the nearest node.",
    inventory_image = "prop_hunt_stick.png",
    on_use = function(itemstack, user, pointed_thing)
        local ptype = pointed_thing.type
        if user:get_player_control().sneak then
            return prop_hunt.exit(user)
        end
        if ptype == "node" then
            local node = core.get_node(pointed_thing.under)
            return prop_hunt.enter(user, node, pointed_thing.under)
        end
        if ptype == "nothing" then
            return prop_hunt.exit(user)
        end
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        rightclick(user)
    end,
    on_place = function(itemstack, user, pointed_thing)
        rightclick(user)
    end,
    tool_capabilities = {
        can_drop = false,
    }
})