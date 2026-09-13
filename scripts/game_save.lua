local M = {}

local SAVE_APPLICATION_ID = "plinko_tishchenko"
local SAVE_FILE_NAME = "save"
local SAVE_VERSION = 1

local function get_save_file_path()
	return sys.get_save_file(SAVE_APPLICATION_ID, SAVE_FILE_NAME)
end

function M.load()
	local success, saved_state = pcall(function()
		return sys.load(get_save_file_path())
	end)
	if not success then
		print("Failed to load game: " .. tostring(saved_state))
		return nil
	end
	if type(saved_state) ~= "table" or not next(saved_state) then
		return nil
	end

	local version = saved_state.version or 0
	if type(version) ~= "number" or version ~= math.floor(version) or version < 0 or version > SAVE_VERSION then
		print("Unsupported game save version: " .. tostring(version))
		return nil
	end
	return saved_state
end

function M.save(save_data)
	save_data.version = SAVE_VERSION

	local success, result = pcall(function()
		return sys.save(get_save_file_path(), save_data)
	end)
	if not success or result == false then
		print("Failed to save game: " .. tostring(result))
		return false
	end
	return true
end

return M
