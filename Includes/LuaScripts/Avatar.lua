-------------------------------------------------------------------------------
-- Name=ScriptName
-- Author=Darkstrumn
-- Description=Script Colour changing affect based on ranges provided 
-- Version=0.0.1
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-------------------------------------------------------------------------------
function Initialize()
	bSO='!SetOption'
	bUMT='!UpdateMeter'
	bL='!Log'
	vWD=SKIN:GetVariable('PIPWedgeDepth',3)
	mMP={} --monitored-process measures
	iMP={} --state tracking for monitored-process
	for intIndex=1,8 do
		mMP[intIndex]=SKIN:GetMeasure('mCore0'..intIndex)
	end--</for>
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	return (Process())
end --</Update()>
-------------------------------------------------------------------------------
function Process()
ret=0
	for intIndex=1,8 do
		--<core activity monitory display>
		mMP[intIndex]=SKIN:GetMeasure('mCore0'..intIndex,'#METERS.SUBCOREPROCESSING#')
		--<diagnostics>mMP[intIndex]=SKIN:GetMeasure('mOrbitController'..intIndex,'#METERS.SUBCOREPROCESSING#')
		if iMP[intIndex]~=(mMP[intIndex]:GetValue()) then
			iMP[intIndex]=(mMP[intIndex]:GetValue())
			if iMP[intIndex]>ret then ret=iMP[intIndex] end
			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentHi','89')) then
				SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineColor',SELF:GetOption('LineColorHiPercent','#ColourRedA160#'))
			else
  			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentMed','74')) then
  				SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineColor',SELF:GetOption('LineColorMedPercent','#ColourYellowA160#'))
  			else
    			if iMP[intIndex]>=tonumber(SELF:GetOption('PercentLow','49')) then
    				SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineColor',SELF:GetOption('LineColorLowPercent','#ColourLimeA160#'))
    			else
    				SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineColor',SELF:GetOption('LineColorOK','#ColourSkyA160#'))
    			end
  			end
			end
			--Thicken bar as value increases, thin as it decreases
			--DebugPrint(tostring(intIndex-1)..' LineStart: #PIP'..tostring(intIndex-1)..'SO#')
			--DebugPrint(tostring(intIndex-1)..' LineLength: #PIP'..tostring(intIndex-1)..'LL#+'..tostring(iMP[intIndex]))
    	--SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineStart','#PIP'..tostring(intIndex-1)..'SO#')
    	--SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineLength','#PIP'..tostring(intIndex-1)..'LL#+'..tostring(iMP[intIndex]))
    	--variant
    	--SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineStart',(iMP[intIndex]/10))
    	--SKIN:Bang(bSO,'DarkCoreRing2_'..(intIndex-1),'LineLength',(iMP[intIndex]/10)+vWD)
			SKIN:Bang(bUMT,'DarkCoreRing2_'..(intIndex-1))
		end --</if>
	end --</for>
	return(1)
end --</Process()>

function DebugPrint(msg,errorLevel)
  header='AvatarLog: '
  message=header..msg
  el='Notice'
  if(errorLevel) then
    el=errorLevel
  end--</if>
  SKIN:Bang(bL,message,el)
end--</DebugPrint()>
-------------------------------------------------------------------------------
