--!strict

local fs = require("@std/fs")
local processlib = require("@std/process")

local color = require("@utils/color")
local clipboard = require("@utils/clipboard")

local convertTheme = require("../lib/theme/convert")
local getThemeFromName = require("../lib/theme/getThemeFromName")

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

export type Options = {
	theme: string?,
	copy: boolean?,
	expanded: boolean?,
}

local convert = {}

convert.name = "convert"
convert.description = "Converts a VSCode theme into a Studio command bar script"
convert.usage = "lute run convert <theme> [-c] [-e]"

convert.arguments = {
	{
		name = "theme",
		kind = "positional",
		options = {
			help = "Theme name (run `list` to see available) or path to a .json theme file",
			required = true,
		},
	},
	{
		name = "copy",
		kind = "flag",
		options = {
			help = "Copy the generated command to the clipboard",
			aliases = { "c" },
		},
	},
	{
		name = "expanded",
		kind = "flag",
		options = {
			help = "Print the non-minified command",
			aliases = { "e" },
		},
	},
} :: { Argument }

function convert.run(options_: Options?): ()
	local options: Options = options_ or {}
	local themeArg = options.theme

	if not themeArg then
		print(color.red("Missing required argument: theme"))
		processlib.exit(1)
		return
	end

	local themePath: string?
	if string.sub(themeArg, -5) == ".json" then
		themePath = themeArg
	else
		themePath = getThemeFromName(themeArg)
	end

	if not themePath or not fs.exists(themePath) or fs.type(themePath) ~= "file" then
		print(color.red(`Could not find a theme file named '{themeArg}'`))
		processlib.exit(1)
		return
	end

	local command, missingColors = convertTheme(themePath)
	local minified = string.gsub(command, "%s+", " ")

	if #missingColors > 0 then
		local colorList = table.concat(missingColors, ",")
		print(color.yellow(`WARN: Some colors could not be converted: {colorList}`))
		print(color.yellow("Please submit an issue with a link to the theme you are converting."))
	end

	if options.copy then
		if clipboard.write(minified) then
			print(color.green("Theme copied to clipboard."))
			print(color.dim("Paste it into the command bar in Studio to change your Script Editor theme."))
		else
			print(color.yellow("WARN: Could not copy to clipboard. Falling back to printing the command."))
			print()
			print(minified)
		end
	else
		print("Copy/paste this command into the command bar in Studio to set your Script Editor theme:")
		print()
		if options.expanded then
			print(command)
		else
			print(minified)
		end
	end
end

return convert
