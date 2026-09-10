local M = {}

M.pegs = {
	triangle_bottom_count = 9,
	field_width = 560,
}

M.slots = {
	offset_from_pegs = 90,
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
}

M.ball = {
	despawn_delay = 3,
}

return M
