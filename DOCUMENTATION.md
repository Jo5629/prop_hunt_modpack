# Prop Hunt API Documentation

- `prop_hunt.enter(player, node, pos)`
  - `player` is an `ObjectRef`.
  - `node` could be a valid node name or what can be returned by `core.get_node(pos)`.
  - `pos` is a vector.
  - Makes a player turn into a node defined by `node`.
- `prop_hunt.exit(player)`
  - `player` is an `ObjectRef`.
  - Player will leave the node form.
- `prop_hunt.snap(player)`
  - `player` is an `ObjectRef`.
  - Snaps the player to the nearest node position and rotates them.
- `prop_hunt.reset_model(player)`
  - `player` is an `ObjectRef`.
  - Resets the player's model from the node back into the player.
  - Mainly to be overridden if other mods that can change the player's model as well are in place.

## Prop Hunt Arena_lib API

Properties in the `prop_hunt` minigame:

- `ENABLED_NOISEMAKER` - boolean.
- `TIMER_NOISEMAKER` - float. Interval between when a noisemaker alerting the hunters should go off.
- `ENABLED_RADAR` - boolean.
- `RADAR_DISTANCE` - float.
- `RADAR_COOLDOWN` - float.
- `ENABLED_STUN` - boolean.
- `STUN_RADIUS` - float.
- `STUN_COOLDOWN` - float.
- `STUN_FROZEN` - float. How long a hunter is stunned for.

Functions below are exclusive to the `prop_hunt_arenalib` mod.

- `prop_hunt.is_frozen(player, arena)`
  - Returns a boolean.
  - `player` is an `ObjectRef`.
  - `arena` is an arena defined by `arena_lib`.
  - Checks if `player` in `arena` is frozen.
- `prop_hunt.freeze(player, arena, pos)`
  - Freezes a `player` in `arena` at `pos`.
  - If `pos` is `nil`, it defaults to the player's current position.
- `prop_hunt.unfreeze(player, arena)`
  - Unfreezes a `player` at `arena`.
- `prop_hunt.update_wear.find_item(pinv, item)`
  - Returns `pos, stack`.
  - `pinv` is an `InvRef`.
  - `item` is a valid item name.
  - Finds `item` in list `main` of `pinv`.
- `prop_hunt.update_wear.start_update(pname, item, step, down, finish_callback, cancel_callback)`
  - `step` is an integer. It is how long the wear should be updated per second.
  - `down` is a boolean. Whether or not the wear of `item` should go up or down.
  - `finish_callback` is a function. Called when the wear is fully over.
  - `cancel_callback` is a function. Called when the wear function is canceled.
  - Updates wear of `item` in the inventory of `pname`.
- `prop_hunt.update_wear.cancel_player_updates(pname)`
  - Cancels wear updates of `pname`.
