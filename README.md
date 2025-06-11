# Prop Hunt

## Features

This modpack is divided up into two mods:

- `prop_hunt` - The main mod.
- `prop_hunt_arenalib` - Prop Hunt minigame with `arena_lib`.

## Warnings

- Changes and crashes are to be expected.
- Clients prior to 5.12.0-dev will not see the entity. ([5.12.0 Changelog](https://docs.luanti.org/about/changelog/#5110--5120:~:text=Clients%20prior%20to%205.12.0%2Ddev%20cannot%20see%20this%20entity.))
- Not all nodes are "fully" supported.
  - This is because entities do not support multiple collision boxes and selection boxes (which some nodes have).

## Prop Hunt Stick

- Requires the `prop_hunt` privilege.
- Leftclick a node to change into it.
- Shift + leftclick to exit.
- Rightclick to snap to the nearest node.

## Commands

- `/prop_hunt enter <nodename>`
  - Turn into `nodename`.
- `/prop_hunt exit`
  - Turn back into the player.
- `/prop_hunt snap`
  - Snap to the nearest node.

## Developers

See `DOCUMENTATION.md` for the API.
