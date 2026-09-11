local M = {}

M.params = {
	balls_count = 10,
	balls_max_count = 20,
	multiple_balls_count = 5,
	ball_regeneration_interval = 5,

	slots_count = 10,
	spacing = 48,
	offset_y = 32,
	slot_offset_from_pegs = 80,
	sprite_width = 32,

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

	despawn_delay = 3,
}

return M
