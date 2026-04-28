--!strict

local json = require("@std/json")

local function strip(src: string): string
	local out: { string } = {}
	local i = 1
	local n = #src
	while i <= n do
		local c = string.sub(src, i, i)
		if c == '"' then
			local j = i + 1
			while j <= n do
				local ch = string.sub(src, j, j)
				if ch == "\\" then
					j += 2
				elseif ch == '"' then
					j += 1
					break
				else
					j += 1
				end
			end
			table.insert(out, string.sub(src, i, j - 1))
			i = j
		elseif c == "/" and string.sub(src, i + 1, i + 1) == "/" then
			local nl = string.find(src, "\n", i + 2)
			i = if nl then nl else n + 1
		elseif c == "/" and string.sub(src, i + 1, i + 1) == "*" then
			local close = string.find(src, "*/", i + 2, true)
			i = if close then close + 2 else n + 1
		else
			table.insert(out, c)
			i += 1
		end
	end

	local stripped = table.concat(out)
	stripped = string.gsub(stripped, ",(%s*[%]}])", "%1")
	return stripped
end

local function parse(src: string): json.Value
	return json.deserialize(strip(src))
end

return parse
