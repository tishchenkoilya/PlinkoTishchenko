local board_layout = require "scripts.board_layout"

local M = {}

local slot_indices_by_id = {}
local peg_rows_by_id = {}

function M.register_slot(slot_id, slot_index)
	slot_indices_by_id[slot_id] = board_layout.validate_slot_index(slot_index)
end

function M.get_slot_index(slot_id)
	local slot_index = slot_indices_by_id[slot_id]
	assert(slot_index, "slot must be registered before getting its index")
	return slot_index
end

function M.register_peg(peg_id, row)
	peg_rows_by_id[peg_id] = board_layout.validate_peg_row(row)
end

function M.get_peg_row(peg_id)
	local row = peg_rows_by_id[peg_id]
	assert(row, "peg must be registered before getting its row")
	return row
end

return M
