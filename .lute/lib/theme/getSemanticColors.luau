--!strict

local SCOPE_TO_SEMANTIC: { [string]: string } = {
	["entity.name.namespace"] = "namespace",
	["entity.name.type"] = "type",
	["entity.name.type.class"] = "class",
	["entity.name.type.enum"] = "enum",
	["entity.name.type.interface"] = "interface",
	["entity.name.type.struct"] = "struct",
	["entity.name.type.parameter"] = "typeParameter",
	["variable.parameter"] = "parameter",
	["variable.other.readwrite"] = "variable",
	["entity.name.variable"] = "variable",
	["variable.other.property"] = "property",
	["variable.other.member"] = "property",
	["variable.other.enummember"] = "enumMember",
	["entity.name.decorator"] = "decorator",
	["variable.other.event"] = "event",
	["entity.name.function"] = "function",
	["entity.name.function.method"] = "method",
	["entity.name.function.member"] = "method",
	["entity.name.function.preprocessor"] = "macro",
	["entity.name.label"] = "label",
	["comment"] = "comment",
	["string"] = "string",
	["keyword"] = "keyword",
	["constant.numeric"] = "number",
	["string.regexp"] = "regexp",
	["keyword.operator"] = "operator",
}

type SemanticEntry = string | {
	foreground: string?,
	fontStyle: string?,
	bold: boolean?,
	italic: boolean?,
	underline: boolean?,
}

type Theme = { semanticTokenColors: { [string]: SemanticEntry } }

local function entryForeground(entry: SemanticEntry): string?
	if typeof(entry) == "string" then
		return entry
	end
	if typeof(entry) == "table" then
		return (entry :: any).foreground
	end
	return nil
end

local function getSemanticColors(theme: Theme): { [string]: string }
	local result: { [string]: string } = {}
	if typeof(theme.semanticTokenColors) ~= "table" then
		return result
	end

	for scope, semKey in SCOPE_TO_SEMANTIC do
		local entry = theme.semanticTokenColors[semKey]
		if entry then
			local color = entryForeground(entry)
			if color then
				result[scope] = color
			end
		end
	end

	return result
end

return getSemanticColors
