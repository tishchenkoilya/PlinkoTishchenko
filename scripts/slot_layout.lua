local config = require "scripts.config"

local M = {}

function M.get_slot_count()
	return config.params.slots_count
end

function M.get_peg_row_count()
	return M.get_slot_count() - 1
end

function M.get_slot_width()
	return config.params.spacing
end

function M.get_peg_horizontal_spacing()
	return config.params.spacing
end

function M.get_slot_x(center_x, slot_index)
	local slot_count = M.get_slot_count()
	local first_x = center_x - (slot_count - 1) * M.get_slot_width() * 0.5
	return first_x + (slot_index - 1) * M.get_slot_width()
end

function M.get_slot_tier(slot_index)
	local slot_count = M.get_slot_count()
	assert(slot_index == math.floor(slot_index) and slot_index >= 1 and slot_index <= slot_count,
		"slot_index must be an integer within the board")
	local center = (slot_count + 1) * 0.5
	local value_index = math.floor(math.abs(slot_index - center)) + 1
	return config.params.slot_tiers[math.min(value_index, #config.params.slot_tiers)]
end

return M
