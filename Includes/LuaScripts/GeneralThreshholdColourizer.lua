-------------------------------------------------------------------------------
-- Name=GeneralThreshholdColourizer - Colourize the Meter based on threshholds from a default colour through - (green\\warm, yellow\\hot, red\\blazing), but the colours are customizable per calling measure
-- Author=Darkstrumn
-- Description=Script Colour changing affect based on ranges provided 
-- Version=0.0.1
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- [mGeneralColourizer]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#GeneralThreshholdColourizer.lua"
-- MinValue=0
-- MaxValue=100
-- ;-- configs:
-- InputMeasure1=mDarkCorePrime
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
-- ;------------------------------------------------------------------------------
-- ;-- configs: Thes are here for completeness, but should not be used, this is really only useful with 1 item, so these should be left to defaults... .
-- ;(OPTIONAL)ListBaseName=InputMeasure
-- ;#Need at least 1 item 
-- ;(OPTIONAL)InputMeasureListLength=1
-- ;#Need at least 1 indexed item eg. InputMeasure1
-- ============================================================================
function Initialize()
	bSO='!SetOption'
	bSV='!SetVariable'
	bUMT='!UpdateMeter'
	bL='!Log'
	--
	vLGC=SELF:GetOption('LineGraphColour', 'LineGraphColour')
	vTGC=SELF:GetOption('TextGraphColour', 'TextGraphColour')
	vAGC=SELF:GetOption('AuxLineGraphColour', 'AuxLineGraphColour')
	vMESA=SELF:GetOption('MeasureAlias', '#MEASURERS.MeasureAlias#')
	vMpBaseName=SELF:GetOption('ListBaseName', 'InputMeasure')
	vLoopSize=SELF:GetOption(vMpBaseName..'ListLength', '1')
	mMP={} --monitored-process measures
	iMP={} --state tracking for monitored-process
	--
	for intIndex=1,vLoopSize do
		vMN=SELF:GetOption(vMpBaseName..intIndex, 'NULL')
		mMP[intIndex]=SKIN:GetMeasure(vMN)
	end--</for>
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	return (Process())
end --</Update()>
-------------------------------------------------------------------------------
function Process()
	-- ret can contain diagnostic info that can be seen in the debugger as the measure value\\string
	ret=0
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
		-- Process work based on content of target, (tracked)
		if iMP[intIndex]~=(mMP[intIndex]:GetValue()) then
			iMP[intIndex]=(mMP[intIndex]:GetValue())
			-- Processing of the content//TASK---------------------------------------
			-- modify stuff...Meter or Measure, etc.
			if iMP[intIndex]>ret then ret=iMP[intIndex] end --Done
			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentHi','89')) then --HIGH USAGE\\BLAZING
				SKIN:Bang(bSV,vLGC,SELF:GetOption('LineColorHiPercent','#ColourRedA160#'))
				SKIN:Bang(bSV,vTGC,SELF:GetOption('LineColorHiPercent','#ColourLimeA255#'))
				SKIN:Bang(bSV,vAGC,SELF:GetOption('LineColorHiPercent2','#ColourRedA255#'))
			else 
  			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentMed','74')) then --MEDIUM USAGE\\HOT
  				SKIN:Bang(bSV,vLGC,SELF:GetOption('LineColorMedPercent','#ColourYellowA160#'))
  				SKIN:Bang(bSV,vTGC,SELF:GetOption('LineColorMedPercent','#ColourLimeA255#'))
  				SKIN:Bang(bSV,vAGC,SELF:GetOption('LineColorMedPercent2','#ColourYellowA255#'))
  			else
    			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentLow','49')) then --LOW USAGE\\WARM
    				SKIN:Bang(bSV,vLGC,SELF:GetOption('LineColorLowPercent','#ColourLimeA160#'))
    				SKIN:Bang(bSV,vTGC,SELF:GetOption('LineColorLowPercent','#ColourLimeA255#'))
    				SKIN:Bang(bSV,vAGC,SELF:GetOption('LineColorLowPercent2','#ColourLimeA255#'))
    			else --OK\\BELOW LOW USAGE\\COLD
    				SKIN:Bang(bSV,vLGC,SELF:GetOption('DefaultLineGraphColour','#ColourSkyA160#'))
    				SKIN:Bang(bSV,vTGC,SELF:GetOption('DefaultTextGraphColour','#ColorWhiteA160#'))
    				SKIN:Bang(bSV,vAGC,SELF:GetOption('DefaultAuxLineGraphColour','#ColourSkyA255#'))
    			end --</if--LOW USAGE\\WARM>
  			end --</if--MEDIUM USAGE\\HOT>
			end --</if--HIGH USAGE\\BLAZING>
			-- /TAST-----------------------------------------------------------------
		end --</if--CHANGED VALUE DETECTED>
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
  el='Notice'
  if(errorLevel) then
    el=errorLevel
  end--</if>
  SKIN:Bang(bL,message,el)
end--</DebugPrint()>
-------------------------------------------------------------------------------
