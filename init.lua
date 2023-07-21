local storage = minetest.get_mod_storage()
local mineclone = minetest.get_modpath("mcl_core")
local randomize_node_drops = false
local randomize_entity_drops = false
local randomize_crafts = false
if (storage:get_int("randomize_node_drops") == 1) or
(minetest.settings:get_bool("better_randomizer_randomize_node_drops", true) and not storage:get_int("not_first_load")) then
    randomize_node_drops = true
end
if (storage:get_int("randomize_entity_drops") == 1) or
(minetest.settings:get_bool("better_randomizer_randomize_entity_drops", true) and not storage:get_int("not_first_load")) then
    randomize_entity_drops = true
end
if minetest.settings:get_bool("better_randomizer_randomize_crafts", true) and not storage:get_int("not_first_load") then
    randomize_crafts = true
end

storage:set_int("not_first_load", 1)

minetest.log(dump({nodes=randomize_node_drops,entities=randomize_entity_drops,crafts=randomize_crafts}))

better_randomizer = {}

function better_randomizer.load_node_drops()
    if not better_randomizer.random_node_drops then return end
    for i, info in ipairs(better_randomizer.random_node_drops) do
        minetest.log(dump(info))
        if info.name and info.overrides then
            minetest.override_item(info.name, info.overrides)
        end
    end
end

function better_randomizer.load_entity_drops()
    if not better_randomizer.random_entity_drops then return end
    for i, info in ipairs(better_randomizer.random_entity_drops) do
        if info.name and info.drops then
            minetest.registered_entities[info.name].drops = info.drops
        end
    end
end

function better_randomizer.randomize_node_drops()
    storage:set_int("randomize_node_drops", 0)
    local items = {}
    better_randomizer.random_node_drops = {}
    for name, def in pairs(minetest.registered_nodes) do
        if (not def.groups.not_in_creative_inventory) and
        ((def.drop ~= "" and def.drop ~= {}) or def._mcl_silk_touch_drop or def._mcl_shears_drop) then
            table.insert(items, name)
            if not mineclone then
                table.insert(better_randomizer.random_node_drops, {name=name, overrides = {drop = def.drop}})
            else
                local drop = def.drop
                if not drop then drop = name end
                local silk_touch = def._mcl_silk_touch_drop
                if silk_touch == true then silk_touch = name end
                local shears = def._mcl_shears_drop
                if shears == true then shears = name end
                table.insert(better_randomizer.random_node_drops, {name=name, overrides = {
                    drop = drop,
                    _mcl_silk_touch_drop = silk_touch,
                    _mcl_shears_drop = shears,
                    _mcl_fortune_drop = def._mcl_fortune_drop
                }})
            end
        end
    end
    table.shuffle(items)
    for i, name in ipairs(items) do
        better_randomizer.random_node_drops[i].name = name
    end
    storage:set_string("node_drops", minetest.serialize(better_randomizer.random_node_drops))
    better_randomizer.load_node_drops()
end

function better_randomizer.randomize_entity_drops()
    storage:set_int("randomize_entity_drops", 0)
    better_randomizer.random_entity_drops = {}
    local entities = {}
    for name, def in pairs(minetest.registered_entities) do
        if def.drops and def.drops ~= {} then
            table.insert(entities, {name = name})
            table.insert(better_randomizer.random_entity_drops, {name=name, drops=def.drops})
        end
    end
    table.shuffle(better_randomizer.random_entity_drops)
    for i, info in ipairs(entities) do
        better_randomizer.random_entity_drops[i].name = info.name
    end
    storage:set_string("entity_drops", minetest.serialize(better_randomizer.random_entity_drops))
    better_randomizer.load_entity_drops()
end

function better_randomizer.randomize_crafts()
    storage:set_int("randomize_crafts", 0)
    storage:set_int("crafts_randomized", 1)
    for _, type in ipairs({"normal", "cooking"}) do
        table.shuffle(better_randomizer.all_crafts[type])
        local i = 1
        for key, value in pairs(better_randomizer.random_crafts[type]) do
            better_randomizer.random_crafts[type][key] = better_randomizer.all_crafts[type][i]
            i = i + 1
        end
    end
    storage:set_string("crafts", minetest.serialize(better_randomizer.random_crafts))
