-------------------------------------------------------------------------------
-- Name=Transformation Matrix 2D Rotator
-- Author=Darkstrumn
-- Description=CoreUsage - Transformation Matrix 2D Rotator derived from my Transformation Matrix Angling Template, derived from
-- 		  Transformation Matrix Guide  (Tip by Alex2539)::http://docs.rainmeter.net/tips/transformation-matrix-guide
-- Version=0.0.1 - 140817.14:: initial build
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-- ============================================================================
-- == Example of Calling Measure
-- ============================================================================
-- ;------------------------------------------------------------------------------
-- ;-- Transformation Matrix 2D Rotator
-- ;------------------------------------------------------------------------------
-- [mCUTransformationMatrix2DRotator]
-- Measure=Script
-- ScriptFile="#INCLUDES.LUASCRIPTS#TransformationMatrix2DRotator.lua"
-- ;-- configs:
-- AngleInDegrees=315
-- MeterAlias=#METERS.COREUSAGE#
-- #(optional)ListBaseName=TargetMeter
-- #Need at least 1 item
-- TargetMeterListLength=6
-- #Need at least 1 indexed item eg. TargetMeter1
-- TargetMeter1=CoreUsageDarkMatter
-- TargetMeter2=GraphCoreUsageTrim
-- TargetMeter3=GraphCoreUsage
-- TargetMeter4=GraphCoreUsageTrimInv
-- TargetMeter5=GraphCoreUsageInv
-- TargetMeter6=CoreUsage
-- DynamicVariables=1
-- ;------------------------------------------------------------------------------
-- ;-- /Transformation Matrix 2D Rotator
-- ;------------------------------------------------------------------------------
-- ============================================================================
-------------------------------------------------------------------------------
function Initialize()
	bSO='!SetOption'
	bSV='!SetVariable'
	bUMT='!UpdateMeter'
	bL='!Log'
	--Read Lua option config\\var data
	vMA=SELF:GetOption('MeterAlias', '#METERS.MeterAlias#')
	vMpBaseName=SELF:GetOption('ListBaseName', 'TargetMeter')
	vLoopSize=SELF:GetOption(vMpBaseName..'ListLength', '1')
	vLoopSize=tonumber(vLoopSize)
	mMP={} --monitored-process Meters
	iMP={} --state tracking for monitored-process
	for intIndex=1,vLoopSize do
		vMN=SELF:GetOption(vMpBaseName..intIndex, 'NULL')
		mMP[intIndex]=SKIN:GetMeter(vMN)
	end--</for>
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	return (Process())
end --</Update()>
-------------------------------------------------------------------------------
function Process()
	ret=0
--Work of the script here
	-----------------------------------------------------------------------------
	-- handle dynamic vars that may have changed between the init and now
	vAID=tonumber(SELF:GetOption('AngleInDegrees', '360'))
	--centering based on screen realestate, reserved for future use, can be used to adjust TxOffsetX,TyOffsetY
	--iCCW=SKIN:GetVariable('CURRENTCONFIGWIDTH',0)
	--iCCH=SKIN:GetVariable('CURRENTCONFIGHEIGHT',0)
	--vTOX=(1*tonumber(SELF:GetOption('TxOffsetX', 0)))
	--+(iCCW/2)
	--vTOY=(1*tonumber(SELF:GetOption('TyOffsetY', 0)))
	--+(iCCH/2)
	--view these values to adjust TxOffsetX,TyOffsetY
--DebugPrint('LuaTemplate: (iCCW/2):'..(iCCW/2),'Debug')
--DebugPrint('LuaTemplate: (iCCH/2):'..(iCCH/2),'Debug')
--DebugPrint('LuaTemplate: vTOX:'..vTOX,'Debug')
--DebugPrint('LuaTemplate: vTOY:'..vTOY,'Debug')
	--Magic numbers based on the center of the skin (originally, but the values change if the skin dimensions change... .
	--if starting from scratch, these can be set to 0
	vTOX=290
	vTOY=218
	--
	for intIndex=1,vLoopSize do
		--fetch singular unit of work to process
		vMN=SELF:GetOption(vMpBaseName..intIndex, 'NULL')
		mMP[intIndex]=SKIN:GetMeter(vMN,vMA)
		-- Process work based on content of target, (tracked)
		iMP[intIndex]=(mMP[intIndex]:GetOption('TransformationMatrix'))
		-- Processing of the content//TASK---------------------------------------
		--vSinAngle=math.sin(math.rad((vAID%360)/360*2*math.pi))
		vSinAngle=math.sin((vAID%360)/360*2*math.pi)
		vNegSinAngle=-1*vSinAngle
		--vCosAngle=math.cos(math.rad((vAID%360)/360*2*math.pi))
		vCosAngle=math.cos((vAID%360)/360*2*math.pi)
		vTX=(vTOX-vCosAngle*vTOX-vSinAngle*vTOX)
		vTY=(vTOY-vNegSinAngle*vTOY-vCosAngle*vTOY)
		-- modify meter TransformationMatrix
		-- TransformationMatrix='vCosAngle..'; '..vNegSinAngle..'; '..vSinAngle..'; '..vCosAngle..'; '..vTX..'; '..vTY'
		SKIN:Bang(bSO,vMN,'TransformationMatrix',vCosAngle..'; '..vNegSinAngle..'; '..vSinAngle..'; '..vCosAngle..'; '..vTX..'; '..vTY)
		-- /TAST-----------------------------------------------------------------
		-- Do updates for any meters, etc. that where modified,(singular result of looped processing)
		SKIN:Bang(bUMT,vMN)
	end --</for>
--DebugPrint('Set '..(vMN)..'.TransformationMatrix to '..vCosAngle..'; '..vNegSinAngle..'; '..vSinAngle..'; '..vCosAngle..'; '..vTX..'; '..vTY,'Warning')
	-----------------------------------------------------------------------------
--Customize for end result meter updates, (singular result non looped processing)
	--SKIN:Bang(bUMT,'MeterName')
--DebugPrint('LuaTemplate: Updates applied...','Debug')
	return(('Set '..(vMN)..'.TransformationMatrix to '..vCosAngle..'; '..vNegSinAngle..'; '..vSinAngle..'; '..vCosAngle..'; '..vTX..'; '..vTY))
end --</Process()>
--LITMUS
-- ANGLE 315
-- SINANGLE -0.70711
-- NEGSINANGLE 0.70711
-- COSANGLE 0.70711
-- TX 515
-- TY -29.20206
--
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
