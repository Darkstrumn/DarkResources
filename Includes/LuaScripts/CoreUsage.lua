-------------------------------------------------------------------------------
-- Name=CoreUsage - Colourize the CoreUsage Meter on the DarkCore Skin
-- Author=Darkstrumn
-- Description=Script Colour changing affect based on ranges provided 
-- Version=0.0.1
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- [mColorCoreUsage]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#CoreUsage.lua"
-- MinValue=0
-- MaxValue=100
-- ;-- configs:Meter should be indexed begining with 1 for use with this .lua script
-- NumMonitoredProcesses=1
-- MpBaseName=mDarkCorePrime
-- ;-- usasage %
-- PercentOK=0
-- percentLow=25
-- PercentMed=50
-- PercentHi=75
-- LineColorHiPercent=#ColourRedA160#
-- LineColorMedPercent=#ColourYellowA160#
-- LineColorLowPercent=#ColourLimeA160#
-- LineColorHiPercent2=#ColourRedA255#
-- LineColorMedPercent2=#ColourYellowA255#
-- LineColorLowPercent2=#ColourLimeA255#
-- DefaultLineGraphColour=#ColourBlueA160#
-- DefaultTextGraphColour=#ColorWhiteA160#
-- DefaultAuxLineGraphColour=#ColourBlueA255#
-- LineGraphColour="vCULineGraphColour"
-- TextGraphColour="vCUTextGraphColour"
-- AuxLineGraphColour="vCUTrimLineGraphColour"
-- DynamicVariables=1
-- ;------------------------------------------------------------------------------
-- ============================================================================
function Initialize()
	bSO='!SetOption'
	bSV='!SetVariable'
	bUMT='!UpdateMeter'
	bL='!Log'
	--Destination vars for the output of this script processing
	vLoopSize=SELF:GetOption('NumMonitoredProcesses', '1')
	vMpBaseName=SELF:GetOption('MpBaseName', 'mDarkCorePrime')
	vLGC=SELF:GetOption('LineGraphColour', 'LineGraphColour')
	vTGC=SELF:GetOption('TextGraphColour', 'TextGraphColour')
	vAGC=SELF:GetOption('AuxLineGraphColour', 'AuxLineGraphColour')
	mMP={} --monitored-process measures
	iMP={} --state tracking for monitored-process
	for intIndex=1,vLoopSize do
		mMP[intIndex]=SKIN:GetMeasure(vMpBaseName)
	end--</for>
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	return (Process())
end --</Update()>
-------------------------------------------------------------------------------
function Process()
ret=0
	for intIndex=1,(table.getn(mMP)) do
		--<core usage display>
		--mMP[intIndex]=SKIN:GetMeasure('mDarkCorePrime'..intIndex,'#METERS.COREUSAGE#')
		mMP[intIndex]=SKIN:GetMeasure('mDarkCorePrime','#METERS.COREUSAGE#')		
		if iMP[intIndex]~=(mMP[intIndex]:GetValue()) then
			iMP[intIndex]=(mMP[intIndex]:GetValue())
			if iMP[intIndex]>ret then ret=iMP[intIndex] end
			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentHi','89')) then--HIGH USAGE\\BLAZING
				SKIN:Bang(bSV,vLGC,SELF:GetOption('LineColorHiPercent','#ColourRedA160#'))
				SKIN:Bang(bSV,vTGC,SELF:GetOption('LineColorHiPercent','#ColourRedA160#'))
				SKIN:Bang(bSV,vAGC,SELF:GetOption('LineColorHiPercent2','#ColourRedA255#'))
			else--MEDIUM USAGE\\HOT
  			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentMed','74')) then
  				SKIN:Bang(bSV,vLGC,SELF:GetOption('LineColorMedPercent','#ColourYellowA160#'))
  				SKIN:Bang(bSV,vTGC,SELF:GetOption('LineColorMedPercent','#ColourYellowA160#'))
  				SKIN:Bang(bSV,vAGC,SELF:GetOption('LineColorMedPercent2','#ColourYellowA255#'))
  			else --LOW USAGE\\WARM
    			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentLow','49')) then
    				SKIN:Bang(bSV,vLGC,SELF:GetOption('LineColorLowPercent','#ColourLimeA160#'))
    				SKIN:Bang(bSV,vTGC,SELF:GetOption('LineColorLowPercent','#ColourLimeA160#'))
    				SKIN:Bang(bSV,vAGC,SELF:GetOption('LineColorLowPercent2','#ColourLimeA255#'))
    			else --OK\\BELOW LOW USAGE\\COLD
    				SKIN:Bang(bSV,vLGC,SELF:GetOption('DefaultLineGraphColour','#ColourSkyA160#'))
    				SKIN:Bang(bSV,vTGC,SELF:GetOption('DefaultTextGraphColour','#ColorWhiteA160#'))
    				SKIN:Bang(bSV,vAGC,SELF:GetOption('DefaultAuxLineGraphColour','#ColourSkyA255#'))
    			end
  			end
			end
		end --</if>
	end --</for>
	return(1)
end --</Process()>

function DebugPrint(msg,errorLevel)
  header='CoreUsageLog: '
  message=header..msg
  el='Notice'
  if(errorLevel) then
    el=errorLevel
  end--</if>
  SKIN:Bang(bL,message,el)
end--</DebugPrint()>
-------------------------------------------------------------------------------
