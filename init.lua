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

-- Checking mod settings

local enable_extended_compatibilities = minetest.settings:get_bool("enable_extended_compatibilities")

-- Local tables
local angledglass_nodes_extended = {}
local concrete_list = {}
local dyes = dye.dyes
local glass_list = {}
local moreblocks_nodes = {}
local moreblocks_nodes_extended = {}
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
local stoneworks_nodes = {}
local stoneworks_subset = {
	"arches_high",
	"arches_low",
	"arches_high_corner",
	"arches_high_quad",
	"arches_high_T",
	"arches_low_corner",
	"arches_low_quad",
	"arches_low_T",
	"arches_low_wall",
	--[["thin_wall_high",
	"thin_wall_low",
	"thin_wall_high_arch",
	"thin_wall_high_corner",
	"thin_wall_high_quad",
	"thin_wall_high_low_quad",
	"thin_wall_high_low_T",
	"thin_wall_high_T",
	"thin_wall_low_arch",
	"thin_wall_low_corner",
	"thin_wall_low_quad",
	"thin_wall_low_T"]]--
}
local water_containers = {
	{"bucket:bucket_empty", "bucket:bucket_water"},
	{"bucket:bucket_empty", "bucket:bucket_river_water"}
}

if have_bucket_wooden then
	table.insert(water_containers, {"bucket_wooden:bucket_empty", "bucket_wooden:bucket_water"})
	table.insert(water_containers, {"bucket_wooden:bucket_empty", "bucket_wooden:bucket_river_water"})
end

-- Dye loop

