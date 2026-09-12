local config = require "scripts.config"
local slot_layout = require "scripts.slot_layout"

local M = {}

local SAVE_APPLICATION_ID = "plinko_tishchenko"
local SAVE_FILE_NAME = "game_state"

local balls_count = 0
local score = 0
local regeneration_elapsed = 0
local slot_balls_count = {}
local total_balls_count = 0
local slot_indices_by_id = {}

local function get_regeneration_interval()
	local interval = config.params.ball_regeneration_interval
	assert(interval > 0, "config.params.ball_regeneration_interval must be greater than zero")
	return interval
end

local function normalize_balls_count(count)
	return math.max(0, math.floor(count or 0))
end

local function get_balls_max_count()
	local balls_max_count = normalize_balls_count(config.params.balls_max_count)
	assert(balls_max_count > 0, "config.params.balls_max_count must be greater than zero")
	return balls_max_count
end

local function validate_slot_index(slot_index)
	assert(slot_index == math.floor(slot_index), "slot_index must be an integer")
	assert(slot_index >= 1 and slot_index <= slot_layout.get_slot_count(), "slot_index is out of range")
	return slot_index
end

local function initialize_state(initial_balls_count)
	balls_count = normalize_balls_count(initial_balls_count)
	score = 0
	regeneration_elapsed = 0
	slot_balls_count = {}
	total_balls_count = 0
	for slot_index = 1, slot_layout.get_slot_count() do
		slot_balls_count[slot_index] = 0
	end
end

local function get_save_file_path()
	return sys.get_save_file(SAVE_APPLICATION_ID, SAVE_FILE_NAME)
end

function M.save()
	sys.save(get_save_file_path(), {
		balls_count = balls_count,
		score = score,
		slot_balls_count = slot_balls_count,
		total_balls_count = total_balls_count,
	})
end

function M.load()
	initialize_state(config.params.balls_count)

	local success, saved_state = pcall(sys.load, get_save_file_path())
	if not success then
		print("Failed to load game: " .. tostring(saved_state))
		return false
	end
	if not next(saved_state) then
		return false
	end

	balls_count = normalize_balls_count(saved_state.balls_count or config.params.balls_count)
	score = normalize_balls_count(saved_state.score)

	local saved_slot_balls_count = saved_state.slot_balls_count
	local calculated_total_balls_count = 0
	if type(saved_slot_balls_count) == "table" then
		for slot_index = 1, slot_layout.get_slot_count() do
			local count = normalize_balls_count(saved_slot_balls_count[slot_index])
			slot_balls_count[slot_index] = count
			calculated_total_balls_count = calculated_total_balls_count + count
		end
	end

	if saved_state.total_balls_count == nil then
		total_balls_count = calculated_total_balls_count
	else
		total_balls_count = normalize_balls_count(saved_state.total_balls_count)
	end
	return true
end

function M.reset()
	initialize_state(config.params.balls_count)
	M.save()
end

function M.update(dt)
	local balls_max_count = get_balls_max_count()
	if balls_count >= balls_max_count then
		regeneration_elapsed = 0
		return 0
	end

	regeneration_elapsed = regeneration_elapsed + math.max(0, dt)

	local interval = get_regeneration_interval()
	local elapsed_intervals = math.floor(regeneration_elapsed / interval)
	local regenerated_count = 0
	if elapsed_intervals > 0 then
		local previous_balls_count = balls_count
		balls_count = math.min(balls_count + elapsed_intervals, balls_max_count)
		regenerated_count = balls_count - previous_balls_count
		regeneration_elapsed = regeneration_elapsed - elapsed_intervals * interval
		if balls_count >= balls_max_count then
			regeneration_elapsed = 0
		end
		M.save()
	end

	return regenerated_count
end

function M.get_balls_count()
	return balls_count
end

function M.add_ball()
	balls_count = balls_count + 1
	if balls_count >= get_balls_max_count() then
		regeneration_elapsed = 0
	end
	M.save()
end

function M.get_score()
	return score
end

function M.add_score(value)
	score = score + math.max(0, math.floor(value or 0))
	M.save()
end

function M.register_slot(slot_id, slot_index)
	slot_indices_by_id[slot_id] = validate_slot_index(slot_index)
end

function M.get_slot_balls_count(slot_index)
	return slot_balls_count[validate_slot_index(slot_index)]
end

function M.get_total_balls_count()
	return total_balls_count
end

function M.add_slot_ball(slot_id, count)
	local slot_index = slot_indices_by_id[slot_id]
	assert(slot_index, "slot must be registered before adding a ball")
	count = math.max(1, math.floor(count or 1))
	slot_balls_count[slot_index] = slot_balls_count[slot_index] + count
	total_balls_count = total_balls_count + count
	M.save()
end

function M.get_seconds_until_next_ball()
	if balls_count >= get_balls_max_count() then
		return 0
	end
	return math.ceil(get_regeneration_interval() - regeneration_elapsed)
end

function M.has_enough_balls(count)
	count = normalize_balls_count(count)
	return count > 0 and balls_count >= count
end

function M.try_spend_balls(count)
	count = normalize_balls_count(count)
	if not M.has_enough_balls(count) then
		return false
	end

	local balls_max_count = get_balls_max_count()
	local regeneration_was_paused = balls_count >= balls_max_count
	balls_count = balls_count - count
	if regeneration_was_paused and balls_count < balls_max_count then
		regeneration_elapsed = 0
	end
	M.save()
	return true
end

initialize_state(config.params.balls_count)

return M
