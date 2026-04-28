--!strict

local getAvailableThemes = require("./getAvailableThemes")

local function getThemeFromName(themeName: string): string?
	local themes = getAvailableThemes()
	local target = string.lower(themeName)

	for _, theme in themes do
		if string.lower(theme.name) == target then
			return theme.path
		end
	end

	return nil
end

return getThemeFromName
