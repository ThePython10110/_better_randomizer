# Better Randomizer
A Minetest randomizer that is better than other randomizers.

It should work with most (if not all) games. I've done most of my testing on MineClone2, with some in Minetest Game. This mod randomizes node drops, entity drops, and crafting recipes (including furnace recipes!). Randomness persists over server restarts, so unless you re-randomize things, everything will stay the same.

You can choose whether you want to randomize node drops, entity drops, and crafting recipes in the settings. The settings only apply the FIRST TIME the mod is loaded in a world. If you want to randomize things after that, see the Chat Commands.

This is copied from `settingtypes.txt`, for anyone who wants to do things through `minetest.conf` instead of the UI:
```
better_randomizer_randomize_crafts (Randomize Crafts) bool true
better_randomizer_randomize_node_drops (Randomize Node Drops) bool true
better_randomizer_randomize_entity_drops (Randomize Entity Drops) bool true
```

### Chat commands:
*All commands require the `server` privilege.*
`/randomize_crafts`: Randomizes crafting recipes, without requiring a restart.
`/randomize_node_drops`: Randomizes node drops after the next restart.
`/randomize_entity_drops`: Randomizes node drops after the next restart.
`/toggle_craft_randomization`: Toggles crafting randomization without requiring a restart. Recipes are *not re-randomized* when toggling randomness.
`/toggle_node_drop_randomization`: Toggles node drop randomization after the next restart. Drops are *not re-randomized* when toggling randomness.
`/toggle_entity_drop_randomization`: Toggles entity drop randomization after the next restart. Drops are *not re-randomized* when toggling randomness.

### KNOWN ISSUES:
Things that break multiple nodes when they are broken (bamboo, beds, doors, kelp, scaffolding, tall flowers, etc.) do not act correctly, sometimes dropping the normal drop.

Nodes with multiple states (doors, redstone/mesecons, cake, etc.) drop different things based on the state, since each state is a separate node.

Sweet berries, shulker boxes, and sheep (and probably several things that don't start with S) don't drop items the normal way, and therefore can't be randomized without a lot of extra work.

Living coral blocks can cause an error if they don't drop a placeable node (line 310 of mineclone2/mods/ITEMS/mcl_ocean/corals.lua), so their drops are not randomized.