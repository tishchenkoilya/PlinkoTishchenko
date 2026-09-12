local slot_layout = require "scripts.slot_layout"

local M = {}

local slot_indices_by_id = {}
local peg_rows_by_id = {}

local function validate_slot_index(slot_index)
	assert(slot_index == math.floor(slot_index), "slot_index must be an integer")
	assert(slot_index >= 1 and slot_index <= slot_layout.get_slot_count(), "slot_index is out of range")
	return slot_index
end

local function validate_peg_row(row)
	assert(row == math.floor(row), "peg row must be an integer")
	assert(row >= 1 and row <= slot_layout.get_peg_row_count(), "peg row is out of range")
	return row
end

function M.register_slot(slot_id, slot_index)
	slot_indices_by_id[slot_id] = validate_slot_index(slot_index)
end

function M.get_slot_index(slot_id)
	local slot_index = slot_indices_by_id[slot_id]
	assert(slot_index, "slot must be registered before getting its index")
	return slot_index
end

function M.register_peg(peg_id, row)
	peg_rows_by_id[peg_id] = validate_peg_row(row)
end

function M.get_peg_row(peg_id)
	local row = peg_rows_by_id[peg_id]
	assert(row, "peg must be registered before getting its row")
	return row
end

return M
