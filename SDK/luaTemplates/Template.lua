-------------------------------------------------------------------------------
-- Name=Template - Dark .lua Script Template
-- Author=Darkstrumn
-- Description=
-- Version=0.0.2 - 140830.14:: added more aliases
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- Details=The template is the basis of all other scripts.
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- [mLuaScriptTemplate]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#Template.lua"
-- ;-- configs:
-- LuaOptionName=315
-- ;(OPTIONAL)MeasureAlias=#MEASURE.MeasureAlias#
-- ;(OPTIONAL)MeterAlias=#METERS.MeterAlias#
-- ;(optional)ListBaseName=Argument;<<--override name of argument list (symantic)
-- ;(optional)ArgumentListLength=2;<<--override and limit the active arguments
-- Argument1="MeasureString|mTopProcess"
-- Argument2="String|Hello World"
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
  This = SELF:GetName()
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
	ret = varWorkflowHandler()
	--<callable based on state. Remove comment for direct call>ret = Process()
--DebugPrint('Process:'..ret,'Warning')
	return (ret)
end --</Update()>
-------------------------------------------------------------------------------
-- WorkflowHandler: handles state changes and workflow processing based on state
-------------------------------------------------------------------------------
function varWorkflowHandler()
  -- intState is the NanoCore state machine state. Set the % to the max state limit 
	Variable = 'State'..intState --toString() the state and prefix with that verbiage "stateX"
	-- state controls factory action
	-- using an emulated switch function, we control factory operations
	Table = switch({
		state0 = function(args)
		  --Init
    	intState = intLimiter(intState, intMaxStateBoundry)
    	--<reserved for future use>intState = intLimiter(intState, intMaxStateBoundry)
			--<reserved for future use>intState = 900 --shutdown script, we currently only initiaze the skin, but process handling can be done in this handler
			return args[1]
			end, --state1
		state1 = function(args)
		  --Init monitored processes, load into tracking tables and move to next state
		  if(NumMonitoredProcs > 0) then
      	for intIndex=1,NumMonitoredProcs do
      		mMP[intIndex]=SKIN:GetMeasure('mMonitoredProcess'..intIndex)
      	end--</for>
      end --</if>
    	intState = intLimiter(intState, intMaxStateBoundry)
			return args[1]
			end, --state2
		state2 = function(args)
		  --Init monitored processes, load into tracking tables and move to next state
		  if(NumMonitoredProcs > 0) then
		    ret = Process()
      	--for intIndex=1,NumMonitoredProcs do
      	--	mMP[intIndex]=SKIN:GetMeasure('mMonitoredProcess'..intIndex)
      	--	if iMP[i]~=mMP[i]:GetValue() then
      	--		iMP[i]=mMP[i]:GetValue()
      	--		if iMP[i]==1 then
      	--			--SKIN:Bang(bSO,'MeterP'..i,'ImageName','#@#Images\\On','SKINNAME\\Launcher')
      	--		else
      	--			--SKIN:Bang(bSO,'MeterP'..i,'ImageName','','SKINNAME\\Launcher')
      	--		end
      	--		--SKIN:Bang(bUMT,'MeterP'..i,'SKINNAME\\Launcher')
      	--	end
      	--end--</for>
      end --</if>
    	--intState = intLimiter(intState, intMaxStateBoundry)
			return args[1]
			end, --state2
		state900 = function(args)
		  --resume from halted state, setting state to resumeState value
    	intState = (SELF:GetNumberOption('resumeState') % 5) + 1
			return args[1]
			end, -- state900
		state999 = function(args)
		  --enter halt state, remove from processing queue
    	intState = -1 --terminated state type I\\job done, no cleanup.
			SKIN:Bang(bDC,'HiveControl\\DarkCore\\TypeV\\DarkCoreMCP')
			return args[1]
			end, -- state999
		default = function(args)
		  --halt further processing, nothing to due so we free up some cycles
    	--intState = -1 --terminated state type II\\halted state, (must add resume detection to come out of halted state)
			return args[1]
			end, -- default
	})
	Case = Table:case(Variable:lower(), 'Example text.')
	return(intState)
end --</varWorkflowHandler()>
-------------------------------------------------------------------------------
function Process()
	-- ret can contain diagnostic info that can be seen in the debugger as the measure value\\string
	ret = 1
--Work of the script here
	-----------------------------------------------------------------------------
	-- handle dynamic vars that may have changed between the init and now
	--vAID = tonumber(SELF:GetOption('AngleInDegrees', '360'))
	--iCCW = SKIN:GetVariable('CURRENTCONFIGWIDTH',0)
	--iCCH = SKIN:GetVariable('CURRENTCONFIGHEIGHT',0)
	--vTOX = (1*tonumber(SELF:GetOption('TxOffsetX', 0)))+(iCCW/2)
	--vTOY = (1*tonumber(SELF:GetOption('TyOffsetY', 0)))+(iCCH/2)
	--
	for vIndex = 1,(table.getn(mMP['MPU'])) do
		--fetch singular unit of work to process
		vMN = SELF:GetOption(vMpBaseName..vIndex, 'NULL')
		--mMP['MPU'][vIndex] = SKIN:GetMeasure(vMN,vMESA)
		--mMP['MPU'][vIndex] = SKIN:GetMeter(vMN,vMETA)
		-- Process work based on content of target, (tracked)
		if mMP['state'][vIndex] ~= (mMP['MPU'][vIndex]:GetValue()) then
			mMP['state'][vIndex] = (mMP['MPU'][vIndex]:GetValue())
			-- Processing of the content//TASK---------------------------------------
			-- modify stuff...Meter or Measure, etc.
			--<disarmed> SKIN:Bang(bSO,vMN,'TransformationMatrix',vCosAngle..'; '..vNegSinAngle..'; '..vSinAngle..'; '..vCosAngle..'; '..vTX..'; '..vTY)
			-- /TAST-----------------------------------------------------------------
			-- Do updates for any meters, etc. that where modified,(singular result of looped processing)
			--<disarmed> SKIN:Bang(bUMT,mMP['MPU'][vIndex])
		end --</if>
	end --</for>
	-----------------------------------------------------------------------------
--Customize for end result meter updates, (singular result non looped processing)
	--<disarmed> SKIN:Bang(bUMT,vMETA)
--DebugPrint('LuaTemplate: Updates applied...','Debug')
	return(ret)
end --</Process()>
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
          DebugPrint('last element reached, done.','Debug')    
          break
        end --</if(not intStart)>
        tblResult[#tblResult + 1] = string.sub(strInput, intWatermark, intStart - 1)
        DebugPrint('found element['..#tblResult..']: '..string.sub(strInput, intWatermark, intStart - 1)..'.','Warning')    
        intWatermark = intEnd + 1
        if ((#tblResult + 1) >= intLimit) then 
          DebugPrint('limit reached, done.','Debug')    
          break
        end --</if(n == intLimit - 1)>
    end --</while (true)>
    --make remainder the last element, if present
    if (intWatermark <= string.len(strInput)) then
        tblResult[#tblResult+1] = string.sub(strInput, intWatermark)
    end --</if (intWatermark <= string.len(strInput))>
    --<diagnostics>
    DebugPrint('found '..(#tblResult)..' elements.','Debug')    
    for vIndex = 1,#tblResult do
      DebugPrint('element['..vIndex..'] :: '..(tblResult[vIndex])..'.','Warning')
    end --</for vIndex = 1,#tblResult>
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
