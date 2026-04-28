--!strict

local color = require("@utils/color")
local process = require("@lute/process")

local function validationError(message: string, code: number?)
	print(color.bold(color.red("Error: " .. message)))
	process.exit(code or 1)
end

local function processError(message: string, exitCode: number, stderr: string?)
	print(color.bold(color.red(message)))
	if stderr then
		print(stderr)
	end
	process.exit(exitCode)
end

local function error(message: string, code: number?)
	print(color.bold(color.red("Error: " .. message)))
	process.exit(code or 1)
end

return table.freeze({
	validationError = validationError,
	processError = processError,
	error = error,
})
