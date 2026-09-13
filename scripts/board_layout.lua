local config = require "scripts.config"

local M = {}

function M.get_slot_count()
	return config.params.slots_count
end

function M.get_peg_row_count()
	return M.get_slot_count() - 1
end

function M.get_horizontal_spacing()
	return config.params.spacing
end

function M.validate_slot_index(slot_index)
	assert(type(slot_index) == "number" and slot_index == math.floor(slot_index),
		"slot_index must be an integer")
	assert(slot_index >= 1 and slot_index <= M.get_slot_count(), "slot_index is out of range")
	return slot_index
end

function M.validate_peg_row(row)
	assert(type(row) == "number" and row == math.floor(row), "peg row must be an integer")
	assert(row >= 1 and row <= M.get_peg_row_count(), "peg row is out of range")
	return row
end

function M.get_triangle_height()
	return (M.get_peg_row_count() - 1) * M.get_horizontal_spacing()
end

function M.get_peg_position(origin, row, column)
	row = M.validate_peg_row(row)
	assert(type(column) == "number" and column == math.floor(column) and column >= 1 and column <= row,
		"peg column must be an integer within its row")

	local spacing = M.get_horizontal_spacing()
	local top_y = origin.y + config.params.peg_layout_offset_y + M.get_triangle_height() * 0.5
	local first_x = origin.x - (row - 1) * spacing * 0.5
	return vmath.vector3(
		first_x + (column - 1) * spacing,
		top_y - (row - 1) * spacing,
		origin.z
	)
end

function M.get_slot_x(center_x, slot_index)
	slot_index = M.validate_slot_index(slot_index)
	local first_x = center_x - (M.get_slot_count() - 1) * M.get_horizontal_spacing() * 0.5
	return first_x + (slot_index - 1) * M.get_horizontal_spacing()
end

function M.get_slot_position(origin, slot_index)
	local bottom_peg_y = origin.y + config.params.peg_layout_offset_y - M.get_triangle_height() * 0.5
	return vmath.vector3(
		M.get_slot_x(origin.x, slot_index),
		bottom_peg_y - config.params.slot_offset_from_pegs,
		origin.z
	)
end

function M.get_slot_tier(slot_index)
	slot_index = M.validate_slot_index(slot_index)
	local center = (M.get_slot_count() + 1) * 0.5
	local tier_index = math.floor(math.abs(slot_index - center)) + 1
	return config.params.slot_tiers[math.min(tier_index, #config.params.slot_tiers)]
end

return M
