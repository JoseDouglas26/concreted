-- concreted/init.lua

concreted = {}

local color_name, color_desc
local path = minetest.get_modpath("concreted")

dofile(path .. "/compatibles.lua")
dofile(path .. "/concrete.lua")
dofile(path .. "/definitions.lua")

if concreted.enable_bucket_wooden then
	table.insert(
		concreted.water_containers,
		{"bucket_wooden:bucket_empty", "bucket_wooden:bucket_water"}
	)

	table.insert(
		concreted.water_containers,
		{"bucket_wooden:bucket_empty", "bucket_wooden:bucket_river_water"}
	)
end

for i = 1, #concreted.colors do
	color_name, color_desc = unpack(concreted.colors[i])

	concreted.register_node(color_name, color_desc)

	if concreted.enable_angledstairs then
		concreted.register_angledstairs(color_name, color_desc)
	end

	if concreted.enable_angledwalls then
		concreted.register_angledwalls(color_name, color_desc)
	end

	if concreted.enable_meseposts then
		concreted.register_mesepost(color_name, color_desc)
	end

	if concreted.enable_moreblocks then
		concreted.register_moreblocks(color_name, color_desc)
	end

	if concreted.enable_pillars then
		concreted.register_pillars(color_name, color_desc)
	end

	if concreted.enable_pkarcs then
		concreted.register_pkarcs(color_name, color_desc)
	end

	if concreted.enable_stairs then
		concreted.register_stair_and_slab(color_name, color_desc)
	end

	if concreted.enable_stoneworks then
		concreted.register_stoneworks(color_name, color_desc)
	end

	if concreted.enable_walls then
		concreted.register_walls(color_name, color_desc)
	end

	if color_name ~= "black" then
		table.insert(concreted.concrete_list, color_name .. "_concrete")
	end
end

if concreted.enable_extensions then
	dofile(path .. "/extensions.lua")
end

if concreted.enable_compression then
	dofile(path .. "/compression.lua")
end
