-------------------------------------------------------------------------------
-- Name=DarkCore-FL - DarkCore-Function Libary
-- Author=Darkstrumn
-- Description=cript provides common logic routines
-- Version=0.0.0 - 150215.10:: initial build
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- Details=The function library (FL) will provide script-like functions to calling Measures and Meters
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- [mLuaFunctionLibrary]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#DarkCore_FunctionLibrary.lua"
-- ;-- configs:
-- Command=Len
-- ;ArgumentListLength=2;<<--override and limit the active arguments
-- Argument1="MeasureString|mTopProcess"
-- Argument2="String|Hellow World"
-- Argument3="MeasureFloat|mProcessCount"
-- Argument4="Float|100"
-- Argument5="Variable|vProcessStatsOffset0X"
-- Argument6="Uknown|mTopProcess6"
-- Argument7="Formula|2+2"
-- UpdateDivider=-1
-- DynamicVariables=1
-- ;------------------------------------------------------------------------------
-- ============================================================================
-------------------------------------------------------------------------------
-- Initialize: we define some aliases here for often used items, mostly bang commands and the like.
-------------------------------------------------------------------------------
function Initialize()
	intState=0
	intMaxStateBoundry=5
	-- Options
	bSO = '!SetOption'
	bGO = '!GetOption'
	bSOG = '!SetOptionGroup'
	-- Variables
	bSV = '!SetVariable'
	bWKV = '!WriteKeyValue'
	-- Skins\\Configs
	bAC = '!ActivateConfig'
	bDC = '!DeactivateConfig'
	-- General Skin Actions (GSA)
	bUD = '!Update'
	bRF = '!Refresh'
	bRD = '!Redraw'
	--Measure
	bUMS = '!UpdateMeasure'
	bUMSG = '!UpdateMeasureGroup'
	bCM = '!CommandMeasure'
	-- Meter
	bSM = '!ShowMeter'
	bHM = '!HideMeter'
	bTM = '!ToggleMeter'
	bMM = '!MoveMeter'
	bUMT = '!UpdateMeter'
	bHMG = '!HideMeterGroup'
	bTMG = '!ToggleMeterGroup'
	bUMTG = '!UpdateMeterGroup'
	--Logs
	bL = '!Log'
	--Read Lua option config\\var data
	NumMonitoredProcs=tonumber(SKIN:GetVariable('NumMonitoredProcs', '0'))
	vLogHeader = SELF:GetOption('LogHeader', 'Function Libary')
	vCommand = SELF:GetOption('Command', 'Len')
	vMESA = SELF:GetOption('MeasureAlias', '#THISFILE#')--(Optional override)
	vMETA = SELF:GetOption('MeterAlias', '#THISFILE#')--(Optional override)
	vMpBaseName = SELF:GetOption('ListBaseName', 'Argument')--(Optional override)
	vLoopSize = SELF:GetOption(vMpBaseName..'ListLength', 255)--(Optional override)
	if (vLoopSize == -1) then vLoopSize = 255 end
	mMP = {} --monitored-process measures
	mMP['TYPES'] = {} --state tracking for monitored-process-unit
	mMP['ARGS'] = {} --state tracking for monitored-process-unit
	mMP['state'] = {} --state tracking for monitored-process
DebugPrint('vCommand:'..vCommand,'Notice')
	for vIndex = 1,vLoopSize do--allow for override or auto-detect,load arguments
		vMN = SELF:GetOption(vMpBaseName..vIndex, 'NULL')
		if vMN == 'NULL' then --detection of end of list
		 break
		end
DebugPrint('vMN['..vMpBaseName..vIndex..']:'..vMN,'Debug')
		--vMN::Type|Argument
		--ex:"String|Hello World"
		--ex:"Int|100"
		--ex:"Measure|mTime"
		--ex:"Meter|Time"
		vTblPair = explode('|', (vMN),math.huge)
		vType = vTblPair[1]--type
		vArg = vTblPair[2]--value\\argument
DebugPrint('vType['..vIndex..']:'..(vType),'Debug')
DebugPrint('vArg['..vIndex..']:'..(vArg),'Debug')
  	mMP['TYPES'][vIndex] = vType
  	Table = switch(
  	  {
  		string = function(args) --case string:
  		  mMP['ARGS'][vIndex] = vArg
DebugPrint('Handled as string','Notice')
  			return args[1]
  			end,
  		float = function(args) --case float:
  		  mMP['ARGS'][vIndex] = tonumber(vArg)
DebugPrint('Handled as float','Notice')
  			return args[1]
  			end,
--  		measure = function(args) --case measure:
--  		  mMeasure = SKIN:GetMeasure(vArg)
--  		  mMP['ARGS'][vIndex] = mMeasure --<<--object
--DebugPrint('Handled as measure','Notice')
--  			return args[1]
--  			end,
  		measurefloat = function(args) --case measureFloat:
  		  mMeasure = SKIN:GetMeasure(vArg)
  		  mMP['ARGS'][vIndex] = tonumber(mMeasure:GetValue())
DebugPrint('Handled as measurefloat','Notice')
  			return args[1]
  			end,
  		measurestring = function(args) --case measureString:
  		  mMeasure = SKIN:GetMeasure(vArg)
  		  mMP['ARGS'][vIndex] = mMeasure:GetStringValue()
DebugPrint(mMP['ARGS'][vIndex],'Warning')
DebugPrint('Handled as measurestring','Notice')
  			return args[1]
  			end,
--  		meter = function(args) --case meter:
--  		  mMP['ARGS'][vIndex] = SKIN:GetMeter(vArg)
--DebugPrint('Handled as meter','Notice')
--  			return args[1]
--  			end,
      variable = function(args) --case variable:
  		  mMP['ARGS'][vIndex] = SKIN:GetVariable(vArg)
DebugPrint('Handled as variable','Notice')
  			return args[1]
  			end,
      formula = function(args) --case formula:
  		  mMP['ARGS'][vIndex] = SKIN:ParseFormula(vArg)
DebugPrint('Handled as formula','Notice')
  			return args[1]
  			end,
  		default = function(args) --default:
  		  mMP['ARGS'][vIndex] = vArg
DebugPrint('Handled as default','Notice')
  			return args[1]
  			end,
  	  }
  	 )
  	Case = Table:case(vType:lower(), 'measure')
