-- concreted/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("concreted")

-- Checking for optional mods

local have_angledstairs  = minetest.get_modpath("angledstairs")
local have_angledwalls 	 = minetest.get_modpath("angledwalls")
local have_bucket_wooden = minetest.get_modpath("bucket_wooden")
local have_i3 			 = minetest.get_modpath("i3")
local have_moreblocks 	 = minetest.get_modpath("moreblocks")
local have_pillars		 = minetest.get_modpath("pillars")
local have_pkarcs 		 = minetest.get_modpath("pkarcs")
local have_stainedglass  = minetest.get_modpath("stainedglass")
local have_stoneworks 	 = minetest.get_modpath("stoneworks")

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

	-- Concrete Slabs

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

	-- More Blocks

	if have_moreblocks then
		stairsplus:register_custom_subset(stairsplus_subset, "concreted", name .. "_concrete", "concreted:" .. name .. "_concrete", {
			description = desc .. " Concrete",
			tiles = {"concreted_" .. name .. ".png"},
			groups = {cracky = 2},
			sounds = default.node_sound_stone_defaults(),
		})
	end

	-- Angled Walls

	if have_angledwalls then
		angledglass.register_glass(
			"_" .. name .. "_concrete_glass",
			"concreted:" .. name .. "_concrete",
			{cracky = 2, oddly_breakable_by_hand = 1},
			{"default_glass.png", "concreted_" .. name .. ".png"},
			S("@1 Glass", S("@1 Concrete", S(desc))),
			default.node_sound_glass_defaults()
		)

		angledglass.register_glass(
			"_" .. name .. "_concrete_obsidian_glass",
			"concreted:" .. name .. "_concrete",
			{cracky = 2, oddly_breakable_by_hand = 1},
			{"default_obsidian_glass.png", "concreted_" .. name .. ".png"},
			S("@1 Obsidian Glass", S("@1 Concrete", S(desc))),
			default.node_sound_glass_defaults()
		)

		if have_stainedglass then
			for j = 1, #dyes do
				local glass_color_name, glass_color_desc = unpack(dyes[j])

				angledglass.register_glass(
					"_" .. name .. "_concrete_with_" .. glass_color_name .. "_glass",
					"concreted:" .. name .. "_concrete",
					{cracky = 2, oddly_breakable_by_hand = 1},
					{"stainedglass_" .. glass_color_name .. ".png", "stainedglass_detail_" .. glass_color_name .. ".png", "concreted_" .. name .. ".png"},
					S("@1 @2 Glass", S("@1 Concrete", S(desc)), S(glass_color_desc)),
					default.node_sound_glass_defaults()
				)
			end
		end

		angledwalls.register_angled_wall_and_low_angled_wall_and_corner(
			"_" .. name .. "_concrete",
			"concreted:" .. name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. name .. ".png"},
			S("@1 Angled Wall", S("@1 Concrete", S(desc))),
			S("@1 Low Angled Wall", S("@1 Concrete", S(desc))),
			S("@1 Corner", S("@1 Concrete", S(desc))),
			default.node_sound_stone_defaults()
		)

		slopedwalls.register_sloped_wall(
			"_" .. name .. "_concrete",
			"concreted:" .. name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. name .. ".png"},
			S("@1 Sloped Wall", S("@1 Concrete", S(desc))),
			default.node_sound_stone_defaults()
		)
	end

	-- Simple Arcs

	if have_pkarcs then
		pkarcs.register_all(
			name .. "_concrete",
			desc .. " Concrete",
			{"concreted_" .. name .. ".png"},
			default.node_sound_stone_defaults(),
			{cracky = 2},
			"concreted:" .. name .. "_concrete"
		)
	end

	if have_angledstairs then
		angledstairs.register_angled_stair_and_angled_slab(
			"_" .. name .. "_concrete",
			"concreted:" .. name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. name .. ".png"},
			S("@1 Angled Stair", S("@1 Concrete", S(desc))),
			S("@1 Angled Slab", S("@1 Concrete", S(desc))),
			default.node_sound_stone_defaults()
		)
	end

	-- Stoneworks

	if have_stoneworks then
		stoneworks.register_arches_and_thin_wall(
			"_" .. name .. "_concrete",
			"concreted:" .. name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. name .. ".png"},
			S("@1 Arches", S("@1 Concrete", S(desc))),
			S("@1 Thin Wall", S("@1 Concrete", S(desc))),
			default.node_sound_stone_defaults()
		)
	end

	-- Pillars

	if have_pillars then
		pillars.register_pillar(name .. "_concrete", {
			basenode = "concreted:" .. name .. "_concrete",
			description = S("@1 Pillar", S("@1 Concrete", S(desc))),
			groups = {cracky = 2},
			sounds = default.node_sound_stone_defaults(),
			sunlight_propagates = true,
			textures = {"concreted_" .. name .. ".png"},
		})
	end

	if name ~= "black" then
		table.insert(concrete_list, name .. "_concrete")
	end
end

-- i3 Compression

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

	if have_angledwalls then
		i3.compress("angledglass:glass_black_concrete_glass", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("angledglass:glass_black_concrete_obsidian_glass", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("angledwalls:angled_wall_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("angledwalls:low_angled_wall_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("angledwalls:corner_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("slopedwalls:sloped_wall_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})
	end

	if have_pkarcs then
		i3.compress("pkarcs:black_concrete_arc", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("pkarcs:black_concrete_outer_arc", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("pkarcs:black_concrete_inner_arc", {
			replace = "black_concrete",
			by = concrete_list
		})
	end

	if have_angledstairs then
		i3.compress("angledstairs:angled_stair_right_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("angledstairs:angled_stair_left_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("angledstairs:angled_slab_right_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("angledstairs:angled_slab_left_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})
	end

	if have_stoneworks then
		i3.compress("stoneworks:arches_low_wall_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_high_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_low_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_high_quad_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_low_quad_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_high_T_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_low_T_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_high_corner_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:arches_low_corner_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_high_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_low_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_high_corner_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_low_corner_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_high_T_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_high_low_T_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_low_T_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_high_quad_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_high_low_quad_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_low_quad_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_high_arch_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})

		i3.compress("stoneworks:thin_wall_low_arch_black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})
	end

	if have_pillars then
		i3.compress("pillars:black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})
	end
end

-- i3 Compression for Angled Walls combined with Stained Glass

table.insert(concrete_list, "black_concrete")

if have_angledwalls and have_i3 and have_stainedglass then
	local glass_colors = {}
	for i = 1, #dyes do
		if dyes[i][1] ~= "black" then
			table.insert(glass_colors, dyes[i][1] .. "_glass")
		end
	end

	for i = 1, #concrete_list do
		i3.compress("angledglass:glass_" .. concrete_list[i] .. "_with_black_glass", {
			replace = "black_glass",
			by = glass_colors
		})
	end
end

-- i3 Compression for More Blocks nodes

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
