local board_layout = require "scripts.board_layout"
local config = require "scripts.config"

local M = {}

local Session = {}
Session.__index = Session

local function normalize_count(value, default_value)
	if type(value) ~= "number" or value ~= value then
		return default_value or 0
	end
	return math.max(0, math.floor(value))
end

local function copy_landings_by_slot(source)
	source = source or {}
	local copy = {}
	for slot_index = 1, board_layout.get_slot_count() do
		copy[slot_index] = normalize_count(source[slot_index])
	end
	return copy
end

function Session:_initialize_state()
	self.balls_count = config.params.initial_balls_count
	self.score = 0
	self.regeneration_elapsed = 0
	self.landings_by_slot = copy_landings_by_slot()
	self.total_landing_count = 0
end

function Session:restore(saved_state)
	self:_initialize_state()
	if type(saved_state) ~= "table" then
		return
	end

	self.balls_count = normalize_count(saved_state.balls_count, config.params.initial_balls_count)
	self.score = normalize_count(saved_state.score)

	local saved_landings_by_slot = type(saved_state.landings_by_slot) == "table" and saved_state.landings_by_slot or {}
	self.landings_by_slot = copy_landings_by_slot(saved_landings_by_slot)
	for slot_index = 1, board_layout.get_slot_count() do
		self.total_landing_count = self.total_landing_count + self.landings_by_slot[slot_index]
	end
end

function Session:reset()
	self:_initialize_state()
end

function Session:update(dt)
	local max_balls_count = config.params.max_balls_count
	if self.balls_count >= max_balls_count then
		self.regeneration_elapsed = 0
		return 0
	end

	self.regeneration_elapsed = self.regeneration_elapsed + math.max(0, dt)
	local elapsed_intervals = math.floor(self.regeneration_elapsed / config.params.ball_regeneration_interval)
	if elapsed_intervals == 0 then
		return 0
	end

	local previous_balls_count = self.balls_count
	self.balls_count = math.min(self.balls_count + elapsed_intervals, max_balls_count)
	local regenerated_count = self.balls_count - previous_balls_count
	self.regeneration_elapsed = self.regeneration_elapsed - elapsed_intervals * config.params.ball_regeneration_interval
	if self.balls_count >= max_balls_count then
		self.regeneration_elapsed = 0
	end
	return regenerated_count
end

function Session:add_ball()
	-- Debug grants intentionally bypass the regeneration cap.
	self.balls_count = self.balls_count + 1
	if self.balls_count >= config.params.max_balls_count then
		self.regeneration_elapsed = 0
	end
end

function Session:record_landing(slot_index)
	slot_index = board_layout.validate_slot_index(slot_index)

	local score = board_layout.get_slot_tier(slot_index).score
	self.landings_by_slot[slot_index] = self.landings_by_slot[slot_index] + 1
	self.total_landing_count = self.total_landing_count + 1
	self.score = self.score + score
	return score
end

function Session:get_seconds_until_next_ball()
	if self.balls_count >= config.params.max_balls_count then
		return 0
	end
	return math.ceil(config.params.ball_regeneration_interval - self.regeneration_elapsed)
end

function Session:try_spend_balls(count)
	count = normalize_count(count)
	if count == 0 or self.balls_count < count then
		return false
	end

	local regeneration_was_paused = self.balls_count >= config.params.max_balls_count
	self.balls_count = self.balls_count - count
	if regeneration_was_paused and self.balls_count < config.params.max_balls_count then
		self.regeneration_elapsed = 0
	end
	return true
end

function Session:get_persistent_state()
	return {
		balls_count = self.balls_count,
		score = self.score,
		landings_by_slot = copy_landings_by_slot(self.landings_by_slot),
	}
end

function Session:get_snapshot()
	local snapshot = self:get_persistent_state()
	snapshot.total_landing_count = self.total_landing_count
	snapshot.seconds_until_next_ball = self:get_seconds_until_next_ball()
	return snapshot
end

function M.new()
	local session = setmetatable({}, Session)
	session:_initialize_state()
	return session
end

return M
