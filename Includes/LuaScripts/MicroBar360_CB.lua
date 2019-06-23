-------------------------------------------------------------------------------
-- Name=MicroBar-360 Construction Block
-- Author=strumn
-- Description= builds a MicroBar-360 MeterNode connected to the specified measure
-- Version=0.0.2 - 140830.14:: added more aliases
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- Details=The template is the basis of all other scripts.
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- [mMicroBarLua]
-- Measure=Script
-- ScriptFile=#GLOBALS.INCLUDES.LUASCRIPTS#MicroBar360_CB.lua
-- IfCondition=testParseParent <= 0
-- IfTrueAction = [!CommandMeasure "mMicroBarLua" "DebugPrint('Hello World MB360!','Debug')"]
-- UpdateDivider=0 ;<<--one-shot
-- UpdateDivider=-1
-- DynamicVariables=1
-- ;------------------------------------------------------------------------------
-- ============================================================================
-------------------------------------------------------------------------------
-- Initialize: we define some aliases here for often used items, mostly bang commands and the like.
-------------------------------------------------------------------------------
function Initialize()
	bSO='!SetOption'
	bSV='!SetVariable'
	bUMT='!UpdateMeter'
	bL = '!Log'
	--
  vGaugeThickness = 5.0
  vGaugeDepth = 5
  vGaugeLStartOrigin = 28
  vGaugeLLengthOrigin = vGaugeLStartOrigin + vGaugeDepth
  vGaugeIndex = 0
  vGauge0SO = (vGaugeLLengthOrigin) + (((vGaugeLLengthOrigin + 1) - vGaugeLStartOrigin) * vGaugeIndex)
  vGauge0LL = (vGaugeLStartOrigin) + (((vGaugeLLengthOrigin + 1) - vGaugeLStartOrigin) * vGaugeIndex)
  vColourBlackA255 = '0, 0, 0, 255'
  vAngle = (((360/12)*12)-90)
	--
	vRet = 'Hello World Exit!'
	--Read Lua option config\\var data
	vLogHeader = SELF:GetOption('LogHeader', 'ScriptNode')
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	return (vRet)
end --</Update()>
-------------------------------------------------------------------------------
--/**
-- * provide string manipulation functions
-- */
function setRet(strMsg)
  vRet = strMsg
end --</setRet(strMsg)>
-------------------------------------------------------------------------------
--/**
-- * provide debug logging functions
-- */
function DebugPrint(strMsg,strErrorLevel)
  strHeader=vLogHeader..': '
  strMessage=strHeader..strMsg
  setRet(strMsg)
  strEL='Debug' --default
  --
  if(strErrorLevel) then
    strEL=strErrorLevel
  end --</if>
  --
  SKIN:Bang(bL,strMessage,strEL)
end--</DebugPrint()>
-------------------------------------------------------------------------------
--helper functions (refactored)
-------------------------------------------------------------------------------
--/**
-- * provide variable manipulation functions
-- */
function setVar(varName,varValue)
  SKIN:Bang(bSV,varName,varValue)
end --</setVar(varName,varValue)>
-------------------------------------------------------------------------------
--/**
-- * provide measure\meter manipulation functions
-- */
function setOption(varTargetName,varOption,varValue)
  SKIN:Bang(bSO,varTargetName,varOption,varValue)
end --</setOption(varName,varValue)>
-------------------------------------------------------------------------------
--/**
-- * provide measure\meter manipulation functions base settings
-- */
function baseSection(vName,vX,vY,vW,vH)
  vMeter = SKIN:GetMeter(vName)
  vRet = -1
  --
  if vMeter == nil then
    DebugPrint('baseMeter\\'..vName..':\\not found::true','Debug')
  else
    setOption(vName,'X',vX)
    setOption(vName,'Y',vY)
    setOption(vName,'W',vW)
    setOption(vName,'H',vH)
    vRet = 0
  end --</if>
  --
  return (vRet) 
