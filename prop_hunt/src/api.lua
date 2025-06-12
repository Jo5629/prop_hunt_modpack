local players = {}

local function valid_node(nodename)
    return core.registered_nodes[nodename] ~= nil
end

--> https://stackoverflow.com/questions/20325332/how-to-check-if-two-tablesobjects-have-the-same-value-in-lua
---@param o1 any|table First object to compare
---@param o2 any|table Second object to compare
---@param ignore_mt boolean True to ignore metatables (a recursive function to tests tables inside tables)
local function equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

local BOX_DEFAULT = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
local BOX_OBJ_DEFAULT = BOX_DEFAULT

local function get_box(box_type, pos, node)
    local box = core.get_node_boxes(box_type, pos, node)[1]
    if type(box[1]) ~= "number" then --> More than one box and Luanti does not support it with objects as of 5.12.
        box = BOX_OBJ_DEFAULT
    end
    --core.log("action", box_type .. " " .. dump(box))
    return box
end

--> HIERARCHY: node_box -> selection_box -> collision_box

function prop_hunt.enter(player, node, pos)
    if type(node) == "string" and valid_node(node) then
        node = {name = node, param1 = 0, param2 = 0}
    end
    if type(node) ~= "table" then
        return
    end
    pos = pos or vector.zero()
    local name = player:get_player_name()
    if core.check_player_privs(name, {prop_hunt = true}) then
        player:get_meta():set_string("prop_hunt:node", node.name)

        local def = core.registered_nodes[node.name]
        local visual_scale = def.visual_scale or 1

        local node_box = get_box("node_box", pos, node)
        if equals(node_box, BOX_DEFAULT) then node_box = BOX_OBJ_DEFAULT end

        local selection_box = get_box("selection_box", pos, node)
        if equals(selection_box, BOX_DEFAULT) then selection_box = node_box end

        local collision_box = get_box("collision_box", pos, node)
        if equals(collision_box, BOX_DEFAULT) then collision_box = selection_box end

        player:set_properties({
            visual = "node",
            node = node,
            physical = true,
            collide_with_objects = true,
            pointable = true,
            collisionbox = collision_box,
            selectionbox = selection_box,
            eye_height = 0.5 * visual_scale,
            stepheight = 0.6,
            range = 2,
            makes_footstep_sound = true,
            show_on_minimap = false,
            backface_culling = false,
        })

        player:set_pos(vector.offset(player:get_pos(), 0, 1.15, 0))
        players[name] = true
    end
end

function prop_hunt.exit(player)
    if players[player:get_player_name()] then
        prop_hunt.reset_model(player)
        player:set_pos(vector.offset(player:get_pos(), 0, 1.15, 0))
        players[player:get_player_name()] = nil
    end
end

function prop_hunt.snap(player)
    if not players[player:get_player_name()] then return end
    local pos = player:get_pos()
    player:set_pos(vector.new(math.round(pos.x), math.round(pos.y), math.round(pos.z)))
    player:set_look_horizontal(math.rad(0))
end

function prop_hunt.reset_model(player)
    player_api.set_model(player)
    player_api.set_model(player, "character.b3d")
end

core.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    if players[name] then
        players[name] = nil
    end
end)

core.register_on_respawnplayer(function(player)
    local name = player:get_player_name()
    if players[name] then
        core.after(0.1, function()
            if player then
                prop_hunt.enter(player, player:get_meta():get_string("prop_hunt:node"))
            end
        end)
    end
end)

if core.get_modpath("wielded_light") then
    wielded_light.register_player_lightstep(function(player)
        local name = player:get_player_name()
        wielded_light.track_user_entity(player, "prop_hunt", nil)
        if players[name] then
            local node = player:get_meta():get_string("prop_hunt:node")
            if (core.registered_nodes[node].light_source or 0) > 0 then
                wielded_light.track_user_entity(player, "prop_hunt", node)
            end
        end
    end)
end