--!strict

export type TokenColor = {
	scope: (string | { string })?,
	settings: { foreground: string? },
}

export type Theme = { tokenColors: { TokenColor } }

local function getScopeColors(theme: Theme): { [string]: string }
	local colors: { [string]: string } = {}

	for _, token in theme.tokenColors do
		local color = token.settings and token.settings.foreground

		if color then
			local scopes: { string } = {}
			if typeof(token.scope) == "table" then
				scopes = token.scope :: { string }
			elseif typeof(token.scope) == "string" then
				for part in string.gmatch(token.scope :: string, "[^,]+") do
					table.insert(scopes, (string.gsub(part, "^%s*(.-)%s*$", "%1")))
				end
			end

			for _, scope in scopes do
				colors[scope] = color
			end
		end
	end

	return colors
end

return getScopeColors
