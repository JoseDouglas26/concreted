-- concreted/definitions.lua

if minetest.get_modpath("angledstairs") then
    concreted.have_angledstairs = true
    if minetest.settings:get_bool("enable_angledstairs") then
        concreted.enable_angledstairs = true
    else
        concreted.enable_angledstairs = false
    end
else
    concreted.have_angledstairs = false
end

if minetest.get_modpath("angledwalls") then
    concreted.have_angledwalls = true
    if minetest.settings:get_bool("enable_angledwalls") then
        concreted.enable_angledwalls = true
    else
        concreted.enable_angledwalls = false
    end
else
    concreted.have_angledwalls = false
end

if minetest.get_modpath("bucket_wooden") then
    concreted.have_bucket_wooden = true
    if minetest.settings:get_bool("enable_bucket_wooden") then
        concreted.enable_bucket_wooden = true
    else
        concreted.enable_bucket_wooden = false
    end
else
    concreted.have_bucket_wooden = false
end

if minetest.get_modpath("i3") then
    concreted.have_i3 = true
    if minetest.settings:get_bool("enable_compression") then
        concreted.enable_compression = true
    else
        concreted.enable_compression = false
    end
else
    concreted.have_i3 = false
end

if minetest.get_modpath("moreblocks") then
    concreted.have_moreblocks = true
    if minetest.settings:get_bool("enable_moreblocks") then
        concreted.enable_moreblocks = true
    else
        concreted.enable_moreblocks = false
    end
else
    concreted.have_moreblocks = false
end

if minetest.get_modpath("pillars") then
    concreted.have_pillars = true
    if minetest.settings:get_bool("enable_pillars") then
        concreted.enable_pillars = true
    else
        concreted.enable_pillars = false
    end
else
    concreted.have_pillars = false
end

if minetest.get_modpath("pkarcs") then
    concreted.have_pkarcs = true
    if minetest.settings:get_bool("enable_pkarcs") then
        concreted.enable_pkarcs = true
    else
        concreted.enable_pkarcs = false
    end
else
    concreted.have_pkarcs = false
end

if minetest.get_modpath("stainedglass") then
    concreted.have_stainedglass = true
    if minetest.settings:get_bool("enable_extensions") then
        concreted.enable_extensions = true
    else
        concreted.enable_extensions = false
    end
else
    concreted.have_stainedglass = false
end

if minetest.get_modpath("stoneworks") then
    concreted.have_stoneworks = true
    if minetest.settings:get_bool("enable_stoneworks") then
        concreted.enable_stoneworks = true
    else
        concreted.enable_stoneworks = false
    end
else
    concreted.have_stoneworks = false
end

concreted.enable_meseposts = minetest.settings:get_bool("enable_meseposts")
concreted.enable_stairs    = minetest.settings:get_bool("enable_stairs")
concreted.enable_walls     = minetest.settings:get_bool("enable_walls")

concreted.colors = dye.dyes
concreted.concrete_list = {}

if concreted.enable_angledstairs then
    concreted.angledstairs_subset = {
        "angledstairs:angled_slab_left_",
        "angledstairs:angled_slab_right_",
        "angledstairs:angled_stair_left_",
        "angledstairs:angled_stair_right_"
    }
end

if concreted.enable_angledwalls then
    concreted.angledwalls_subset = {
        "angledglass:glass_",
        "angledwalls:angled_wall_",
        "angledwalls:low_angled_wall_",
        "angledwalls:corner_",
        "slopedwalls:sloped_wall_"
    }
end

if concreted.have_stainedglass then
    concreted.glass_list = {}
end

if concreted.enable_moreblocks then
    concreted.stairsplus_subset = {
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
end

if concreted.enable_stoneworks then
    concreted.stoneworks_subset = {
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
end

concreted.water_containers = {
	{"bucket:bucket_empty", "bucket:bucket_water"},
	{"bucket:bucket_empty", "bucket:bucket_river_water"}
}
