--!strict

local fs = require("@std/fs")
local pathlib = require("@std/path")

local parseJson5 = require("./parseJson5")

export type AvailableTheme = {
	name: string,
	path: string,
}

local function loadNls(extensionPath: string): { [string]: string }?
	local nlsPath = pathlib.format(pathlib.join(extensionPath, "package.nls.json"))
	if not fs.exists(nlsPath) then
		return nil
	end
	local ok, parsed = pcall(parseJson5, fs.readFileToString(nlsPath))
	if not ok or typeof(parsed) ~= "table" then
		return nil
	end
	return parsed :: any
end

local function resolveLabel(label: string?, nls: { [string]: string }?): string?
	if not label then
		return nil
	end
	local key = string.match(label, "^%%(.+)%%$")
	if not key then
		return label
	end
	if not nls then
		return nil
	end
	return nls[key]
end

local function getThemesInDir(extensionsPath: string): { AvailableTheme }
	local availableThemes: { AvailableTheme } = {}

	if not fs.exists(extensionsPath) then
		return availableThemes
	end

	local entries = fs.listDirectory(extensionsPath)

	for _, entry in entries do
		if entry.type ~= "dir" then
			continue
		end

		local extensionPath = pathlib.format(pathlib.join(extensionsPath, entry.name))
		local pkgPath = pathlib.format(pathlib.join(extensionPath, "package.json"))

		if not fs.exists(pkgPath) then
			continue
		end

		local ok, contents: any = pcall(fs.readFileToString, pkgPath)
		if not ok then
			continue
		end

		local parsedOk, parsedValue = pcall(parseJson5, contents)
		if not parsedOk or typeof(parsedValue) ~= "table" then
			continue
		end
		local parsed = parsedValue :: any

		local contributes = parsed.contributes
		local themes = if contributes then contributes.themes else nil

		if not themes then
			continue
		end

		local nls = loadNls(extensionPath)

		for _, theme in themes :: { any } do
			local name = theme.id or resolveLabel(theme.label, nls)
			if not name or name == "" then
				continue
			end
			table.insert(availableThemes, {
				name = name,
				path = pathlib.format(pathlib.resolve(extensionPath, theme.path)),
			})
		end
	end

	return availableThemes
end

return getThemesInDir
