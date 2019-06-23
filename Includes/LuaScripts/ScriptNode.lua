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
-- [testScriptNode]
-- Measure=Script
-- ScriptFile=Script.lua
-- IfCondition=testParseParent <= 0
-- IfTrueAction = [!CommandMeasure "testParseParent" "DebugPrint('Hello World !','Debug')"]
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
end

function setVar(varName,varValue)
  SKIN:Bang(bSV,varName,varValue)
end

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
  end--</if>
  SKIN:Bang(bL,strMessage,strEL)
end--</DebugPrint()>
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- End of line.
-------------------------------------------------------------------------------
