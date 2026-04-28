--!strict

local process = require("@lute/process")

local cli = require("@cli/parser")
local command = require("@commands/convert")

local function main()
	local parser = cli.parser()
	parser:setDescription(command.description)
	parser:setCommandName(`lute run {command.name}`)

	for _, arg: any in command.arguments do
		parser:add(arg.name, arg.kind, arg.options)
	end

	local userArgs: { string } = {}
	table.move(process.args, 2, #process.args, 1, userArgs)
	parser:parse(userArgs)

	command.run({
		theme = parser:get("theme"),
		copy = parser:has("copy"),
		expanded = parser:has("expanded"),
	})
end

main()
