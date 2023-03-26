-- concreted/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("concreted")

local dyes = dye.dyes

local substrings = {}


for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	-- Concrete blocks

	minetest.register_node("concreted:" .. name .. "_concrete", {
		description = S("@1 Concrete", S(desc)),
		tiles = {"concreted_" .. name .. ".png"},
		is_ground_content = false,
		groups = {cracky = 2, concrete = 1},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft{
		type = "shaped",
		output = "concreted:" .. name .. "_concrete 6",
        recipe = {
            {"group:sand", "group:sand", "group:sand"},
            {"group:dye,color_" .. name, "bucket:bucket_water", "group:dye,color_" .. name},
            {"default:gravel", "default:gravel", "default:gravel"}
        },
		replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
	}

	minetest.register_craft{
		type = "shaped",
		output = "concreted:" .. name .. "_concrete 6",
        recipe = {
            {"group:sand", "group:sand", "group:sand"},
            {"group:dye,color_" .. name, "bucket:bucket_river_water", "group:dye,color_" .. name},
            {"default:gravel", "default:gravel", "default:gravel"}
        },
		replacements = {{"bucket:bucket_river_water", "bucket:bucket_empty"}}
	}

	-- Concrete slabs

	stairs.register_slab(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3, concrete = 1},
		{"concreted_" .. name .. ".png"},
		S("@1 Slab", S("@1 Concrete",  S(desc))),
		default.node_sound_stone_defaults(),
		false
	)

	-- Concrete Stairs

	stairs.register_stair(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3, concrete = 1},
		{"concreted_" .. name .. ".png"},
		S("@1 Stair", S("@1 Concrete", S(desc))),
		default.node_sound_stone_defaults(),
		false
	)

	stairs.register_stair_inner(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3, concrete = 1},
		{"concreted_" .. name .. ".png"},
		"",
		default.node_sound_stone_defaults(),
		false,
		S("Inner @1", S("@1 Stair", S("@1 Concrete", S(desc))))
	)

	stairs.register_stair_outer(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3, concrete = 1},
		{"concreted_" .. name .. ".png"},
		"",
		default.node_sound_stone_defaults(),
		false,
		S("Outer @1", S("@1 Stair", S("@1 Concrete", S(desc))))
	)

	-- Concrete Walls

	walls.register("concreted:" .. name .. "_concrete_wall",
		S("@1 Wall", S("@1 Concrete", S(desc))),
		"concreted_" .. name .. ".png",
		"concreted:" .. name .. "_concrete",
		default.node_sound_stone_defaults()
	)

	if name ~= "black" then
		table.insert(substrings, name .. "_concrete")
	end
end

if minetest.get_modpath("i3") then
	i3.compress("concreted:black_concrete", {
		replace = "black_concrete",
		by = substrings
	})

	table.insert(substrings, "black_concrete")

	i3.compress("stairs:stair_inner_wood", {
		replace = "wood",
		by = substrings
	})

	i3.compress("stairs:slab_wood", {
		replace = "wood",
		by = substrings
	})

	i3.compress("stairs:stair_wood", {
		replace = "wood",
		by = substrings
	})

	i3.compress("stairs:stair_outer_wood", {
		replace = "wood",
		by = substrings
	})

	for i = 1, #substrings do
		substrings[i] = "concreted:" .. substrings[i] .. "_wall"
	end

	i3.compress("walls:cobble", {
		replace = "walls:cobble",
		by = substrings
	})
end
