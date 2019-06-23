-------------------------------------------------------------------------------
-- Name=Dark-Transforms
-- Author=Darkstrumn
-- Description=Handles computing an objects new (t)x,(t)y location, keeping object in place after computing application of TransformationMatrix
-- Version=0.0.1
-- License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
-------------------------------------------------------------------------------
function Initialize()
	ResultValue = SKIN:ParseFormula('(2+2)')
	NewTX = 0
	NewTY = 0
	MeasureObj = nil
	MeterObj = nil
	TransformObjectX = nil
	TransformObjectY = nil
end --</Initialize()>
-------------------------------------------------------------------------------
function Update()
	return Process()
end --</Update()>
-------------------------------------------------------------------------------
function Process()
	local a, b, c, d, tx, ty, tbl, x, y, TMData, TargetId
	-- Fetch the include linkages for this include function
	-- Target object the transform will be applied to
	MeasureObj = SKIN:GetMeasure('MeasureHookElementTarget')
	TargetId = MeasureObj:GetOption('Formula', '')
	TargetId = TargetId:gsub("%[", ""):gsub("%]", "")
	--MeterObj = SKIN:GetMeter(TargetId)
	MeterObj = SKIN:GetMeter('MeterTimeDiagonal')
	-- Measures used to express the translation of the TransformationMatrix result
	TransformObjectX = SKIN:GetMeasure('MeasureHookNewTX')
	TransformObjectY = SKIN:GetMeasure('MeasureHookNewTY')
	-- Fetch TransformationMatrix data to extract the current values
	TMData = MeterObj:GetOption('TransformationMatrix', '0;0;0;0;0;0')
	tbl = Delim(TMData, ';')
	a = tbl[1]
	b = tbl[2]
	c = tbl[3]
	d = tbl[4]
	tx = tbl[5]
	ty = tbl[6]
	-- Fetch the current x, y of the Target object
	x = MeterObj:GetX()
	y = MeterObj:GetY()
	-- Execute calulation
	ResultValue = GetTransform(a, b, c, d, tx, ty, x, y)
	-- Write data back to destination objects
	SKIN:Bang('!SetVariable ResultValue '..ResultValue)
	SKIN:Bang('!SetOption', MeterMeasureObj, 'TransformationMatrix', ResultValue)
	-- Return the data so that the call can be used directly in logic
	return ResultValue
end --</Process()>
-------------------------------------------------------------------------------
function GetTransform(a, b, c, d, tx, ty, x, y)
	-- a = cos(angle)
	-- b = -sin(angle)
	-- c = sin(angle)
	-- d = -cos(angle) 
	----------------------------
	local newx = x*a + y*b + 1*tx
	local newy = x*b + y*d + 1*ty
	-- newx = 75*1.5 + 75*0 + 1*tx
	-- newy = 75*0 + 75*1.5 + 1*ty
	----------------------------
	NewTX = newx - x*a - y*b
	NewTY = newy - x*b - y*d
	-- newtx = 75 - 75*1.5 = -37.5
	-- newty = 75 - 75*1.5 = -37.5
	----------------------------
	return a..';'..b..';'..c..';'..d..';'..NewTX..';'..NewTY
end--</GetNewXTransform()>
-------------------------------------------------------------------------------
function Delim(line, delimiter) -- Separate String by single character delimiter
	assert(delimiter:len() == 1, 'Delim: Delimiter may only be a single character')

	local tbl = {}

	for word in string.gmatch(line,'[^%' .. delimiter .. ']+') do
		table.insert(tbl, word)
	end

	return tbl
end
-------------------------------------------------------------------------------






