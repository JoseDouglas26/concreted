-- concreted/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("concreted")

local have_bucket_wooden = minetest.get_modpath("bucket_wooden")
local have_i3 = minetest.get_modpath("i3")
local have_moreblocks = minetest.get_modpath("moreblocks")

local concrete_list = {}
local dyes = dye.dyes
local stairsplus_subset = {
	{ "micro", "" },
	{ "micro", "_1" },
	{ "micro", "_2" },
	{ "micro", "_4" },
	{ "micro", "_12" },
	{ "micro", "_14" },
	{ "micro", "_15" },
	{ "panel", "" },
	{ "panel", "_1" },
	{ "panel", "_2" },
	{ "panel", "_4" },
	{ "panel", "_12" },
	{ "panel", "_14" },
	{ "panel", "_15" },
	{ "slab",  "_quarter" },
	{ "slab",  "_three_quarter" },
	{ "slab",  "_1" },
	{ "slab",  "_2" },
	{ "slab",  "_14" },
	{ "slab",  "_15" },
	{ "slab",  "_two_sides" },
	{ "slab",  "_three_sides" },
	{ "slab",  "_three_sides_u" },
	{ "slope", "" },
	{ "slope", "_half" },
	{ "slope", "_half_raised" },
	{ "slope", "_inner" },
	{ "slope", "_inner_half" },
	{ "slope", "_inner_half_raised" },
	{ "slope", "_inner_cut" },
	{ "slope", "_inner_cut_half" },
	{ "slope", "_inner_cut_half_raised" },
	{ "slope", "_outer" },
	{ "slope", "_outer_half" },
	{ "slope", "_outer_half_raised" },
	{ "slope", "_outer_cut" },
	{ "slope", "_outer_cut_half" },
	{ "slope", "_outer_cut_half_raised" },
	{ "slope", "_cut" },
	{ "stair", "_half" },
	{ "stair", "_right_half" },
	{ "stair", "_alt" },
	{ "stair", "_alt_1" },
	{ "stair", "_alt_2" },
	{ "stair", "_alt_4" },
}

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	-- Concrete blocks

	minetest.register_node("concreted:" .. name .. "_concrete", {
		description = S("@1 Concrete", S(desc)),
		tiles = {"concreted_" .. name .. ".png"},
		is_ground_content = false,
		groups = {cracky = 2},
		sounds = default.node_sound_stone_defaults(),
	})

	-- For bucket water

	minetest.register_craft({
		type = "shaped",
		output = "concreted:" .. name .. "_concrete 6",
        recipe = {
            {"group:sand", "group:sand", "group:sand"},
            {"group:dye,color_" .. name, "bucket:bucket_water", "group:dye,color_" .. name},
            {"default:gravel", "default:gravel", "default:gravel"}
        },
		replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
	})

	if have_bucket_wooden then
		minetest.register_craft({
			type = "shaped",
			output = "concreted:" .. name .. "_concrete 6",
			recipe = {
				{"group:sand", "group:sand", "group:sand"},
				{"group:dye,color_" .. name, "bucket_wooden:bucket_water", "group:dye,color_" .. name},
				{"default:gravel", "default:gravel", "default:gravel"}
			},
			replacements = {{"bucket_wooden:bucket_water", "bucket_wooden:bucket_empty"}}
		})
	end

	-- For river water

	minetest.register_craft({
		type = "shaped",
		output = "concreted:" .. name .. "_concrete 6",
        recipe = {
            {"group:sand", "group:sand", "group:sand"},
            {"group:dye,color_" .. name, "bucket:bucket_river_water", "group:dye,color_" .. name},
            {"default:gravel", "default:gravel", "default:gravel"}
        },
		replacements = {{"bucket:bucket_river_water", "bucket:bucket_empty"}}
	})

	if have_bucket_wooden then
		minetest.register_craft({
			type = "shaped",
			output = "concreted:" .. name .. "_concrete 6",
			recipe = {
				{"group:sand", "group:sand", "group:sand"},
				{"group:dye,color_" .. name, "bucket_wooden:bucket_river_water", "group:dye,color_" .. name},
				{"default:gravel", "default:gravel", "default:gravel"}
			},
			replacements = {{"bucket_wooden:bucket_river_water", "bucket_wooden:bucket_empty"}}
		})
	end

	-- Concrete slabs

	stairs.register_slab(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3},
		{"concreted_" .. name .. ".png"},
		S("@1 Slab", S("@1 Concrete",  S(desc))),
		default.node_sound_stone_defaults(),
		false
	)

	-- Concrete Stairs

	stairs.register_stair(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3},
		{"concreted_" .. name .. ".png"},
		S("@1 Stair", S("@1 Concrete", S(desc))),
		default.node_sound_stone_defaults(),
		false
	)

	stairs.register_stair_inner(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3},
		{"concreted_" .. name .. ".png"},
		"",
		default.node_sound_stone_defaults(),
		false,
		S("Inner @1", S("@1 Stair", S("@1 Concrete", S(desc))))
	)

	stairs.register_stair_outer(
		name .. "_concrete",
		"concreted:" .. name .. "_concrete",
		{cracky = 3},
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

	--[[if minetest.get_modpath("columnia") then
		columnia.register_column_ia(name .. "_concrete",
			"concreted:" .. name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. name .. ".png"},
			S("@1 Column", S("@1 Concrete", S(desc))),
			S("@1 Top", S("@1 Column", S("@1 Concrete", S(desc)))),
			S("@1 Bottom", S("@1 Column", S("@1 Concrete", S(desc)))),
			S("@1 Crosslink", S("@1 Column", S("@1 Concrete", S(desc)))),
			S("@1 Link", S("@1 Column", S("@1 Concrete", S(desc)))),
			S("@1 Linkdown", S("@1 Column", S("@1 Concrete", S(desc)))),
			default.node_sound_stone_defaults()
		)
	end]]--

	if have_moreblocks then
		stairsplus:register_custom_subset(stairsplus_subset, "concreted", name .. "_concrete", "concreted:" .. name .. "_concrete", {
			description = desc .. " Concrete",
			tiles = {"concreted_" .. name .. ".png"},
			groups = {cracky = 2},
			sounds = default.node_sound_stone_defaults(),
		})
	end

	if name ~= "black" then
		table.insert(concrete_list, name .. "_concrete")
	end
end

if have_i3 then
	i3.compress("concreted:black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	i3.compress("stairs:slab_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	i3.compress("stairs:stair_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	i3.compress("stairs:stair_inner_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	i3.compress("stairs:stair_outer_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	i3.compress("concreted:black_concrete_wall", {
		replace = "black_concrete",
		by = concrete_list
	})
	--[[
	if minetest.get_modpath("columnia") then
		i3.compress("columnia:column_bottom_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("columnia:column_crosslink_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("columnia:column_link_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("columnia:column_linkdown_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("columnia:column_mid_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("columnia:column_top_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})
	end
	]]--
end

table.insert(concrete_list, "black_concrete")

local nodes_table = {}

for i = 1, #concrete_list do
	local nodename = concrete_list[i]

	nodes_table[nodename] = {}

	for _, shape in ipairs(stairsplus_subset) do
		if shape[1] ~= "slope" or shape[2] ~= "" then
			table.insert(nodes_table[nodename], shape[1] .. "_" .. nodename .. shape[2])
		end
	end

	local slope_name = "slope_" .. nodename

	if have_i3 then
		i3.compress("concreted:" .. slope_name, {
			replace = slope_name,
			by = nodes_table[nodename],
		})
	end
end
