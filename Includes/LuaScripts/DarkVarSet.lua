-------------------------------------------------------------------------------
-- Name=Dark Var Set
-- Author=Darkstrumn
-- Description=
-- Version=0.0.0 - 150221.03
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- Details=!SetVariable seems to have issues setting dynamic variables to a value, this is to compensate
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- [mSetGrpName]
-- Group=[mDarkCoreTypeVIII]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#DarkVarSet.lua"
-- MeasureName=mSetGrpName;<<--self reference, set this to the same name as this measure
-- ;-- configs:
-- varName=_Group;<<--the name of the variable that will hold the computed group name
-- varIndex=;<<-- defaults to 0, but is the index of the varName, ie _Group0,_Group1,... .
-- varValue=DarkCoreTypeVIII;<<--the name of the group, (optional self documenting, the OnLoad will override this)
-- varDestObj=mDarkCoreTypeVIII;<<--the measure\\meter serving as the main block\section of the skin-module that(optional self documenting, the OnLoad will override this)
-- varDestOpt=String;<<--works with the above option and is option of the DestObj, this will typically be "String" (optional self documenting, the OnLoad will override this)
-- DynamicVariables=1
-- UpdateDivider=-1
-- -- ;------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- demo
----------------------------------------------------------------------------------
-- [mDarkCoreTypeVIII]
-- Measure=STRING
--
-- [variables]
-- -- vCoreUsageState=-1
-- ;------------------------------------------------------------------------------

-- ;------------------------------------------------------------------------------
-- [mDarkCoreOnLoad]
-- Group=[mDarkCoreTypeVIII]
-- Measure=calc
-- Formula=0
-- ;-- Init\\Register group
-- IfCondition0=(#vDarkCoreState# = -1)
-- ;--these can be on one line, spread out for clarity
-- IfTrueAction00=[!SetVariable vGroupName "DarkCore"];<<--using variable to set value once for automation
-- IfTrueAction01=[!SetOption mSetGrpName varValue "grp#vGroupName#"];<<--fabricate group name using variable
-- IfTrueAction02=[!SetOption mSetGrpName varDestObj "mDarkCoreTypeVIII"];<<--specify main group block\\section
-- IfTrueAction03=[!SetOption mSetGrpName varDestOpt "String"];<<--specify the option name to store the reference to the groupname in
-- IfTrueAction04=[!UpdateMeasure "mSetGrpName"];<<--update to "run" the script and set the dynamic groupname
-- ;--reset index = [!SetOption mSetGrpName varIndex 0]
-- ;-- Diagnostics
-- IfTrueAction1=[!Log "**Registering group(#vGroupName#)..."]
-- ;-- Finish\\Running
-- IfCondition10=(#vDarkCoreState# < 0)
-- IfTrueAction11=[!SetVariable vDarkCoreState 0][!DisableMeasure "m#vGroupName#OnLoad"];<<--end function, disable OnLoad "function" Measure
-- ----------------------------------------------------------------------------------
-- /demo
----------------------------------------------------------------------------------

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
	vMe = SELF:GetOption('MeasureName', 'mDarkVarSet')
	vName = SELF:GetOption('varName', '_Group')
	vIndex = SELF:GetOption('varIndex', '')
	vValue = SELF:GetOption('varValue', '')
	vDestObj = SELF:GetOption('varDestObj', '')
	vDestOpt = SELF:GetOption('varDestOpt', '')
	vMESA = SELF:GetOption('MeasureAlias', '#THISFILE#')
	vMETA = SELF:GetOption('MeterAlias', '#THISFILE#')
	vMpBaseName = SELF:GetOption('ListBaseName', 'TargetMeter')
	vLoopSize = SELF:GetOption(vMpBaseName..'Length', '0')
	mMP = {} --monitored-process measures
	mMP['MPU'] = {} --state tracking for monitored-process-unit
	mMP['state'] = {} --state tracking for monitored-process
	for vIndex = 1,vLoopSize do
		vMN = SELF:GetOption(vMpBaseName..vIndex, 'NULL')
		mMP['MPU'][vIndex] = SKIN:GetMeter(vMN)
		--state change to running
		mMP['state'][vIndex] = 0
	end--</for>
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	ret = Process()
DebugPrint('Process:'..ret,'Warning')
	return (ret)
end --</Update()>
-------------------------------------------------------------------------------
function Process()
	-- ret can contain diagnostic info that can be seen in the debugger as the measure value\\string
	ret = 1
--Work of the script here
	-----------------------------------------------------------------------------
	vName = SELF:GetOption('varName', '_Group')
	vIndex = SELF:GetOption('varIndex', '0')
	if string.len(vIndex) == 0 then vIndex = 0 end
	vValue = SELF:GetOption('varValue', '')
	vDestObj = SELF:GetOption('varDestObj', '')
	vDestOpt = SELF:GetOption('varDestOpt', '')
	destinationVar = vName..vIndex
DebugPrint('destinationVar:'..destinationVar,'Notice')
	SKIN:Bang(bSV,destinationVar,vValue)
	SKIN:Bang(bSO,vMe,'varIndex', tonumber(vIndex)+1)
	ret = SKIN:GetVariable(destinationVar, 'Failed to find Var:'..destinationVar)
DebugPrint('vDestObj:'..vDestObj,'Notice')
DebugPrint('vDestOpt:'..vDestOpt,'Notice')
	if(vDestObj ~= '') and (vDestOpt ~= '') then
	  SKIN:Bang(bSO,vDestObj,vDestOpt, destinationVar)
	  vMN = SELF:GetOption(vDestObj, 'NULL')
	  testSkin = SKIN:GetMeter(vMN)
	  testVal=testSkin:GetOption(vDestOpt, 'NULL')
DebugPrint('testVal:'..testVal,'Notice')
--DebugPrint('Setting skin:'..vDestObj..' option:'..vDestOpt..':'..testVal,'Notice')
	end--</if>
DebugPrint('Updated varIndex:'..SELF:GetOption('varIndex', ''),'Notice')
DebugPrint('ret:'..ret,'Notice')
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
