local config = require "scripts.config"

local M = {}

local balls_count = 0
local regeneration_elapsed = 0

local function get_regeneration_interval()
	local interval = config.params.ball_regeneration_interval
	assert(interval > 0, "config.params.ball_regeneration_interval must be greater than zero")
	return interval
end

local function normalize_balls_count(count)
	return math.max(0, math.floor(count or 0))
end

function M.reset()
	balls_count = normalize_balls_count(config.params.balls_count)
	regeneration_elapsed = 0
end

function M.update(dt)
	regeneration_elapsed = regeneration_elapsed + math.max(0, dt)

	local interval = get_regeneration_interval()
	local regenerated_count = math.floor(regeneration_elapsed / interval)
	if regenerated_count > 0 then
		balls_count = balls_count + regenerated_count
		regeneration_elapsed = regeneration_elapsed - regenerated_count * interval
	end

	return regenerated_count
end

function M.get_balls_count()
	return balls_count
end

function M.get_seconds_until_next_ball()
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

	balls_count = balls_count - count
	return true
end

M.reset()

return M
