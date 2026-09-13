local M = {}

local BUTTON_NORMAL = hash("btn_green_normal")
local BUTTON_PUSH = hash("btn_green_push")

function M.new_button(druid_instance, node_id, callback, callback_argument)
	local button = druid_instance:new_button(node_id, callback, callback_argument)
	local function show_normal_texture()
		gui.play_flipbook(button.node, BUTTON_NORMAL)
	end

	button.on_pressed:subscribe(function()
		gui.play_flipbook(button.node, BUTTON_PUSH)
	end)
	button.on_click:subscribe(show_normal_texture)
	button.on_click_outside:subscribe(show_normal_texture)
	return button
end

return M