DebugPrint('Value:'..mMP['ARGS'][vIndex],'Warning')
		--state change to running
		mMP['state'][vIndex] = 0
	end
--
end
-------------------------------------------------------------------------------
-- Update: Here we tie-in to the update event and do our work every "cycle"
-------------------------------------------------------------------------------
function Update()
  ret = -1
	--ret = varWorkflowHandler()
	--<callable based on state. Remove comment for direct call>ret = Process()
--DebugPrint('Process:'..ret,'Warning')
	return (ret)
end
-------------------------------------------------------------------------------
-- Helper libraries
-------------------------------------------------------------------------------
--/**
-- * alias to helper function
-- */
function _GetMETA(MeterName)--overload
  return(_GetMETA0(MeterName,vMETA))
end
-------------------------------------------------------------------------------
--/**
-- * aliased main call to helper function
-- */
function _GetMETA0(MeterName,vMETER)
  return(SKIN:GetMeasure(MeterName,vMETER))
end
-------------------------------------------------------------------------------
--/**
-- * alias to helper function 
-- */
function _GetMESA(MeterName)--overload
  return(_GetMESA0(MeterName,vMESA))
end
-------------------------------------------------------------------------------
--/**
-- * aliased main call to helper function
-- */
function _GetMESA0(MeterName,vMEASURE)
  return(SKIN:GetMeasure(MeterName,vMEASURE))
end
-------------------------------------------------------------------------------
--/**
-- * emulate PHP explode, and supports limit
-- */
function explode(strDelim, strInput, intLimit)
    if not strDelim or strDelim == "" then 
      DebugPrint('no delimiter specified, doing nothing.','Warning')    
      return {},0
    end
    if not strInput then 
      DebugPrint('no source string specified, doing nothing.','Warning')    
      return {},0
    end
    --strInput = strInput..'|'
    intLimit = intLimit or math.huge
    if intLimit == -1 then intLimit = math.huge end
    if intLimit == 0 then return {strInput},1 end
    --
    local tblResult = {}
    local intWatermark = 1
    --
    while (true) do --main processing
        local intStart,intEnd = string.find(strInput, strDelim, intWatermark, true)
        if (not intStart) then 
          --DebugPrint('last element reached, done.','Debug')    
          break
        end
        tblResult[#tblResult + 1] = string.sub(strInput, intWatermark, intStart - 1)
        --DebugPrint('found element['..#tblResult..']: '..string.sub(strInput, intWatermark, intStart - 1)..'.','Warning')    
        intWatermark = intEnd + 1
        if ((#tblResult + 1) >= intLimit) then 
          --DebugPrint('limit reached, done.','Debug')    
          break
        end
    end
    --make remainder the last element, if present
    if (intWatermark <= string.len(strInput)) then
        tblResult[#tblResult+1] = string.sub(strInput, intWatermark)
    end
    --<diagnostics>
    --DebugPrint('found '..(#tblResult)..' elements.','Debug')    
    --for vIndex = 1,#tblResult do
    --  DebugPrint('element['..vIndex..'] :: '..(tblResult[vIndex])..'.','Warning')
    --end
    return tblResult, #tblResult
end
-------------------------------------------------------------------------------
--/**
-- * used to increment state, and keep state machine within sane ranges
-- */
function intLimiter(intValue,intLimit)
	return((intValue % intLimit) + 1)
end --</intLimiter(intValue,intLimit)>
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
-- * emulate a switch statement
-- *
-- *Table = switch( --defines case blocks
-- *  {
-- *  formula = function(args) --case 'formula':
-- *	  mMP['ARGS'][vIndex] = SKIN:ParseFormula(vArg)
-- *		return args[1]
-- *		end, --break;
-- *	default = function(args) --default:
-- *	  mMP['ARGS'][vIndex] = vArg
-- *		return args[1]
-- *		end, --break;
-- *  }
-- * )
-- *Case = Table:case(vType:lower(), 'I am arg[1]') --switch input
-- */
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
function switch(tbl)
	tbl.case = function(...) --define case property
		local t = table.remove(arg,1)
		local f = t[arg[1]] or t.default
		local ret = -999
		if f then
			if type(f) == 'function' then
				ret = f(arg)
			else
				DebugPrint('Case: ' .. tostring(x) .. ' not a function','Warning')
			end
		end
  	return(ret)
	end
	return tbl
end
-------------------------------------------------------------------------------
--/**
-- * provide debug logging functions
-- */
function DebugPrint(strMsg,strErrorLevel)
  strHeader=vLogHeader..': '
  strMessage=strHeader..strMsg
  strEL='Debug' --default
  --
  if(strErrorLevel) then
    strEL=strErrorLevel
  end
  SKIN:Bang(bL,strMessage,strEL)
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- End of line.
-------------------------------------------------------------------------------
