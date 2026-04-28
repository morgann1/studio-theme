--!strict

local color = require("@utils/color")

local getAvailableThemes = require("../lib/theme/getAvailableThemes")
local logArray = require("../lib/theme/logArray")

export type Argument = {
	name: string,
	kind: "positional" | "flag" | "option",
	options: {
		help: string?,
		aliases: { string }?,
		default: string?,
		required: boolean?,
	},
}

local list = {}

list.name = "list"
list.description = "Lists the names of available VSCode themes that can be converted"
list.usage = "lute run list"
list.arguments = {} :: { Argument }

function list.run(): ()
	local themes = getAvailableThemes()

	print(color.bold("Available themes:"))
	local names: { string } = {}
	for _, theme in themes do
		table.insert(names, theme.name)
	end
	logArray(names)

	print()
	print(color.dim("Run 'lute run convert <theme>' to convert one."))
end

return list