end --</baseSection(vName,vX,vY,vW,vH)
-------------------------------------------------------------------------------
--build MicroBar Complete
-------------------------------------------------------------------------------
function buildAll(vName,vX,vY,vW,vH,vAngle,vDotColour,vBarColour,vBarTrimColour,vMeasure,vPercentLow,vPercentMed,vPercentHi,vLineColorHiPercent,vLineColorMedPercent,vLineColorLowPercent,vLineColorHiPercent2,vLineColorMedPercent2,vLineColorLowPercent2,vDefaultLineGraphColour,vDefaultTextGraphColour,vDefaultAuxLineGraphColour,vLineGraphColour,vTextGraphColour,vAuxLineGraphColour
  buildDot(vName..'Dot',vX,vY,vW,vH,vAngle,vDotColour)
  buildBGTrim(vName..'Trim',vX,vY,vW,vH,vAngle,vBarTrimColour)
  buildBG(vName..'BG',vX,vY,vW,vH,vAngle,vColourBlackA255)
  buildMicroBarGraph(vName,vMeasure,vX,vY,vW,vH,vAngle,vColour)
  buildMBLabel(vName..'Lbl',vMeasure,vX,vY,vAngle,vColour)
  buildMBColourizer(vMeasure,vPercentLow,vPercentMed,vPercentHi,vLineColorHiPercent,vLineColorMedPercent,vLineColorLowPercent,vLineColorHiPercent2,vLineColorMedPercent2,vLineColorLowPercent2,vDefaultLineGraphColour,vDefaultTextGraphColour,vDefaultAuxLineGraphColour,vLineGraphColour,vTextGraphColour,vAuxLineGraphColour)
end
-------------------------------------------------------------------------------
--build Angle
-------------------------------------------------------------------------------
[mMicroBarAngle]
Measure=Calc
Formula=(((((#vGuageStartAngle# + (#vGuageInterval# * 0)) % #vRadialResolution#) + 1) - 3) * (PI * 2) / #vRadialResolution#)
UpdateDivider=0
-------------------------------------------------------------------------------
--build X
-------------------------------------------------------------------------------
[mMicroBarX]
Measure=Calc
Formula=(#vRadius# * (#vRadiusScale# - (mcoreTemp0 / 100)) * COS(mGuage1Angle))
UpdateDivider=0
-------------------------------------------------------------------------------
--build Y
-------------------------------------------------------------------------------
[mMicroBarY]
Measure=Calc
Formula=(#vRadius# * (#vRadiusScale# - (mcoreTemp0 / 100)) * SIN(mGuage1Angle))
UpdateDivider=0
-------------------------------------------------------------------------------
--build Dot
-------------------------------------------------------------------------------
-- [microBarDot]
-- Meter=ROUNDLINE
-- X=0
-- Y=0
-- W=80
-- H=80
-- LineWidth=(#vGaugeThickness#)
-- LineLength=(((#vGauge0LL#) + 3) + (#vGaugeThickness#))
-- LineStart=(#vGauge0LL# + 3)
-- StartAngle=(Rad(#vAngle#))
-- AntiAlias=1
-- LineColor=#vTrimLineGraphColour#
-- Solid=0
-- DynamicVariables=1
--
-- minimum required definition for meter section (these are values !setOption can't manipulate)
-- [microBar0Dot]
-- Meter=ROUNDLINE
--
function buildDot(vName,vX,vY,vW,vH,vAngle,vColour)
  DebugPrint('buildDot\\'..vName..':\\vAngle::'..vAngle..'','Debug')
  baseSection(vName,vX,vY,vW,vH)
  setOption(vName,'LineWidth',(vGaugeThickness) )
  setOption(vName,'LineLength',(((vGauge0LL) + 3) + (vGaugeThickness)) )
  setOption(vName,'LineStart',(vGauge0LL) )
  setOption(vName,'StartAngle',(math.rad(tonumber(vAngle))) )
  setOption(vName,'AntiAlias',1)
  setOption(vName,'LineColor',vColour)
  setOption(vName,'Solid',0)
  setOption(vName,'DynamicVariables',1)
  DebugPrint('buildDot\\'..vName..':\\set::true','Debug')
end --</buildDot(vName,vX,vY,vW,vH,vAngle,vColour)>
-------------------------------------------------------------------------------
--build Background-Trim
-------------------------------------------------------------------------------
-- [microBarBGTrim]
-- Meter=ROUNDLINE
-- X=0
-- Y=0
-- W=80
-- H=80
-- LineWidth=(#vGaugeThickness#+1)
-- LineLength=(#vGauge0LL#)
-- LineStart=0
-- StartAngle=(Rad(#vAngle#))
-- LengthShift = (#vGauge0LL#)
-- AntiAlias=1
-- LineColor=#vTrimLineGraphColour#
-- Solid=0
-- ControlLength=0
-- ControlAngle=0
-- DynamicVariables=1
function buildBGTrim(vName,vX,vY,vW,vH,vAngle,vColour)
  DebugPrint('buildBGTrim\\'..vName..':\\vAngle::'..vAngle..'','Debug')
  baseSection(vName,vX,vY,vW,vH)
  setOption(vName,'LineWidth',(vGaugeThickness) )
  setOption(vName,'LineLength',(((vGauge0LL) + 3) + (vGaugeThickness)) )
  setOption(vName,'LineStart',(vGauge0LL) )
  setOption(vName,'StartAngle',(math.rad(tonumber(vAngle))) )
  setOption(vName,'AntiAlias',1)
  setOption(vName,'LineColor',vColour)
  setOption(vName,'Solid',0)
  setOption(vName,'DynamicVariables',1)
  DebugPrint('buildBGTrim\\'..vName..':\\set::true','Debug')
end --/buildBGTrim(vName,vX,vY,vW,vH,vAngle,vColour)>
-------------------------------------------------------------------------------
--build Background-
-------------------------------------------------------------------------------
-- [microBarBG]
-- Meter=ROUNDLINE
-- X=0
-- Y=0
-- W=80
-- H=80
-- LineWidth=(#vGaugeThickness#)
-- LineLength=(#vGauge0LL# - 1)
-- LineStart=1
-- StartAngle=(Rad(#vAngle#))
-- LengthShift = (#vGauge0LL#)
-- AntiAlias=1
-- LineColor=#gvColourBlackA255#
-- Solid=0
-- ControlLength=0
-- ControlAngle=0
function buildBG(vName,vX,vY,vW,vH,vAngle,vColour)
  DebugPrint('buildBG\\'..vName..':\\vAngle::'..vAngle..'','Debug')
  DebugPrint('buildBG\\'..vName..':\\set::true','Debug')
end --</buildBG(vName,vX,vY,vW,vH,vAngle,vColour)>
-------------------------------------------------------------------------------
--build MicroBar
-------------------------------------------------------------------------------
-- [microBar]
-- Meter=ROUNDLINE
-- MeasureName=mCPUCore2
-- X=0
-- Y=0
-- W=80
-- H=80
-- LineWidth=(#vGaugeThickness#)
-- LineLength=0
-- LineStart=0
-- StartAngle=(Rad(#vAngle#))
-- LengthShift = (#vGauge0LL#)
-- AntiAlias=1
-- LineColor=#gvColourWhiteA160#
-- Solid=0
-- ControlLength=1
-- ControlAngle=0
-- DynamicVariables=1
-- AverageSize=10
function buildMicroBarGraph(vName,vMeasure,vX,vY,vW,vH,vAngle,vColour)
  DebugPrint('buildMicroBarGraph\\'..vName..':\\vAngle::'..vAngle..'','Debug')
  DebugPrint('buildMicroBarGraph\\'..vName..':\\set::true','Debug')
end --</buildMicroBarGraph(vName,vMeasure,vX,vY,vW,vH,vAngle,vColour)>
-------------------------------------------------------------------------------
--build MicroBar Label
-------------------------------------------------------------------------------
-- [microBarLbl]
-- Meter=STRING
-- MeasureName=mCPUCore2
-- X=-4R
-- Y=-53R
-- FontColor=#gvColorWhiteA160#
-- FontSize=6
-- AntiAlias=1
-- ;Prefix=CPU02
-- Text=%1
-- Postfix=%
-- Angle=(Rad(#vAngle#))
-- DynamicVariables=1
function buildMBLabel(vName,vMeasure,vX,vY,vAngle,vColour)
  DebugPrint('buildMBLabel\\'..vName..':\\vAngle::'..vAngle..'','Debug')
  DebugPrint('buildMBLabel\\'..vName..':\\set::true','Debug')
end --</buildMBLabel(vName,vMeasure,vX,vY,vAngle,vColour)>
-------------------------------------------------------------------------------
--build MicroBar Colourizer
-------------------------------------------------------------------------------
-- [mMicroBarColour]
-- Measure=Script
-- ScriptFile="#GLOBALS.INCLUDES.LUASCRIPTS#GeneralThreshholdColourizer.lua"
-- MinValue=0
-- MaxValue=100
-- ;-- configs:
-- InputMeasure1=mCPUCore0
-- ;-- usasage %
-- PercentOK=0
-- percentLow=50
-- PercentMed=75
-- PercentHi=90
-- LineColorHiPercent=#gvColourRedA160#
-- LineColorMedPercent=#gvColourYellowA160#
-- LineColorLowPercent=#gvColourLimeA160#
-- LineColorHiPercent2=#gvColourRedA255#
-- LineColorMedPercent2=#gvColourYellowA255#
-- LineColorLowPercent2=#gvColourLimeA255#
-- DefaultLineGraphColour=#gvColourBlueA160#
-- DefaultTextGraphColour=#gvColorWhiteA160#
-- DefaultAuxLineGraphColour=#gvColorWhiteA160#
-- LineGraphColour="vLineGraphColour"
-- TextGraphColour="vTextGraphColour"
-- AuxLineGraphColour="vTrimLineGraphColour"
-- AverageSize=10
-- UpdateDivider=5
function buildMBColourizer(vMeasure,vPercentLow,vPercentMed,vPercentHi,vLineColorHiPercent,vLineColorMedPercent,vLineColorLowPercent,vLineColorHiPercent2,vLineColorMedPercent2,vLineColorLowPercent2,vDefaultLineGraphColour,vDefaultTextGraphColour,vDefaultAuxLineGraphColour,vLineGraphColour,vTextGraphColour,vAuxLineGraphColour)
--function buildMBColourizer()
  DebugPrint('buildMBLabel\\'..vName..':\\set::true','Debug')
	vLGC = vLineGraphColour
	vTGC = vTextGraphColour
	vAGC = vAuxLineGraphColour
	-- Processing of the content//TASK---------------------------------------
	mMeasure = SKIN:GetMeasure(vMeasure)
	vValue = (mMeasure:GetValue())
	-- modify stuff...Meter or Measure, etc.
	if vValue >= tonumber(SELF:GetOption('PercentHi',vPercentHi)) then --HIGH USAGE\\BLAZING
		SKIN:Bang(bSV,vLGC,vLineColorHiPercent)
		SKIN:Bang(bSV,vTGC,vLineColorHiPercent)
		SKIN:Bang(bSV,vAGC,vLineColorHiPercent2)
	else 
		if vValue >= tonumber(SELF:GetOption('PercentMed',vPercentMed)) then --MEDIUM USAGE\\HOT
			SKIN:Bang(bSV,vLGC,vLineColorMedPercent)
			SKIN:Bang(bSV,vTGC,vLineColorMedPercent)
			SKIN:Bang(bSV,vAGC,vLineColorMedPercent2)
		else
			if vValue >= tonumber(SELF:GetOption('PercentLow',vPercentLow)) then --LOW USAGE\\WARM
				SKIN:Bang(bSV,vLGC,vLineColorLowPercent)
				SKIN:Bang(bSV,vTGC,vLineColorLowPercent)
				SKIN:Bang(bSV,vAGC,vLineColorLowPercent2)
			else --OK\\BELOW LOW USAGE\\COLD
				SKIN:Bang(bSV,vLGC,vDefaultLineGraphColour)
				SKIN:Bang(bSV,vTGC,vDefaultTextGraphColour)
				SKIN:Bang(bSV,vAGC,vDefaultAuxLineGraphColour)
			end --</if--LOW USAGE\\WARM>
		end --</if--MEDIUM USAGE\\HOT>
	end --</if--HIGH USAGE\\BLAZING>
end --</buildMBColourizer(vMeasure,vPercentOK,vPercentLow,vPercentMed,vPercentHi,vLineColorHiPercent,vLineColorMedPercent,vLineColorLowPercent,vLineColorHiPercent2,vLineColorMedPercent2,vLineColorLowPercent2,vDefaultLineGraphColour,vDefaultTextGraphColour,vDefaultAuxLineGraphColour,vLineGraphColour,vTextGraphColour,vAuxLineGraphColour)
-------------------------------------------------------------------------------
-- End of line.
-------------------------------------------------------------------------------