for i = 1, #dyes do
	local concrete_color_name, concrete_color_desc = unpack(dyes[i])

	-- Registering nodes

	minetest.register_node("concreted:" .. concrete_color_name .. "_concrete", {
		description = S("@1 Concrete", S(concrete_color_desc)),
		is_ground_content = false,
		groups = {cracky = 2},
		sounds = default.node_sound_stone_defaults(),
		tiles = {"concreted_" .. concrete_color_name .. ".png"},
	})

	-- Water containers loop

	for j = 1, #water_containers do
		local empty_container, water_container = unpack(water_containers[j])

		-- Registering crafts

		minetest.register_craft({
			output = "concreted:" .. concrete_color_name .. "_concrete 6",
			recipe = {
				{"group:sand", "group:sand", "group:sand"},
				{"dye:" .. concrete_color_name, water_container, "dye:" .. concrete_color_name},
				{"default:gravel", "default:gravel", "default:gravel"}
			},
			replacements = {{water_container, empty_container}},
			type = "shaped",
		})
	end

	-- Angled Stairs

	if have_angledstairs then
		angledstairs.register_angled_stair_and_angled_slab(
			"_" .. concrete_color_name .. "_concrete",
			"concreted:" .. concrete_color_name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. concrete_color_name .. ".png"},
			S("@1 Angled Stair", S("@1 Concrete", S(concrete_color_desc))),
			S("@1 Angled Slab", S("@1 Concrete", S(concrete_color_desc))),
			default.node_sound_stone_defaults()
		)
	end

	-- Angled Walls

	if have_angledwalls then
		angledglass.register_glass(
			"_" .. concrete_color_name .. "_concrete_glass",
			"concreted:" .. concrete_color_name .. "_concrete",
			{cracky = 2, oddly_breakable_by_hand = 1},
			{"default_glass.png", "concreted_" .. concrete_color_name .. ".png"},
			S("@1 With Glass", S("@1 Concrete", S(concrete_color_desc))),
			default.node_sound_glass_defaults()
		)

		angledglass.register_glass(
			"_" .. concrete_color_name .. "_concrete_obsidian_glass",
			"concreted:" .. concrete_color_name .. "_concrete",
			{cracky = 2, oddly_breakable_by_hand = 1},
			{"default_obsidian_glass.png", "concreted_" .. concrete_color_name .. ".png"},
			S("@1 Obsidian Glass", S("@1 Concrete", S(concrete_color_desc))),
			default.node_sound_glass_defaults()
		)

		angledwalls.register_angled_wall_and_low_angled_wall_and_corner(
			"_" .. concrete_color_name .. "_concrete",
			"concreted:" .. concrete_color_name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. concrete_color_name .. ".png"},
			S("@1 Angled Wall", S("@1 Concrete", S(concrete_color_desc))),
			S("@1 Low Angled Wall", S("@1 Concrete", S(concrete_color_desc))),
			S("@1 Corner", S("@1 Concrete", S(concrete_color_desc))),
			default.node_sound_stone_defaults()
		)

		slopedwalls.register_sloped_wall(
			"_" .. concrete_color_name .. "_concrete",
			"concreted:" .. concrete_color_name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. concrete_color_name .. ".png"},
			S("@1 Sloped Wall", S("@1 Concrete", S(concrete_color_desc))),
			default.node_sound_stone_defaults()
		)
	end

	-- Mese Posts
	default.register_mesepost(
		"concreted:mese_post_light_" .. concrete_color_name .. "_concrete",
		{
			description = S("@1 Mese Post Light", S("@1 Concrete", S(concrete_color_desc))),
			material = "concreted:" .. concrete_color_name .. "_concrete",
			texture = "concreted_" .. concrete_color_name .. ".png"
		}
	)

	minetest.override_item(
		"concreted:mese_post_light_" .. concrete_color_name .. "_concrete",
		{
			groups = {cracky = 3, oddly_breakable_by_hand = 2},
			sounds = default.node_sound_stone_defaults()
		}
	)

	-- More Blocks

	if have_moreblocks then
		stairsplus:register_custom_subset(
			stairsplus_subset,
			"concreted",
			concrete_color_name .. "_concrete",
			"concreted:" .. concrete_color_name .. "_concrete",
			{
				description = S("@1 Concrete", S(concrete_color_desc)),
				groups = {cracky = 2},
				sounds = default.node_sound_stone_defaults(),
				tiles = {"concreted_" .. concrete_color_name .. ".png"},
			}
		)
	end

	-- Pillars

	if have_pillars then
		pillars.register_pillar(
			concrete_color_name .. "_concrete",
			{
				basenode = "concreted:" .. concrete_color_name .. "_concrete",
				description = S("@1 Pillar", S("@1 Concrete", S(concrete_color_desc))),
				groups = {cracky = 2},
				sounds = default.node_sound_stone_defaults(),
				sunlight_propagates = true,
				textures = {"concreted_" .. concrete_color_name .. ".png"},
			}
		)
	end

	-- Simple Arcs

	if have_pkarcs then
		pkarcs.register_all(
			concrete_color_name .. "_concrete",
			S("@1 Concrete", S(concrete_color_desc)),
			{"concreted_" .. concrete_color_name .. ".png"},
			default.node_sound_stone_defaults(),
			{cracky = 2},
			"concreted:" .. concrete_color_name .. "_concrete"
		)
	end

	-- Stained Glass (Extension with Angled Walls for each concrete and glass colors)

	if have_angledwalls and have_stainedglass and enable_extended_compatibilities then
		for j = 1, #dyes do
			local glass_color_name, glass_color_desc = unpack(dyes[j])

			angledglass.register_glass(
				"_" .. concrete_color_name .. "_concrete_with_" .. glass_color_name .. "_glass",
				"concreted:" .. concrete_color_name .. "_concrete",
				{cracky = 2, oddly_breakable_by_hand = 1},
				{
					"stainedglass_" .. glass_color_name .. ".png",
					"stainedglass_detail_" .. glass_color_name .. ".png",
					"concreted_" .. concrete_color_name .. ".png"
				},
				S("@1 With @2 Glass", S("@1 Concrete", S(concrete_color_desc)), S(glass_color_desc)),
				default.node_sound_glass_defaults()
			)
		end
	end

	-- Stairs

	stairs.register_stair_and_slab(
		concrete_color_name .. "_concrete",
		"concreted:" .. concrete_color_name .. "_concrete",
		{cracky = 2},
		{"concreted_" .. concrete_color_name .. ".png"},
		S("@1 Stair", S("@1 Concrete", S(concrete_color_desc))),
		S("@1 Slab", S("@1 Concrete",  S(concrete_color_desc))),
		default.node_sound_stone_defaults(),
		false,
		S("Inner @1", S("@1 Stair", S("@1 Concrete", S(concrete_color_desc)))),
		S("Outer @1", S("@1 Stair", S("@1 Concrete", S(concrete_color_desc))))
	)

	-- Stoneworks

	if have_stoneworks then
		stoneworks.register_arches(
			"_" .. concrete_color_name .. "_concrete",
			"concreted:" .. concrete_color_name .. "_concrete",
			{cracky = 2},
			{"concreted_" .. concrete_color_name .. ".png"},
			S("@1 Arches", S("@1 Concrete", S(concrete_color_desc))),
			default.node_sound_stone_defaults()
		)
	end

	-- Walls

	walls.register(
		"concreted:" .. concrete_color_name .. "_concrete_wall",
		S("@1 Wall", S("@1 Concrete", S(concrete_color_desc))),
		"concreted_" .. concrete_color_name .. ".png",
		"concreted:" .. concrete_color_name .. "_concrete",
		default.node_sound_stone_defaults()
	)

	if concrete_color_name ~= "black" then
		table.insert(concrete_list, concrete_color_name .. "_concrete")
	end
end

-- Extended compatibilities nodes (for each glass color)

