-------------------------------------------------------------------------------
-- Name=DarkCore Init
-- Author=Darkstrumn
-- Description=Skin initialization routine
-- Version=0.0.1
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- Details=The NCC is a framework for adaptive theme construction
-- The NCC Factory builds the theme components via logic and dynamically
-- constructs the theme.
-------------------------------------------------------------------------------
-- Initialize: we define some aliases here for often used items, mostly bang commands and the like.
-------------------------------------------------------------------------------
function Initialize()
	bSO='!SetOption'
	bGO='!GetOption'
	bSOG='!SetOptionGroup'
	bWKV='!WriteKeyValue'
	bSV='!SetVariable'
	bAC='!ActivateConfig'
	bDC='!DeactivateConfig'
	bUD='!Update'
	bRF='!Refresh'
	bRD='!Redraw'
	bSM='!ShowMeter'
	bHM='!HideMeter'
	bTM='!ToggleMeter'
	bUMT='!UpdateMeter'
	bHMG='!HideMeterGroup'
	bTMG='!ToggleMeterGroup'
	bUMTG='!UpdateMeterGroup'
	bUMS='!UpdateMeasure'
	bUMSG='!UpdateMeasureGroup'
	bMM='!MoveMeter'
	bCM='!CommandMeasure'
	bL='!Log'
	intState=0
	intMaxStateBoundry=5
	mMP={} --monitored-process measures
	iMP={} --state tracking for monitored-process
	NumMonitoredProcs=tonumber(SKIN:GetVariable('NumMonitoredProcs', '0'))
	--<reserved for future use>intResetSkins()
	return (0)
end --</Initialize()>
-------------------------------------------------------------------------------
-- Update: Here we tie-in to the update event and do our work every "cycle"
-------------------------------------------------------------------------------
function Update()
	return (varWorkflowHandler())
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
		  --Init, load all the main skin component meant to show on launch
		  --Making the sub-skins components allows for auto-grouping as well as modular handling and placement		  
			--<reserved for future use>result = intLoadDarkCoreClock()
			--<reserved for future use>result = intLoadDarkCoreWeather()
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
		  --if(NumMonitoredProcs > 0) then
      --	for intIndex=1,NumMonitoredProcs do
      --		mMP[intIndex]=SKIN:GetMeasure('mMonitoredProcess'..intIndex)
      --		if iMP[i]~=mMP[i]:GetValue() then
      --			iMP[i]=mMP[i]:GetValue()
      --			if iMP[i]==1 then
      --				--SKIN:Bang(bSO,'MeterP'..i,'ImageName','#@#Images\\On','SKINNAME\\Launcher')
      --			else
      --				--SKIN:Bang(bSO,'MeterP'..i,'ImageName','','SKINNAME\\Launcher')
      --			end
      --			--SKIN:Bang(bUMT,'MeterP'..i,'SKINNAME\\Launcher')
      --		end
      --	end--</for>
      --end --</if>
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
			SKIN:Bang(bDC,'HiveControl\\DarkCore\\TypeVIII\\DarkCoreMCP')
			return args[1]
			end, -- state999
		default = function(args)
		  --halt further processing, nothing to due so we free up some cylces
    	--intState = -1 --terminated state type II\\halted state, (must add resume detection to come out of halted state)
			return args[1]
			end, -- default
	})
	Case = Table:case(Variable:lower(), 'Example text.')
	return(intState)
end --</varWorkflowHandler()>
-------------------------------------------------------------------------------
-- Helper libraries
-------------------------------------------------------------------------------
function intLimiter(intValue,intLimit)
  -- used to increment state, and keep state machine within sane ranges
	return((intValue % intLimit) + 1)
end
-------------------------------------------------------------------------------
function switch(tbl)
  -- Used to emulate a switch statement
	tbl.case = function(...)
		local t = table.remove(arg,1)
		local f = t[arg[1]] or t.default
		local ret = -999
		if f then
			if type(f) == 'function' then
				ret = f(arg)
			else
				print('Case: ' .. tostring(x) .. ' not a function')
			end -- </if (type(f))>
		end -- </if (f)>
    SKIN:Bang(bangSV,'DiagValue',ret)
  	return ret
	end -- </tbl.case()>
	return tbl
end
-------------------------------------------------------------------------------
function DebugPrint(msg,errorLevel)
  header='CoreUsageLog: '
  message=header..msg
  el='Debug'
  if(errorLevel) then
    el=errorLevel
  end--</if>
  SKIN:Bang(bL,message,el)
end--</DebugPrint()>
-------------------------------------------------------------------------------
-- End of line.
-------------------------------------------------------------------------------
