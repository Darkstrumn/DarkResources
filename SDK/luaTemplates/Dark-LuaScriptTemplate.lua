-------------------------------------------------------------------------------
-- Name=ScriptName
-- Author=Darkstrumn
-- Description=Script provides 
-- Version=0.0.1
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-------------------------------------------------------------------------------
function Initialize()
	MyVar = SKIN:ParseFormula('2+2')
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	Process()
	return MyVar
end --</Update()>
-------------------------------------------------------------------------------
function Process()
local SectionName='Name',pairs={}
for key, value in pairs {
    Option = 'Value',
} do SKIN:Bang('!SetOption', SectionName, key, value) end
end --</Process()>
-------------------------------------------------------------------------------
