--!strict

local fs = require("@std/fs")
local pathlib = require("@std/path")
local processlib = require("@std/process")
local sys = require("@std/system")

local function write(text: string): boolean
	local tmp = pathlib.format(pathlib.join(sys.tmpdir(), `studio-theme-clip-{os.time()}.txt`))
	fs.writeStringToFile(tmp, text)

	local ok = false
	if sys.win32 then
		local result = processlib.system(`type "{tmp}" | clip`)
		ok = result.ok
	elseif sys.macos then
		local result = processlib.system(`pbcopy < "{tmp}"`)
		ok = result.ok
	else
		local result = processlib.system(`xclip -selection clipboard < "{tmp}"`)
		if result.ok then
			ok = true
		else
			result = processlib.system(`wl-copy < "{tmp}"`)
			ok = result.ok
		end
	end

	pcall(fs.remove, tmp)
	return ok
end

return table.freeze({ write = write })
