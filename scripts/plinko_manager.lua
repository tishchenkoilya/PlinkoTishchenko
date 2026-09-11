local config = require "scripts.config"

local M = {}

local balls_count = 0
local score = 0
local regeneration_elapsed = 0

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

function M.reset()
	balls_count = normalize_balls_count(config.params.balls_count)
	score = 0
	regeneration_elapsed = 0
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
end

function M.get_score()
	return score
end

function M.add_score(value)
	score = score + math.max(0, math.floor(value or 0))
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
	return true
end

M.reset()

return M
