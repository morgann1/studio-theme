--!strict

local color = require("@utils/color")

local TL, TR, BL, BR = "┌", "┐", "└", "┘"
local H, V = "─", "│"
local TM, BM, LM, RM, X = "┬", "┴", "├", "┤", "┼"

local function repeatStr(s: string, n: number): string
	if n <= 0 then
		return ""
	end
	local parts: { string } = {}
	for _ = 1, n do
		table.insert(parts, s)
	end
	return table.concat(parts)
end

local function buildBorder(widths: { number }, left: string, mid: string, right: string): string
	local segments: { string } = { left }
	for i, w in widths do
		table.insert(segments, repeatStr(H, w + 2))
		table.insert(segments, if i == #widths then right else mid)
	end
	return color.dim(table.concat(segments))
end

local function logArray(array: { string }, columns: number?): ()
	local cols = columns or 3
	if #array == 0 then
		return
	end

	local widths: { number } = {}
	for i = 1, cols do
		widths[i] = 0
	end

	for index, value in array do
		local col = ((index - 1) % cols) + 1
		if #value > widths[col] then
			widths[col] = #value
		end
	end

	local rowCount = math.ceil(#array / cols)
	local divider = color.dim(V)

	print(buildBorder(widths, TL, TM, TR))

	for r = 1, rowCount do
		local cells: { string } = { divider }
		for c = 1, cols do
			local index = (r - 1) * cols + c
			local value = array[index] or ""
			local padded = " " .. value .. repeatStr(" ", widths[c] - #value) .. " "
			table.insert(cells, padded)
			table.insert(cells, divider)
		end
		print(table.concat(cells))

		if r < rowCount then
			print(buildBorder(widths, LM, X, RM))
		end
	end

	print(buildBorder(widths, BL, BM, BR))
end

return logArray
