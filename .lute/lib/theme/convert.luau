--!strict

local json = require("@std/json")

local loadTheme = require("./loadTheme")
local getThemeColors = require("./getThemeColors")
local constants = require("./constants")

local function orderedColorsJson(colors: { [string]: { number } }): string
	local parts: { string } = {}
	for _, entry in constants.ROBLOX_VSCODE_THEME_MAP do
		local rgb = colors[entry.studio]
		if rgb then
			table.insert(parts, `{json.serialize(entry.studio)}:{json.serialize(rgb :: any)}`)
		end
	end
	return "{" .. table.concat(parts, ",") .. "}"
end

local function convert(themeFile: string): (string, { string })
	local theme = loadTheme(themeFile)
	local colors, missingColors = getThemeColors(theme :: any)

	local jsonStr = orderedColorsJson(colors)

	local body = [==[
local theme = game.HttpService:JSONDecode(json)

local studio = settings().Studio

for name, color in theme do
	local success = pcall(function()
		studio[name] = Color3.fromRGB(color[1], color[2], color[3])
	end)

	if not success then
		warn(`{name} is not a valid theme color`)
	end
end

print("Successfully changed your Script Editor theme!")]==]

	local command = "local json = [[" .. jsonStr .. "]]" .. body
	return command, missingColors
end

return convert
