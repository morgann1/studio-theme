--!strict

local errors = require("@cli/errors")
local process = require("@lute/process")

local cli = {}
cli.__index = cli

type ArgKind = "positional" | "flag" | "option"
type ArgOptions = {
	help: string?,
	aliases: { string }?,
	default: string?,
	required: boolean?,
}

type ArgData = {
	name: string,
	kind: ArgKind,
	options: ArgOptions,
}

type ParseResult = {
	values: { [string]: string },
	flags: { [string]: boolean },
	fwdArgs: { string },
}

type ParserData = {
	arguments: { [number]: ArgData },
	positional: { [number]: ArgData },
	parsed: ParseResult,
	description: string?,
	commandName: string?,
}

type ParserInterface = typeof(cli)
export type Parser = typeof(setmetatable({} :: ParserData, {} :: ParserInterface))

function cli.parser(): Parser
	local self: ParserData = {
		arguments = {},
		positional = {},
		parsed = { values = {}, flags = {}, fwdArgs = {} },
		description = nil,
		commandName = nil,
	}

	return setmetatable(self, cli)
end

function cli.setDescription(self: Parser, description: string): ()
	self.description = description
end

function cli.setCommandName(self: Parser, name: string): ()
	self.commandName = name
end

function cli.add(self: Parser, name: string, kind: ArgKind, options: ArgOptions?): ()
	local argument: ArgData = {
		name = name,
		kind = kind,
		options = options or { aliases = {} :: { string }, required = false },
	}

	table.insert(self.arguments, argument)
	if kind == "positional" then
		table.insert(self.positional, argument)
	end
end

function cli.checkHelp(self: Parser, args: { string }): boolean
	for _, arg in args do
		if arg == "--help" or arg == "-h" then
			self:help()
			return true
		end
	end
	return false
end

function cli.parse(self: Parser, args: { string }): ()
	if self:checkHelp(args) then
		process.exit(0)
	end

	local i = 0
	local pos_index = 1

	while i < #args do
		i += 1

		local arg = args[i]

		if arg == "--" then
			table.move(args, i + 1, #args, 1, self.parsed.fwdArgs)
			break
		end

		if string.sub(arg, 1, 2) == "--" then
			local name = string.sub(arg, 3)
			local found = false

			for _, argument in self.arguments do
				local aliases = argument.options.aliases or {}

				if argument.name == name or table.find(aliases, name) then
					found = true

					if argument.kind == "option" then
						i += 1

						if i > #args then
							errors.error(`Missing value for argument: {argument.name}`)
						end
						self.parsed.values[argument.name] = args[i]

						break
					end

					self.parsed.flags[argument.name] = true
					break
				end
			end

			if not found then
				errors.error(`Unknown argument: {name}`)
			end
			continue
		end

		if string.sub(arg, 1, 1) == "-" then
			local flags = string.sub(arg, 2)

			for j = 1, #flags do
				local name = string.sub(flags, j, j)
				local found = false
				for _, argument in self.arguments do
					local aliases = argument.options.aliases or {}
					if argument.name == name or table.find(aliases, name) then
						found = true
						if argument.kind == "option" then
							i += 1
							if i > #args then
								errors.error(`Missing value for argument: {argument.name}`)
							end
							self.parsed.values[argument.name] = args[i]
						else
							self.parsed.flags[argument.name] = true
						end
						break
					end
				end

				if not found then
					errors.error(`Unknown argument: {name}`)
				end
			end

			continue
		end

		if pos_index <= #self.positional then
			self.parsed.values[self.positional[pos_index].name] = arg
			pos_index += 1
			continue
		end

		table.insert(self.parsed.fwdArgs, arg)
	end

	for _, argument in self.arguments do
		if argument.options.required and self.parsed.values[argument.name] == nil then
			errors.error(`Missing required argument: {argument.name}`)
		end

		if self.parsed.values[argument.name] == nil and argument.options.default then
			self.parsed.values[argument.name] = argument.options.default
		end
	end
end

function cli.get(self: Parser, name: string): string?
	return self.parsed.values[name]
end

function cli.has(self: Parser, name: string): boolean
	return self.parsed.flags[name] ~= nil
end

function cli.forwarded(self: Parser): { string }?
	return self.parsed.fwdArgs
end

function cli.help(self: Parser): ()
	if self.description then
		print(self.description)
		print()
	end

	local usageParts: { string } = {}
	if self.commandName then
		table.insert(usageParts, self.commandName)
	end

	for _, arg in self.positional do
		if arg.options.required then
			table.insert(usageParts, `<{arg.name}>`)
		else
			table.insert(usageParts, `[{arg.name}]`)
		end
	end

	local hasOptions = false
	for _, arg in self.arguments do
		if arg.kind ~= "positional" then
			hasOptions = true
			break
		end
	end

	if hasOptions then
		table.insert(usageParts, "[OPTIONS]")
	end

	local usageLine = table.concat(usageParts, " ")
	print(`Usage: {usageLine}`)
	print()

	if #self.positional > 0 then
		print("Arguments:")
		for _, argument in self.positional do
			local reqStr = if argument.options.required then "" else "(optional) "
			local helpText = argument.options.help or ""
			print(string.format("  <%s>  %s%s", argument.name, reqStr, helpText))
		end
		print()
	end

	local options: { ArgData } = {}
	for _, argument in self.arguments do
		if argument.kind ~= "positional" then
			table.insert(options, argument)
		end
	end

	print("Options:")

	for _, argument in options do
		local aliasStr = table.concat(argument.options.aliases or {}, ", ")
		local helpText = argument.options.help or ""

		if aliasStr ~= "" then
			if argument.kind == "option" then
				print(string.format("  -%s, --%s <VALUE>  %s", aliasStr, argument.name, helpText))
			else
				print(string.format("  -%s, --%s  %s", aliasStr, argument.name, helpText))
			end
		else
			if argument.kind == "option" then
				print(string.format("  --%s <VALUE>  %s", argument.name, helpText))
			else
				print(string.format("  --%s  %s", argument.name, helpText))
			end
		end
	end

	print("  -h, --help  Print help")
end

return cli
