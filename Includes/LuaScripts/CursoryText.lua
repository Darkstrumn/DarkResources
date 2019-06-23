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
-- [mCoreStatusDisplay0]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#Template.lua"
-- ;-- configs:
-- Message=Hello World
-- Cursor=_
-- (OPTIONAL)MeasureAlias=#MEASURE.MeasureAlias#
-- (OPTIONAL)MeterAlias=#METERS.MeterAlias#
-- #(optional)ListBaseName=TargetMeter
-- #Need at least 1 item
-- TargetMeterListLength=6
-- #Need at least 1 indexed item eg. TargetMeter1
-- TargetMeter1=ExampleMeterName
-- DynamicVariables=1
-- ;------------------------------------------------------------------------------
-- ============================================================================
-------------------------------------------------------------------------------
-- Initialize: we define some aliases here for often used items, mostly bang commands and the like.
-------------------------------------------------------------------------------
function Initialize()
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
	vMessage = SELF:GetOption('Message', 'Hi World!')
	vCursor = SELF:GetOption('Cursor', '_')
	vMESA = SELF:GetOption('MeasureAlias', '#THISFILE#')
	vMETA = SELF:GetOption('MeterAlias', '#THISFILE#')
	vMpBaseName = SELF:GetOption('ListBaseName', 'TargetMeter')
	vLoopSize = SELF:GetOption(vMpBaseName..'Length', '1')
	mMP = {} --monitored-process measures
	mMP['MPU'] = {} --state tracking for monitored-process-unit
	mMP['state'] = {} --state tracking for monitored-process
	for vIndex = 1,vLoopSize do
		vMN = SELF:GetOption(vMpBaseName..vIndex, 'NULL')
		mMP['MPU'][vIndex] = SKIN:GetMeter(vMN)
		--state change to running
		mMP['state'][vIndex] = 0
	end--</for>
DebugPrint('vMessage:'..vMessage,'Warning')
DebugPrint('vCursor:'..vCursor,'Warning')
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	ret = Process()
--DebugPrint('Process:'..ret,'Warning')
	return (ret)
end --</Update()>
-------------------------------------------------------------------------------
function Process()
	-- ret can contain diagnostic info that can be seen in the debugger as the measure value\\string
	ret = 1
--Work of the script here
	-----------------------------------------------------------------------------
	-- handle dynamic vars that may have changed between the init and now
	vBufferIndex = 0
	--
	for vIndex = 1,(table.getn(mMP['MPU'])) do
		--fetch singular unit of work to process
		vMN = SELF:GetOption(vMpBaseName..vIndex, 'NULL')
		--mMP['MPU'][vIndex] = SKIN:GetMeasure(vMN,vMESA)
		vMessage = SELF:GetOption('Message', '')
		vMessageLen = string.len(vMessage)
		--
		for vBufferIndex = 1,(vMessageLen) do
			vBuffer = string.sub(vMessage, 1, vBufferIndex)
			if (vBufferIndex == vMessageLen) then
				--state change done
				mMP['state'][vIndex] = 1
			end
			-- Process work based on content of target, (tracked)
			if mMP['state'][vIndex] == 0 then
				-- Processing of the content//TASK---------------------------------------
				--running, append cursor to output
				vBuffer = vBuffer .. vCursor
				-- /TAST-----------------------------------------------------------------
			end --</if>
			-- modify stuff...Meter or Measure, etc.
			SKIN:Bang(bSO,vMN,'Text',vBuffer)
			-- Do updates for any meters, etc. that where modified,(singular result of looped processing)
			SKIN:Bang(bUMT,vMN)
		end --</for>
		mMP['state'][vIndex] = 0
	end --</for>
	-----------------------------------------------------------------------------
--Customize for end result meter updates, (singular result non looped processing)
	--<disarmed> SKIN:Bang(bUMT,vMN)
--DebugPrint('LuaTemplate: Updates applied...','Debug')
	return(ret)
end --</Process()>
-------------------------------------------------------------------------------
function DebugPrint(msg,errorLevel)
  header = 'CoreUsageLog: '
  message = header..msg
  el = 'Debug'
  if(errorLevel) then
    el = errorLevel
  end--</if>
  SKIN:Bang(bL,message,el)
end--</DebugPrint()>
-------------------------------------------------------------------------------
