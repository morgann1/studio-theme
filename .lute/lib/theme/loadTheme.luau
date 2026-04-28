--!strict

local fs = require("@std/fs")
local pathlib = require("@std/path")

local parseJson5 = require("./parseJson5")

export type TokenColor = {
	scope: (string | { string })?,
	settings: { foreground: string? },
}

export type SemanticEntry = string | { foreground: string?, fontStyle: string?, bold: boolean?, italic: boolean?, underline: boolean? }

export type Theme = {
	colors: { [string]: string },
	tokenColors: { TokenColor },
	semanticTokenColors: { [string]: SemanticEntry },
}

local function loadTheme(filepath: string, seen: { [string]: boolean }?): Theme
	local visited = seen or {}
	if visited[filepath] then
		return { colors = {}, tokenColors = {}, semanticTokenColors = {} }
	end
	visited[filepath] = true

	local raw = parseJson5(fs.readFileToString(filepath)) :: any
	local colors: { [string]: string } = {}
	local tokenColors: { TokenColor } = {}
	local semanticTokenColors: { [string]: SemanticEntry } = {}

	if typeof(raw.include) == "string" then
		local parentPath = pathlib.format(pathlib.resolve(pathlib.dirname(filepath), raw.include))
		if fs.exists(parentPath) then
			local parent = loadTheme(parentPath, visited)
			for k, v in parent.colors do
				colors[k] = v
			end
			for _, t in parent.tokenColors do
				table.insert(tokenColors, t)
			end
			for k, v in parent.semanticTokenColors do
				semanticTokenColors[k] = v
			end
		end
	end

	if typeof(raw.colors) == "table" then
		for k, v in raw.colors :: { [string]: string } do
			colors[k] = v
		end
	end
	if typeof(raw.tokenColors) == "table" then
		for _, t in raw.tokenColors :: { TokenColor } do
			table.insert(tokenColors, t)
		end
	end
	if typeof(raw.semanticTokenColors) == "table" then
		for k, v in raw.semanticTokenColors :: { [string]: SemanticEntry } do
			semanticTokenColors[k] = v
		end
	end

	return { colors = colors, tokenColors = tokenColors, semanticTokenColors = semanticTokenColors }
end

return loadTheme
