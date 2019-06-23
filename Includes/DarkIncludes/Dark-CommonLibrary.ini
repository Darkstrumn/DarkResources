-------------------------------------------------------------------------------
-- Name=Dark-CommonLibrary
-- Author=Darkstrumn
-- Description=Script provides common logic routines
-- Version=0.0.1
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-------------------------------------------------------------------------------
function Delim(line, delimiter) -- Separate String by single character delimiter
	assert(delimiter:len() == 1, 'Delim: Delimiter may only be a single character')

	local tbl = {}

	for word in line:gmatch('[^%' .. delimiter .. ']+') do
		table.insert(tbl, word)
	end

	return tbl
end
-------------------------------------------------------------------------------
function ReadFile(FilePath)
	-- HANDLE RELATIVE PATH OPTIONS.
	FilePath = SKIN:MakePathAbsolute(FilePath)

	-- OPEN FILE.
	local File = io.open(FilePath)

	-- HANDLE ERROR OPENING FILE.
	if not File then
		print('ReadFile: unable to open file at ' .. FilePath)
		return
	end

	-- READ FILE CONTENTS AND CLOSE.
	local Contents = File:read('*all')
	File:close()

	return Contents
end
-------------------------------------------------------------------------------
function ReadFileLines(FilePath)
	-- HANDLE RELATIVE PATH OPTIONS.
	FilePath = SKIN:MakePathAbsolute(FilePath)

	-- OPEN FILE.
	local File = io.open(FilePath)

	-- HANDLE ERROR OPENING FILE.
	if not File then
		print('ReadFile: unable to open file at ' .. FilePath)
		return
	end

	-- READ FILE CONTENTS AND CLOSE.
	local Contents = {}
	for Line in File:lines() do
		table.insert(Contents, Line)
	end

	File:close()
	-- to merge lines Contents = table.concat(Table, '\n')
	return Contents
end
-------------------------------------------------------------------------------
function WriteFile(FilePath, Contents)
	-- HANDLE RELATIVE PATH OPTIONS.
	FilePath = SKIN:MakePathAbsolute(FilePath)

	-- OPEN FILE.
	local File = io.open(FilePath, 'w')

	-- HANDLE ERROR OPENING FILE.
	if not File then
		print('WriteFile: unable to open file at ' .. FilePath)
		return
	end

	-- WRITE CONTENTS AND CLOSE FILE
	File:write(Contents)
	File:close()

	return true
end
-------------------------------------------------------------------------------
-- The returned table is in the format Table[Section][Parameter] = Value
function ReadIni(inputfile)
	local file = assert(io.open(inputfile, 'r'), 'Unable to open ' .. inputfile)
	local tbl, section = {}
	local num = 0
	for line in file:lines() do
		num = num + 1
		if not line:match('^%s-;') then
			local key, command = line:match('^([^=]+)=(.+)')
			if line:match('^%s-%[.+') then
				section = line:match('^%s-%[([^%]]+)'):lower()
				if not tbl[section] then tbl[section] = {} end
			elseif key and command and section then
				tbl[section][key:lower():match('^s*(%S*)%s*$')] = command:match('^s*(.-)%s*$')
			elseif #line > 0 and section and not key or command then
				print(num .. ': Invalid property or value.')
			end
		end
	end
	if not section then print('No sections found in ' .. inputfile) end
	file:close()
	return tbl
end
-------------------------------------------------------------------------------
function SetOptionKeyValue(SectionName, tbl)
	for key, value in pairs(tbl) do SKIN:Bang('!SetOption', SectionName, key, value) end
end
-------------------------------------------------------------------------------
function SetVariablesKeyValue(tbl)
	for key, value in pairs(tbl) do SKIN:Bang('!SetVariable', key, value) end
end
-------------------------------------------------------------------------------
function Round(num, idp)
	assert(tonumber(num), 'Round expects a number.')
	local mult = 10 ^ (idp or 0)
	if num >= 0 then
		return math.floor(num * mult + 0.5) / mult
	else
		return math.ceil(num * mult - 0.5) / mult
	end
end
-------------------------------------------------------------------------------
function SentenceCase(input)
	assert(type(input) == 'string', ('SentenceCase must receive a string. Received %s instead.'):format(type(input)))

	return (input:gsub('[^.!?]+', function(sentence)
			local space, first, rest = sentence:match('(%s*)(.)(.*)')
	
			return space .. first:upper() .. rest:lower():gsub("%si([%s'])", ' I%1')
		end))
end
-------------------------------------------------------------------------------
function TitleCase(input)
	assert(type(input) == 'string', ('TitleCase must receive a string. Received %s instead.'):format(type(input)))

	return (input:gsub('(%S)(%S*)', function(first, rest) return first:upper() .. rest:lower() end))
