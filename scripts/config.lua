local M = {}

M.params = {
	-- Initial balls count
	balls_count = 10,
	-- Maximum number of regenerated balls
	balls_max_count = 20,
	-- Balls spawned by the multi-spawn button
	multiple_balls_count = 5,
	-- Seconds required to regenerate one ball
	ball_regeneration_interval = 10,

	-- Number of landing slots
	slots_count = 10,
	-- Horizontal spacing between pegs and slots
	spacing = 48,
	-- Vertical offset of the peg layout
	offset_y = 32,
	-- Vertical distance from the bottom pegs to the slots
	slot_offset_from_pegs = 80,

	-- Ordered from the center slots towards both mirrored outer edges. Extra colors are ignored
	slots_colors = {
		vmath.vector4(0.95, 0.55, 0.50, 1.0),
		vmath.vector4(1.00, 0.80, 0.40, 1.0),
		vmath.vector4(1.00, 0.95, 0.50, 1.0),
		vmath.vector4(0.60, 0.95, 0.65, 1.0),
		vmath.vector4(0.50, 0.85, 0.95, 1.0),
	},

	-- Ordered from the center slots towards both mirrored outer edges. Extra scores are ignored
	slots_scores = {
		1,
		2,
		3,
		4,
		5,
	},

	-- Ordered from the center slots towards both mirrored outer edges. Relative probability weights
	probability = {
		16,
		8,
		4,
		2,
		1,
	},

	-- Seconds before a landed ball is removed
	despawn_delay = 3,
}

return M
