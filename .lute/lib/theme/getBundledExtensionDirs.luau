--!strict

local fs = require("@std/fs")
local pathlib = require("@std/path")
local sys = require("@std/system")
local processlib = require("@std/process")

local function isExtensionsDir(path: string): boolean
	return fs.exists(path) and fs.type(path) == "dir"
end

local function appendWindowsCandidates(out: { string }, root: string): ()
	if not fs.exists(root) then
		return
	end

	local direct = pathlib.format(pathlib.join(root, "resources/app/extensions"))
	if isExtensionsDir(direct) then
		table.insert(out, direct)
	end

	for _, entry in fs.listDirectory(root) do
		if entry.type ~= "dir" then
			continue
		end
		local nested = pathlib.format(pathlib.join(root, entry.name, "resources/app/extensions"))
		if isExtensionsDir(nested) then
			table.insert(out, nested)
		end
	end
end

local function getBundledExtensionDirs(): { string }
	local dirs: { string } = {}

	if sys.win32 then
		local roots: { string } = {}
		local localAppData = processlib.env.LOCALAPPDATA
		if localAppData then
			table.insert(roots, pathlib.format(pathlib.join(localAppData, "Programs/Microsoft VS Code")))
			table.insert(roots, pathlib.format(pathlib.join(localAppData, "Programs/Microsoft VS Code Insiders")))
		end
		table.insert(roots, "C:/Program Files/Microsoft VS Code")
		table.insert(roots, "C:/Program Files (x86)/Microsoft VS Code")
		table.insert(roots, "C:/Program Files/Microsoft VS Code Insiders")

		for _, root in roots do
			appendWindowsCandidates(dirs, root)
		end
	elseif sys.macos then
		local candidates = {
			"/Applications/Visual Studio Code.app/Contents/Resources/app/extensions",
			"/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/extensions",
		}
		for _, dir in candidates do
			if isExtensionsDir(dir) then
				table.insert(dirs, dir)
			end
		end
	elseif sys.linux then
		local candidates = {
			"/usr/share/code/resources/app/extensions",
			"/usr/share/code-insiders/resources/app/extensions",
			"/snap/code/current/usr/share/code/resources/app/extensions",
			"/opt/visual-studio-code/resources/app/extensions",
		}
		for _, dir in candidates do
			if isExtensionsDir(dir) then
				table.insert(dirs, dir)
			end
		end
	end

	return dirs
end

return getBundledExtensionDirs
