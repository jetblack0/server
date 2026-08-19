-- habamax ships with nvim >= 0.9; swap for a plugin scheme once one is installed.
local colorscheme = "habamax"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	print("colorscheme" .. colorscheme .. "not found!")
	return
end
