--!strict

local process = require("@lute/process")

local cli = require("@cli/parser")
local command = require("@commands/list")

local function main()
	local parser = cli.parser()
	parser:setDescription(command.description)
	parser:setCommandName(`lute run {command.name}`)

	for _, arg in command.arguments do
		parser:add(arg.name, arg.kind, arg.options)
	end

	local userArgs: { string } = {}
	table.move(process.args, 2, #process.args, 1, userArgs)
	parser:parse(userArgs)

	command.run()
end

main()
