--!strict

local constants = require("./constants")
local getScopeColors = require("./getScopeColors")
local getSemanticColors = require("./getSemanticColors")
local toRGB = require("./toRGB")

type TokenColor = {
	scope: (string | { string })?,
	settings: { foreground: string? },
}

type SemanticEntry = string | { foreground: string?, fontStyle: string?, bold: boolean?, italic: boolean?, underline: boolean? }

export type Theme = {
	colors: { [string]: string }?,
	tokenColors: { TokenColor },
	semanticTokenColors: { [string]: SemanticEntry }?,
}

local function lookupScope(scopeColors: { [string]: string }, scope: string): string?
	if scopeColors[scope] then
		return scopeColors[scope]
	end
	local parts = string.split(scope, ".")
	for i = #parts - 1, 1, -1 do
		local candidate = table.concat(parts, ".", 1, i)
		if scopeColors[candidate] then
			return scopeColors[candidate]
		end
	end
	return nil
end

local function getThemeColors(theme: Theme): ({ [string]: { number } }, { string })
	local colors: { [string]: { number } } = {}
	local missing: { string } = {}

	local scopeColors = getScopeColors(theme)
	local semanticColors = getSemanticColors(theme :: any)

	for _, entry in constants.ROBLOX_VSCODE_THEME_MAP do
		local studioName = entry.studio
		local vscodeColors = entry.vscode

		local color: string? = nil

		for _, vscodeColor in vscodeColors do
			if theme.colors then
				color = theme.colors[vscodeColor]
			end

			if not color then
				color = lookupScope(scopeColors, vscodeColor)
			end

			if not color then
				color = lookupScope(semanticColors, vscodeColor)
			end

			if not color then
				for _, token in theme.tokenColors do
					if token.scope == nil then
						color = token.settings and token.settings.foreground
						break
					end
				end
			end

			if color then
				break
			end
		end

		if color then
			colors[studioName] = toRGB(theme, color)
		else
			table.insert(missing, studioName)
		end
	end

	return colors, missing
end

return getThemeColors
