--!strict

local pathlib = require("@std/path")
local processlib = require("@std/process")

local getBundledExtensionDirs = require("./getBundledExtensionDirs")
local getThemesInDir = require("./getThemesInDir")

local function getAvailableThemes(): { getThemesInDir.AvailableTheme }
	local availableThemes: { getThemesInDir.AvailableTheme } = {}
	local seenPaths: { [string]: boolean } = {}

	local function addAll(themes: { getThemesInDir.AvailableTheme })
		for _, theme in themes do
			if seenPaths[theme.path] then
				continue
			end
			seenPaths[theme.path] = true
			table.insert(availableThemes, theme)
		end
	end

	for _, dir in getBundledExtensionDirs() do
		addAll(getThemesInDir(dir))
	end

	local userExtensions = pathlib.format(pathlib.join(processlib.homedir(), ".vscode/extensions"))
	addAll(getThemesInDir(userExtensions))

	return availableThemes
end

return getAvailableThemes
