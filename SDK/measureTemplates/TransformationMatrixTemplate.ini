;------------------------------------------------------------------------------
;-- Transformation Matrix Angling Template
;Meter graph
;------------------------------------------------------------------------------
[mCUTOffsetX]
Measure=Calc
formula=-1*#vCUGraphSetOffsetX#+(#CURRENTCONFIGWIDTH#/2)
DynamicVariables=1

[mCUTOffsetY]
Measure=Calc
formula=-1*#vCUGraphSetOffsetY#+(#CURRENTCONFIGHEIGHT#/2)
DynamicVariables=1
;------------------------------------------------------------------------------
;-- rotation angle 1-360 of the spefic meter tied to the TMA template is specified here
[mCUAngle]
Measure=Calc
Formula=315

[mCUSinAngle]
Measure=Calc
Formula=(SIN((mCUAngle%360)/360*2*PI))
DynamicVariables=1

[mCUNegSinAngle]
Measure=Calc
Formula=-(mCUSinAngle)
DynamicVariables=1

[mCUCosAngle]
Measure=Calc
Formula=(COS((mCUAngle%360)/360*2*PI))
DynamicVariables=1

[mCUTX]
Measure=Calc
Formula=(mCUTOffsetX-mCUCosAngle*mCUTOffsetX-mCUSinAngle*mCUTOffsetX)
DynamicVariables=1

[mCUTY]
Measure=Calc
Formula=(mCUTOffsetY-mCUNegSinAngle*mCUTOffsetY-mCUCosAngle*mCUTOffsetY)
DynamicVariables=1
;------------------------------------------------------------------------------
;-- /Transformation Matrix Angling Template
;------------------------------------------------------------------------------