if have_stainedglass and enable_extended_compatibilities then

	for i = 1, #dyes do
		local glass_color_name, glass_color_desc = unpack(dyes[i])

		if have_angledstairs then
			angledstairs.register_angled_stair_and_angled_slab(
				"_" .. glass_color_name .. "_glass",
				"stainedglass:stained_glass_" .. glass_color_name,
				{cracky = 2},
				{
					"stainedglass_" .. glass_color_name .. ".png",
					"stainedglass_detail_" .. glass_color_name .. ".png"
				},
				S("@1 Glass Angled Stair", S(glass_color_desc)),
				S("@1 Glass Angled Slab", S(glass_color_desc)),
				default.node_sound_glass_defaults()
			)
		end

		if have_angledwalls then
			angledwalls.register_angled_wall_and_low_angled_wall_and_corner(
				"_" .. glass_color_name .. "_glass",
				"stainedglass:stained_glass_" .. glass_color_name,
				{cracky = 2},
				{
					"stainedglass_" .. glass_color_name .. ".png",
					"stainedglass_detail_" .. glass_color_name .. ".png"
				},
				S("@1 Glass Angled Wall", S(glass_color_desc)),
				S("@1 Glass Low Angled Wall", S(glass_color_desc)),
				S("@1 Glass Corner", S(glass_color_desc)),
				default.node_sound_glass_defaults()
			)
		end

		if have_moreblocks then
			stairsplus:register_custom_subset(
				stairsplus_subset,
				"stainedglass",
				glass_color_name .. "_glass",
				"stainedglass:stained_glass" .. glass_color_name,
				{
					description = S("@1 Glass", S(glass_color_desc)),
					groups = {cracky = 2,oddly_breakable_by_hand = 1},
					sounds = default.node_sound_glass_defaults(),
					tiles = {
						"stainedglass_" .. glass_color_name .. ".png",
						"stainedglass_detail_" ..  glass_color_name .. ".png"
					},
				}
			)
		end

		if glass_color_name ~= "black" then
			table.insert(glass_list, glass_color_name .. "_glass")
		end
	end
end

-- i3 compression

if have_i3 then

	-- Angled Stairs

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

	-- Angled Walls

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

	-- Concretes

	i3.compress("concreted:black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	-- Mese Posts

	i3.compress("concreted:mese_post_light_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	-- Pillars

	if have_pillars then
		i3.compress("pillars:black_concrete", {
			replace = "black_concrete",
			by = concrete_list
		})
	end

	-- Simple Arcs

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

	-- Slabs

	i3.compress("stairs:slab_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	-- Stairs

	i3.compress("stairs:stair_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	-- Stairs (Inner)

	i3.compress("stairs:stair_inner_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	-- Stairs (Outer)

	i3.compress("stairs:stair_outer_black_concrete", {
		replace = "black_concrete",
		by = concrete_list
	})

	-- Walls

	i3.compress("concreted:black_concrete_wall", {
		replace = "black_concrete",
		by = concrete_list
	})

	if have_angledwalls and have_stainedglass and enable_extended_compatibilities then
		i3.compress("angledstairs:angled_slab_left_black_glass", {
			replace = "black_glass",
			by = glass_list
		})

		i3.compress("angledstairs:angled_slab_right_black_glass", {
			replace = "black_glass",
			by = glass_list
		})

		i3.compress("angledstairs:angled_stair_left_black_glass", {
			replace = "black_glass",
			by = glass_list
		})

		i3.compress("angledstairs:angled_stair_right_black_glass", {
			replace = "black_glass",
			by = glass_list
		})

		i3.compress("angledwalls:angled_wall_black_glass", {
			replace = "black_glass",
			by = glass_list
		})

		i3.compress("angledwalls:corner_black_glass", {
			replace = "black_glass",
			by = glass_list
		})

		i3.compress("angledwalls:low_angled_wall_black_glass", {
			replace = "black_glass",
			by = glass_list
		})
	end

	table.insert(concrete_list, "black_concrete")
	table.insert(glass_list, "black_glass")

	-- More Blocks

	if have_moreblocks then
		for i = 1, #concrete_list do
			local concrete = concrete_list[i]

			moreblocks_nodes[concrete] = {}

			for _, shape in ipairs(stairsplus_subset) do
				if shape[1] ~= "slope" or shape[2] ~= "" then
					table.insert(moreblocks_nodes[concrete], shape[1] .. "_" .. concrete .. shape[2])
				end
			end

			local slope_name = "slope_" .. concrete

			i3.compress("concreted:" .. slope_name, {
				replace = slope_name,
				by = moreblocks_nodes[concrete],
			})
		end

		for i = 1, #glass_list do
			local glass = glass_list[i]

			moreblocks_nodes_extended[glass] = {}

			for _, shape in ipairs(stairsplus_subset) do
				if shape[1] ~= "slope" or shape[2] ~= "" then
					table.insert(
						moreblocks_nodes_extended[glass],
						shape[1] .. "_" .. glass .. shape[2]
					)
				end
			end

			local slope_name = "slope_" .. glass

			i3.compress("stainedglass:" .. slope_name, {
				replace = slope_name,
				by = moreblocks_nodes_extended[glass]
			})
		end
	end

	-- Stoneworks

	if have_stoneworks then
		for i = 1, #concrete_list do
			local concrete = concrete_list[i]

			stoneworks_nodes[concrete] = {}

			for j = 1, #stoneworks_subset do
				if stoneworks_subset[j] ~= "arches_high" then
					table.insert(stoneworks_nodes[concrete], stoneworks_subset[j] .. "_" .. concrete)
				end
			end

			local arches_high_name = "arches_high_" .. concrete

			i3.compress("stoneworks:" .. arches_high_name, {
				replace = arches_high_name,
				by = stoneworks_nodes[concrete]
			})
		end
	end
end
