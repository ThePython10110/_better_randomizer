# Better Randomizer
A randomizer that is better than other randomizers.

Can randomize node drops, entity drops, and crafting recipes (including furnace recipes!).

## KNOWN ISSUES:
Things that break multiple nodes when they are broken (bamboo, beds, doors, kelp, scaffolding, tall flowers, etc.) do not act correctly, sometimes dropping the normal drop.

Sweet berries, shulker boxes, and sheep (and probably other things) don't drop items the normal way, and are therefore not randomized.

Living coral blocks can cause an error if they don't drop a placeable node (line 310 of mineclone2/mods/ITEMS/mcl_ocean/corals.lua), so their drops are not randomized.

For SOME REASON, certain recipes will not randomize.