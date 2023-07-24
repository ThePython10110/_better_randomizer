# Better Randomizer \[_better_randomizer\]
A Minetest randomizer that is better than other randomizers.


It should work with most (if not all) games. I've done most of my testing on MineClone2, with some in Minetest Game. This mod randomizes node drops, entity drops, and crafting recipes (including furnace recipes!). Randomness persists over server restarts, so unless you re-randomize things, everything will stay the same.


The underscore at the beginning of the name is based on something I saw in the \_mcl\_autogroup mod, and I'm hoping that it loads... equally last.


Dependencies: None. License: GPLv3+


You can choose whether you want to randomize node drops, entity drops, and crafting recipes in the settings. The settings only apply the FIRST TIME the mod is loaded in a world. If you want to randomize things after that, use chat commands.


This is copied from `settingtypes.txt`, for anyone who wants to do things through `minetest.conf` instead of the UI:
```
better_randomizer_randomize_crafts (Randomize Crafts) bool true
better_randomizer_randomize_node_drops (Randomize Node Drops) bool true
better_randomizer_randomize_entity_drops (Randomize Entity Drops) bool true
```

### Links:
[GitHub](https://github.com/ThePython10110/_better_randomizer)

[Bug reports/feature requests](https://github.com/ThePython10110/_better_randomizer/issues)

[Forum](https://forum.minetest.net/viewtopic.php?f=9&t=29662)

[ContentDB](https/content.minetest.net/ThePython/packages/_better_randomizer)

### Chat commands:
*All commands require the `server` privilege.*

`/randomize_node_drops`: Randomizes node drops after the next restart.

`/randomize_entity_drops`: Randomizes entity drops without requiring a restart.

`/randomize_crafts`: Randomizes crafting recipes, without requiring a restart.

`/toggle_node_drop_randomization`: Toggles node drop randomization after the next restart. Drops are *not re-randomized* when toggling randomness.

`/toggle_entity_drop_randomization`: Toggles entity drop randomization without requiring a restart. Drops are *not re-randomized* when toggling randomness.

`/toggle_craft_randomization`: Toggles crafting randomization without requiring a restart. Recipes are *not re-randomized* when toggling randomness.

### KNOWN ISSUES:
Things that break multiple nodes when they are broken (bamboo, beds, doors, kelp, scaffolding, tall flowers, etc.) do not act correctly, sometimes dropping the normal drop.

Nodes with multiple states (doors, redstone/mesecons, cake, etc.) generally drop different things based on the state, since each state is a separate node.

Sweet berries, shulker boxes, and sheep (and several things that don't start with S) don't drop items the normal way, and therefore can't be randomized without a lot of extra work.

Living coral blocks can cause an error if they don't drop a placeable node (line 310 of mineclone2/mods/ITEMS/mcl_ocean/corals.lua), so their drops are not randomized.

Since the furnace recipes are random, mobs dying to fire will not drop cooked meat, but instead the result of cooking meat. I'm probably not going to change this, since it isn't really a *bug*. 