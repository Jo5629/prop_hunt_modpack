--> Modified from https://gitlab.com/rubenwardy/classroom/-/blob/master/freeze.lua
function prop_hunt.is_frozen(player, arena)
	if arena and arena.frozen then
		return arena.frozen[player:get_player_name()]
	end
	return false
end

core.register_entity(":prop_hunt:freeze", {
	-- This entity needs to be visible otherwise the frozen player won't be visible.
	initial_properties = {
		visual = "sprite",
		visual_size = { x = 0, y = 0 },
		textures = { "blank.png" },
		physical = false, -- Disable collision
		pointable = false, -- Disable selection box
		makes_footstep_sound = false,
	},

    arena = {},
    on_activate = function(self, staticdata, dtime_s)
        if staticdata == "" then
            self.object:remove()
            return
        end

        local _, arena = arena_lib.get_arena_by_name("prop_hunt", staticdata)
        self.arena = arena
    end,

	on_step = function(self, dtime)
		local player = self.pname and core.get_player_by_name(self.pname)
		if not player or not prop_hunt.is_frozen(player, self.arena) then
			self.object:remove()
			return
		end
	end,

	set_frozen_player = function(self, player)
		self.pname = player:get_player_name()
		player:set_attach(self.object, "", {x = 0, y = 0, z = 0 }, { x = 0, y = 0, z = 0 })
	end,
})

function prop_hunt.freeze(player, arena, pos)
	arena.frozen[player:get_player_name()] = true

	local parent = player:get_attach()
	if parent and parent:get_luaentity() and
			parent:get_luaentity().set_frozen_player then
		-- Already attached
		return
	end

	local obj = core.add_entity(pos or player:get_pos(), "prop_hunt:freeze", arena.name)
	obj:get_luaentity():set_frozen_player(player)
end

function prop_hunt.unfreeze(player, arena)
	arena.frozen[player:get_player_name()] = nil

	local pname = player:get_player_name()
	local objects = core.get_objects_inside_radius(player:get_pos(), 2)
	for i=1, #objects do
		local entity = objects[i]:get_luaentity()
		if entity and entity.set_frozen_player and entity.pname == pname then
			objects[i]:remove()
		end
	end
end