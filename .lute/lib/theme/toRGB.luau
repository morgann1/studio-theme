--!strict

export type Theme = { colors: { [string]: string }? }
type Rgba = { r: number, g: number, b: number, a: number }

local function expand(c: string): string
	return c .. c
end

local function parseHex(hex: string): Rgba?
	if string.sub(hex, 1, 1) == "#" then
		hex = string.sub(hex, 2)
	end

	local r: number?, g: number?, b: number?, a: number?
	if #hex == 3 or #hex == 4 then
		r = tonumber(expand(string.sub(hex, 1, 1)), 16)
		g = tonumber(expand(string.sub(hex, 2, 2)), 16)
		b = tonumber(expand(string.sub(hex, 3, 3)), 16)
		a = if #hex == 4 then (tonumber(expand(string.sub(hex, 4, 4)), 16) :: number) / 255 else 1
	elseif #hex == 6 or #hex == 8 then
		r = tonumber(string.sub(hex, 1, 2), 16)
		g = tonumber(string.sub(hex, 3, 4), 16)
		b = tonumber(string.sub(hex, 5, 6), 16)
		a = if #hex == 8 then (tonumber(string.sub(hex, 7, 8), 16) :: number) / 255 else 1
	else
		return nil
	end

	if not r or not g or not b or not a then
		return nil
	end
	assert(r and g and b and a)

	return { r = r, g = g, b = b, a = a }
end

local function toRGB(theme: Theme, hex: string): { number }
	local rgba = parseHex(hex)
	if not rgba then
		return { 0, 0, 0 }
	end

	if rgba.a < 1 then
		local bgHex = (theme.colors and theme.colors["editor.background"]) or "#fff"
		local bg = parseHex(bgHex)
		if bg then
			return {
				math.round((1 - rgba.a) * bg.r + rgba.a * rgba.r),
				math.round((1 - rgba.a) * bg.g + rgba.a * rgba.g),
				math.round((1 - rgba.a) * bg.b + rgba.a * rgba.b),
			}
		end
	end

	return { rgba.r, rgba.g, rgba.b }
end

return toRGB
