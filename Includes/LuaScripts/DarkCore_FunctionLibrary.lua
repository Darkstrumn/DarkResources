-------------------------------------------------------------------------------
-- Name=DarkCore-FL - DarkCore-Function Libary
-- Author=Darkstrumn
-- Description=
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
  			end, --break;
  		float = function(args) --case float:
  		  mMP['ARGS'][vIndex] = tonumber(vArg)
DebugPrint('Handled as float','Notice')
  			return args[1]
  			end, --break;
--  		measure = function(args) --case measure:
--  		  mMeasure = SKIN:GetMeasure(vArg)
--  		  mMP['ARGS'][vIndex] = mMeasure --<<--object
--DebugPrint('Handled as measure','Notice')
--  			return args[1]
--  			end, --break;
  		measurefloat = function(args) --case measureFloat:
  		  mMeasure = SKIN:GetMeasure(vArg)
  		  mMP['ARGS'][vIndex] = tonumber(mMeasure:GetValue())
DebugPrint('Handled as measurefloat','Notice')
  			return args[1]
  			end, --break;
  		measurestring = function(args) --case measureString:
  		  mMeasure = SKIN:GetMeasure(vArg)
  		  mMP['ARGS'][vIndex] = mMeasure:GetStringValue()
DebugPrint(mMP['ARGS'][vIndex],'Warning')
DebugPrint('Handled as measurestring','Notice')
  			return args[1]
  			end, --break;
--  		meter = function(args) --case meter:
--  		  mMP['ARGS'][vIndex] = SKIN:GetMeter(vArg)
--DebugPrint('Handled as meter','Notice')
--  			return args[1]
--  			end, --break;
      variable = function(args) --case variable:
  		  mMP['ARGS'][vIndex] = SKIN:GetVariable(vArg)
DebugPrint('Handled as variable','Notice')
  			return args[1]
  			end, --break;
      formula = function(args) --case formula:
  		  mMP['ARGS'][vIndex] = SKIN:ParseFormula(vArg)
DebugPrint('Handled as formula','Notice')
  			return args[1]
  			end, --break;
  		default = function(args) --default:
  		  mMP['ARGS'][vIndex] = vArg
DebugPrint('Handled as default','Notice')
  			return args[1]
  			end, --break;
  	  }
  	 )
  	Case = Table:case(vType:lower(), 'measure')
DebugPrint('Value:'..mMP['ARGS'][vIndex],'Warning')
		--state change to running
		mMP['state'][vIndex] = 0
	end--</for>
--
end --</Initialize()>
-------------------------------------------------------------------------------
-- Update: Here we tie-in to the update event and do our work every "cycle"
-------------------------------------------------------------------------------
function Update()
  ret = -1
	--ret = varWorkflowHandler()
	--<callable based on state. Remove comment for direct call>ret = Process()
--DebugPrint('Process:'..ret,'Warning')
	return (ret)
end --</Update()>
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
        end --</if(not intStart)>
        tblResult[#tblResult + 1] = string.sub(strInput, intWatermark, intStart - 1)
        --DebugPrint('found element['..#tblResult..']: '..string.sub(strInput, intWatermark, intStart - 1)..'.','Warning')    
        intWatermark = intEnd + 1
        if ((#tblResult + 1) >= intLimit) then 
          --DebugPrint('limit reached, done.','Debug')    
          break
        end --</if(n == intLimit - 1)>
    end --</while (true)>
    --make remainder the last element, if present
    if (intWatermark <= string.len(strInput)) then
        tblResult[#tblResult+1] = string.sub(strInput, intWatermark)
    end --</if (intWatermark <= string.len(strInput))>
    --<diagnostics>
    --DebugPrint('found '..(#tblResult)..' elements.','Debug')    
    --for vIndex = 1,#tblResult do
    --  DebugPrint('element['..vIndex..'] :: '..(tblResult[vIndex])..'.','Warning')
    --end --</for vIndex = 1,#tblResult>
    return tblResult, #tblResult
end --</explode(strDelim, strInput, intLimit)>
-------------------------------------------------------------------------------
--/**
-- * used to increment state, and keep state machine within sane ranges
-- */
function intLimiter(intValue,intLimit)
	return((intValue % intLimit) + 1)
end --</intLimiter(intValue,intLimit)>
-------------------------------------------------------------------------------
--/**
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
			end -- </if (type(f))>
		end -- </if (f)>
  	return(ret)
	end -- </tbl.case()>
	return tbl
end --</switch(tbl)>
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
  end--</if>
  SKIN:Bang(bL,strMessage,strEL)
end--</DebugPrint()>
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- End of line.
-------------------------------------------------------------------------------
