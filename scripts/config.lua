local M = {}

M.params = {
	balls_count = 10,
	multiple_balls_count = 4,
	ball_regeneration_interval = 30,

	slots_count = 10,
	spacing = 48,
	offset_y = 32,
	slot_offset_from_pegs = 80,
	sprite_width = 32,

	-- Ordered from the center slots towards both mirrored outer edges. Extra colors are ignored
	colors = {
		vmath.vector4(0.95, 0.25, 0.20, 1.0),
		vmath.vector4(1.00, 0.55, 0.15, 1.0),
		vmath.vector4(1.00, 0.85, 0.20, 1.0),
		vmath.vector4(0.30, 0.75, 0.35, 1.0),
		vmath.vector4(0.20, 0.55, 0.95, 1.0),
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