end
-------------------------------------------------------------------------------
function AutoScale(num, idp)
	assert(tonumber(num), 'AutoScale expects a number.')
	local scales = {'B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'}
	local places = idp or 0
	local scale = ""
	local scaled = 0

	for i, v in ipairs(scales) do
		if (num < (1024 ^ i)) or (i == #scales) then
			scale = v
			scaled = Round(num / 1024 ^ (i - 1), places)
			break
		end
	end

	return scaled, scale
end
-------------------------------------------------------------------------------
function AddSuffix(num)
	assert(tonumber(num), 'AddSuffix expects a number.')
	local suffix = ''

	local n = num % 10
	if (num - n) == 10 then
		suffix = 'th'
	else
		suffix = (n == 1 and 'st' or n == 2 and 'nd' or n == 3 and 'rd' or 'th')
	end

	return suffix
end
-------------------------------------------------------------------------------
function AddCommas(num)
	assert(tonumber(num), 'AddCommas expects a number.')
	local outNum = num
	local replaceCount = 0

	while true do
		outNum, replaceCount = outNum:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
		if (replaceCount == 0) then
			break
		end
	end

	return outNum
end
-------------------------------------------------------------------------------
function SortRandom(input)
	assert(type(input) == 'table', ('SortRandom must receive a table. Received %s instead.'):format(type(input)))
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
	
	local temp, newinput = {}, {}

	for _, v in pairs(input) do
		table.insert(newinput, v)
	end

	while #newinput > 0 do
		table.insert(temp, table.remove(newinput, math.random(1, #newinput)))
	end

	return temp
end
-------------------------------------------------------------------------------
function ConvertToHex(color) -- Converts RGB colors to HEX
	local hex = {}

	for rgb in color:gmatch('%d+') do
		table.insert(hex, ('%02X'):format(tonumber(rgb)))
	end

	return table.concat(hex)
end
-------------------------------------------------------------------------------
function ConvertToRGB(color) -- Converts HEX colors to RGB
	local rgb = {}

	for hex in color:gmatch('..') do
		table.insert(rgb, tonumber(hex, 16))
	end

	return table.concat(rgb, ',')
end
-------------------------------------------------------------------------------
function Average(...)
	local value = 0

	for i, number in ipairs(arg) do
		value = value + number
	end

	return value / #arg
end
-------------------------------------------------------------------------------
function ConvertTemp(num, toScale)
	assert(tonumber(num), 'ConvertTemp expects a number.')
	assert((toScale == 'c') or (toScale == 'f'),
		'ConvertTemp expects c or f as the scale to convert to.')

	local outTemp = 0

	if toScale == 'c' then
		outTemp = Round((5 / 9) * (num - 32))
	else
		outTemp = Round((9 / 5) * num + 32)
	end

	return outTemp
end
-------------------------------------------------------------------------------
function RootConfigName(Config)
    return Config:match('(.-)\\') or Config
end
-------------------------------------------------------------------------------
function ParseTwelveHourTime(Hour, Meridiem)
	if (Meridiem == 'AM') and (Hour == 12) then
		Hour = 0
	elseif (Meridiem == 'PM') and (Hour < 12) then
		Hour = Hour + 12
	end
	return Hour
end
-------------------------------------------------------------------------------
function ConvertTime(n, To)
	local Formats = {
		Unix    = -1
		Windows = 1
		}
	return Formats[To] and n + 11644473600 * Formats[To] or nil
end
-------------------------------------------------------------------------------
-- Variable = 'Match1'
-- Table = switch{
-- 	match1 = function(tbl) return tbl[2] end,
-- 	match2 = function(tbl) return tbl[2] end,
-- 	default = function(tbl) return 'No match found' end,
-- }
-- result = Table:case(Variable:lower(), 'Example text.')
	-- Variable = 'Match'..intState
	--
-- 	Table = switch({
-- 		match1 = function(tbl)
-- 			SKIN:Bang('!SetVariable ResultValue '..tostring(0))
-- 			SKIN:Bang('!SetVariable ResultValue1 "'..tostring(tbl[2])..'"')
-- 			return tbl[2]
-- 			end,
-- 		match2 = function(tbl)
-- 			SKIN:Bang(bWKV,'Variables','Test',intState,'#LVARFILE#')
-- 			--SKIN:Bang(bSO,'MeterScript','RightMouseUpAction',bCM..' MeasureCount EmptyBin \"NERV UI\\Recycle\"','NERV UI\\Top')
-- 			SKIN:Bang('!SetVariable ResultValue1 "'..tostring(tbl[2])..'"')
-- 			SKIN:Bang('!SetVariable ResultValue '..tostring(1))
-- 			return tbl[2]
-- 			end,
-- 		default = function(tbl)
-- 			SKIN:Bang('!SetVariable ResultValue1 "'..tostring(tbl[1])..'"')
-- 			SKIN:Bang('!SetVariable ResultValue '..tostring(99))
-- 			return tbl[2]
-- 			end,
-- 	})
-- 	SKIN:Bang('!SetVariable VariableValue '..Variable)
-- 	Case = Table:case(Variable:lower(), 'Example text.')
-------------------------------------------------------------------------------
function switch(tbl) -- Used to emulate a switch statement
	tbl.case = function(...)
		local t = table.remove(arg,1)
		local f = t[arg[1]] or t.default
		local ret = -999
		if f then
			if type(f) == 'function' then
				ret = f(arg)
			else
				print('Case: ' .. tostring(x) .. ' not a function')
			end
		end
	end
--	SKIN:Bang('!SetVariable DiagValue '..tostring(ret))
--	return ret
	return tbl
end
-------------------------------------------------------------------------------
function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end
-------------------------------------------------------------------------------
