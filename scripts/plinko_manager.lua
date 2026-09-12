local config = require "scripts.config"
local slot_layout = require "scripts.slot_layout"

local M = {}

local Manager = {}
Manager.__index = Manager

local function normalize_count(value, default_value)
	if type(value) ~= "number" or value ~= value then
		return default_value or 0
	end
	return math.max(0, math.floor(value))
end

local function validate_slot_index(slot_index)
	assert(slot_index == math.floor(slot_index), "slot_index must be an integer")
	assert(slot_index >= 1 and slot_index <= slot_layout.get_slot_count(), "slot_index is out of range")
	return slot_index
end

local function copy_slot_counts(source)
	local copy = {}
	for slot_index = 1, slot_layout.get_slot_count() do
		copy[slot_index] = source[slot_index] or 0
	end
	return copy
end

function Manager:_initialize_state()
	self.balls_count = config.params.balls_count
	self.score = 0
	self.regeneration_elapsed = 0
	self.slot_balls_count = {}
	self.total_balls_count = 0
	for slot_index = 1, slot_layout.get_slot_count() do
		self.slot_balls_count[slot_index] = 0
	end
end

function Manager:restore(saved_state)
	self:_initialize_state()
	if type(saved_state) ~= "table" then
		return
	end

	self.balls_count = normalize_count(saved_state.balls_count, config.params.balls_count)
	self.score = normalize_count(saved_state.score)

	local saved_slot_counts = type(saved_state.slot_balls_count) == "table" and saved_state.slot_balls_count or {}
	local calculated_total = 0
	for slot_index = 1, slot_layout.get_slot_count() do
		local count = normalize_count(saved_slot_counts[slot_index])
		self.slot_balls_count[slot_index] = count
		calculated_total = calculated_total + count
	end

	local saved_total = normalize_count(saved_state.total_balls_count, calculated_total)
	self.total_balls_count = saved_total == calculated_total and saved_total or calculated_total
end

function Manager:reset()
	self:_initialize_state()
end

function Manager:update(dt)
	local balls_max_count = config.params.balls_max_count
	if self.balls_count >= balls_max_count then
		self.regeneration_elapsed = 0
		return 0
	end

	self.regeneration_elapsed = self.regeneration_elapsed + math.max(0, dt)
	local elapsed_intervals = math.floor(self.regeneration_elapsed / config.params.ball_regeneration_interval)
	if elapsed_intervals == 0 then
		return 0
	end

	local previous_balls_count = self.balls_count
	self.balls_count = math.min(self.balls_count + elapsed_intervals, balls_max_count)
	local regenerated_count = self.balls_count - previous_balls_count
	self.regeneration_elapsed = self.regeneration_elapsed - elapsed_intervals * config.params.ball_regeneration_interval
	if self.balls_count >= balls_max_count then
		self.regeneration_elapsed = 0
	end
	return regenerated_count
end

function Manager:get_balls_count()
	return self.balls_count
end

function Manager:add_ball()
	self.balls_count = self.balls_count + 1
	if self.balls_count >= config.params.balls_max_count then
		self.regeneration_elapsed = 0
	end
end

function Manager:get_score()
	return self.score
end

function Manager:get_slot_balls_count(slot_index)
	return self.slot_balls_count[validate_slot_index(slot_index)]
end

function Manager:get_total_balls_count()
	return self.total_balls_count
end

function Manager:record_landing(slot_index, count)
	slot_index = validate_slot_index(slot_index)
	count = math.max(1, normalize_count(count, 1))

	local score = slot_layout.get_slot_tier(slot_index).score * count
	self.slot_balls_count[slot_index] = self.slot_balls_count[slot_index] + count
	self.total_balls_count = self.total_balls_count + count
	self.score = self.score + score
	return score
end

function Manager:get_seconds_until_next_ball()
	if self.balls_count >= config.params.balls_max_count then
		return 0
	end
	return math.ceil(config.params.ball_regeneration_interval - self.regeneration_elapsed)
end

function Manager:has_enough_balls(count)
	count = normalize_count(count)
	return count > 0 and self.balls_count >= count
end

function Manager:try_spend_balls(count)
	count = normalize_count(count)
	if not self:has_enough_balls(count) then
		return false
	end

	local regeneration_was_paused = self.balls_count >= config.params.balls_max_count
	self.balls_count = self.balls_count - count
	if regeneration_was_paused and self.balls_count < config.params.balls_max_count then
		self.regeneration_elapsed = 0
	end
	return true
end

function Manager:get_save_state()
	return {
		balls_count = self.balls_count,
		score = self.score,
		slot_balls_count = copy_slot_counts(self.slot_balls_count),
		total_balls_count = self.total_balls_count,
	}
end

function Manager:get_snapshot()
	local snapshot = self:get_save_state()
	snapshot.seconds_until_next_ball = self:get_seconds_until_next_ball()
	return snapshot
end

function M.new()
	local manager = setmetatable({}, Manager)
	manager:_initialize_state()
	return manager
end

return M
