-------------------------------------------------------------------------------
-- Name=Processing Repeater - repeat processing across specified meters\\measures\\variables
-- Author=Darkstrumn
-- Description=
-- Version=0.0.1 - 140824.00:: initial build
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- Details=Targets A are specifed to be acted upon by Targets B. A may or may not be like, but are likely a group
-- and B is the action to happen to each item of A the same, such as transformation matrix application, etc.
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- [mLuaScriptTemplate]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#Template.lua"
-- ;-- configs:
-- LuaOptionName=315
-- (OPTIONAL)MeasureAlias=#MEASURE.MeasureAlias#
-- (OPTIONAL)MeterAlias=#METERS.MeterAlias#
-- #Need at least 1 item 
-- InputMeasureListLength=6
-- #Need at least 1 indexed item eg. InputMeasure1
-- InputMeasure1=mDarkCorePrime
-- InputMeasure2=mDarkCorePrime
-- InputMeasure3=mDarkCorePrime
-- InputMeasure4=mDarkCorePrime
-- InputMeasure5=mDarkCorePrime
-- InputMeasure6=mDarkCorePrime
-- ActionMeasure=mColorCoreUsage
-- #Need at least 1 indexed item eg. InputMeasure1
-- InputMeasure1=mDarkCorePrime
-- InputMeasure2=mDarkCorePrime
-- InputMeasure3=mDarkCorePrime
-- InputMeasure4=mDarkCorePrime
-- InputMeasure5=mDarkCorePrime
-- InputMeasure6=mDarkCorePrime
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
	bSO='!SetOption'
	bGO='!GetOption'
	bSOG='!SetOptionGroup'
	-- Variables
	bSV='!SetVariable'
	bWKV='!WriteKeyValue'
	-- Skins\\Configs
	bAC='!ActivateConfig'
	bDC='!DeactivateConfig'
	-- General Skin Actions (GSA)
	bUD='!Update'
	bRF='!Refresh'
	bRD='!Redraw'
	--Measure
	bUMS='!UpdateMeasure'
	bUMSG='!UpdateMeasureGroup'
	bCM='!CommandMeasure'
	-- Meter
	bSM='!ShowMeter'
	bHM='!HideMeter'
	bTM='!ToggleMeter'
	bMM='!MoveMeter'
	bUMT='!UpdateMeter'
	bHMG='!HideMeterGroup'
	bTMG='!ToggleMeterGroup'
	bUMTG='!UpdateMeterGroup'
	--Logs
	bL='!Log'
	--Read Lua option config\\var data
	vLocalVarName=SELF:GetOption('LuaOptionName', 'DefaultTValue')
	vMESA=SELF:GetOption('MeasureAlias', '#THISFILE#')
	vMETA=SELF:GetOption('MeterAlias', '#THISFILE#')
	vMpBaseName=SELF:GetOption('ListBaseName', 'TargetMeter')
	vLoopSize=SELF:GetOption(vMpBaseName..'Length', '1')
	mMP={} --monitored-process measures
	iMP={} --state tracking for monitored-process
	for intIndex=1,vLoopSize do
		vMN=SELF:GetOption(vMpBaseName..intIndex, 'NULL')
		mMP[intIndex]=SKIN:GetMeasure(vMN)
		--mMP[intIndex]=SKIN:GetMeter(vMN)
	end--</for>
DebugPrint('vLocalVarName:'..vLocalVarName,'Warning')
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	return (Process())
end --</Update()>
-------------------------------------------------------------------------------
function Process()
	-- ret can contain diagnostic info that can be seen in the debugger as the measure value\\string
	ret=1
--Work of the script here
	-----------------------------------------------------------------------------
	-- handle dynamic vars that may have changed between the init and now
	vAID=tonumber(SELF:GetOption('AngleInDegrees', '360'))
	iCCW=SKIN:GetVariable('CURRENTCONFIGWIDTH',0)
	iCCH=SKIN:GetVariable('CURRENTCONFIGHEIGHT',0)
	vTOX=(1*tonumber(SELF:GetOption('TxOffsetX', 0)))+(iCCW/2)
	vTOY=(1*tonumber(SELF:GetOption('TyOffsetY', 0)))+(iCCH/2)
	--
	for intIndex=1,(table.getn(mMP)) do
		--fetch singular unit of work to process
		vMN=SELF:GetOption(vMpBaseName..intIndex, 'NULL')
		mMP[intIndex]=SKIN:GetMeasure(vMN,vMA)
		--mMP[intIndex]=SKIN:GetMeter(vMN,vMA)
		-- Process work based on content of target, (tracked)
		if iMP[intIndex]~=(mMP[intIndex]:GetValue()) then
			iMP[intIndex]=(mMP[intIndex]:GetValue())
			-- Processing of the content//TASK---------------------------------------
			-- modify stuff...Meter or Measure, etc.
			--<disarmed> SKIN:Bang(bSO,vMN,'TransformationMatrix',vCosAngle..'; '..vNegSinAngle..'; '..vSinAngle..'; '..vCosAngle..'; '..vTX..'; '..vTY)
			-- /TAST-----------------------------------------------------------------
			-- Do updates for any meters, etc. that where modified,(singular result of looped processing)
			--<disarmed> SKIN:Bang(bUMT,mMP[intIndex])
		end --</if>
	end --</for>
	-----------------------------------------------------------------------------
--Customize for end result meter updates, (singular result non looped processing)
	--<disarmed> SKIN:Bang(bUMT,'MeterName')
--DebugPrint('LuaTemplate: Updates applied...','Debug')
	return(ret)
end --</Process()>
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