end

minetest.register_chatcommand("randomize_node_drops", {
    privs = {server = true},
    description = "Sets Better Randomizer to randomize node drops next time it loads. Requires server privilege.",
    func = function()
        storage:set_int("randomize_node_drops", 1)
    end
})

minetest.register_chatcommand("unrandomize_node_drops", {
    privs = {server = true},
    description = "Sets Better Randomizer to unrandomize node drops next time it loads. Requires server privilege.",
    func = function()
        storage:set_int("randomize_node_drops", 0)
        storage:set_string("node_drops", nil)
    end
})

minetest.register_chatcommand("randomize_entity_drops", {
    privs = {server = true},
    description = "Sets Better Randomizer to randomize entity drops next time it loads. Requires server privilege.",
    func = function()
        storage:set_int("randomize_entity_drops", 1)
    end
})

minetest.register_chatcommand("unrandomize_entity_drops", {
    privs = {server = true},
    description = "Sets Better Randomizer to unrandomize entity drops next time it loads. Requires server privilege.",
    func = function()
        storage:set_int("randomize_entity_drops", 0)
        storage:set_string("entity_drops", nil)
    end
})

minetest.register_chatcommand("randomize_crafts", {
    privs = {server = true},
    description = "Randomize crafting recipes. Does not require a restart. Requires server privilege.",
    func = better_randomizer.randomize_crafts
})

minetest.register_chatcommand("unrandomize_crafts", {
    privs = {server = true},
    description = "Unrandomize crafting recipes. Does not require a restart. Requires server privilege.",
    func = function()
        storage:set_int("crafts_randomized", 0)
    end
})

better_randomizer.all_crafts = {normal = {}, cooking = {}}
better_randomizer.random_crafts = {normal = {}, cooking = {}}
for name, def in pairs(minetest.registered_items) do
    local item_crafts = minetest.get_all_craft_recipes(name)
    if item_crafts then
        for _, craft in ipairs(item_crafts) do
            if craft.output ~= "" and (craft.method == "normal" or craft.method == "cooking") then
                better_randomizer.all_crafts[craft.method][#better_randomizer.all_crafts[craft.method]+1] = craft.output
                better_randomizer.random_crafts[craft.method][craft.output] = craft.output
            end
        end
    end
end

for _, craft in pairs({ "craft_predict", "on_craft" }) do
    minetest["register_" .. craft](function(itemstack, player, old_craft_grid, craft_inv)
        if storage:get_int("crafts_randomized") ~= 1 then return end
        if itemstack ~= nil and itemstack ~= ItemStack("") then
            if craft_inv:get_location().type == "player" then
                local itemstring = better_randomizer.random_crafts.normal[itemstack:get_name()]
                if itemstring then return ItemStack(itemstring) else return itemstack end
            elseif craft_inv:get_location().type == "node" and not craft_inv:get_lists().craft then
                minetest.log(dump(craft_inv:get_lists()))
                local itemstring = better_randomizer.random_crafts.normal[itemstack:get_name()]
                if itemstring then return ItemStack(itemstring) else return itemstack end
            else
                minetest.log(dump(craft_inv:get_location()))
            end
        end
    end)
end

if randomize_crafts then
    better_randomizer.randomize_crafts()
else
    better_randomizer.random_crafts = minetest.deserialize(storage:get_string("crafts")) or better_randomizer.random_crafts
end

if randomize_node_drops then
    better_randomizer.randomize_node_drops()
else
    better_randomizer.random_node_drops = minetest.deserialize(storage:get_string("node_drops"))
    better_randomizer.load_node_drops()
end

if randomize_entity_drops then
    better_randomizer.randomize_entity_drops()
else
    better_randomizer.random_entity_drops = minetest.deserialize(storage:get_string("entity_drops"))
    better_randomizer.load_entity_drops()
end