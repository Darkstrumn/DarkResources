;------------------------------------------------------------------------------
; Drive colouring based on fullness, can be used as an include, then simply
; use the #BarGraphColour# variable for colouring, DynamicVariables=1 will
; likely need to be used in the block using the said variable.
;------------------------------------------------------------------------------
;copy paste block below and remove first comment to activate, update the formula
;values proper for the 2 hook values and should be good to go!
;------------------------------------------------------------------------------
;@Include="#SKINSPATH#\HiveControl\DarkIncludes\Dark-FullnessColouring.inc"
;; hook into plug-in-style include attaching known section measures to colourizing
;; feature
;;------------------------------------------------------------------------------
;[OnloadFullnessColouring]
;Measure=Calc
;Formula=#OnLoadStateFullnessColouring#
;MinValue=0
;MaxValue=100
;IfEqualValue=0
;IfEqualAction=[!SetVariable OnLoadStateFullnessColouring 1][!SetOption MeasureHookUsed Formula "[*MeasureUsedDrive*]"][!SetOption MeasureHookTotal Formula "[*MeasureTotalDrive*]"]
;DynamicVariables=1
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
[Variables]
PercentOK=50
PercentHi=49
PercentMed=74
percentLow=89
LineColorOK=34, 95, 142, 160
LineColorHiPercent=0, 255, 0, 160
LineColorMedPercent=255, 255, 95, 160
LineColorLowPercent=255, 0, 0, 160
BarGraphColour=#LineColorOK#
OnLoadStateFullnessColouring=0
BarState=0
;------------------------------------------------------------------------------
;Plugin-Hooks, set these to the items to be measured
;ie:[!SetOption MeasureHookUsed Formula "[*MeasureUsedDrive*]"]
;ie:[!SetOption MeasureHookTotal Formula "[*MeasureTotalDrive*]"]
;------------------------------------------------------------------------------
[MeasureHookUsed]
Measure=Calc
Formula=MeasureHookUsed
MinValue=0
MaxValue=100
DynamicVariables=1

[MeasureHookTotal]
Measure=Calc
Formula=MeasureHookTotal
MinValue=0
MaxValue=100
DynamicVariables=1
;------------------------------------------------------------------------------
[MeasurePercentUsed]
Measure=Calc
Formula=(MeasureHookUsed/(MeasureHookTotal/100))
MinValue=0
MaxValue=100
DynamicVariables=1
;------------------------------------------------------------------------------
;Classifier: takes volume fullness and becomes a state based on set
;percentages defined in variables above
;------------------------------------------------------------------------------
[LineColorHiPercent]
Measure=Calc
Formula=[MeasurePercentUsed]
MinValue=0
MaxValue=100
IfAboveValue=#PercentHi#
IfAboveAction=[!SetVariable BarState 2]
DynamicVariables=1

[LineColorMedPercent]
Measure=Calc
Formula=[MeasurePercentUsed]
MinValue=0
MaxValue=100
IfAboveValue=#PercentMed#
IfAboveAction=[!SetVariable BarState 3]
IfBelowValue=#PercentMed#+1
IfBelowAction=[!SetVariable BarState 2]
DynamicVariables=1

[LineColorLowPercent]
Measure=Calc
Formula=[MeasurePercentUsed]
MinValue=0
MaxValue=100
IfAboveValue=#percentLow#
IfAboveAction=[!SetVariable BarState 4]
IfBelowValue=#percentLow#+1
IfBelowAction=[!SetVariable BarState 3]
DynamicVariables=1

[LineColorOK]
Measure=Calc
Formula=[MeasurePercentUsed]
MinValue=0
MaxValue=100
IfBelowValue=#PercentOK#
IfBelowAction=[!SetVariable BarState 1]
DynamicVariables=1
;------------------------------------------------------------------------------
;triggers that take the crisp state and become colour
;------------------------------------------------------------------------------
[LineColorLowTrigger]
Measure=Calc
Formula=#BarState#
MinValue=0
MaxValue=100
IfEqualValue=4
IfEqualAction=[!SetVariable BarGraphColour "#LineColorLowPercent#"]
DynamicVariables=1

[LineColorMedTrigger]
Measure=Calc
Formula=#BarState#
MinValue=0
MaxValue=100
IfEqualValue=3
IfEqualAction=[!SetVariable BarGraphColour "#LineColorMedPercent#"]
DynamicVariables=1

[LineColorHiTrigger]
Measure=Calc
Formula=#BarState#
MinValue=0
MaxValue=100
IfEqualValue=2
IfEqualAction=[!SetVariable BarGraphColour "#LineColorHiPercent#"]
DynamicVariables=1

[LineColorOKTrigger]
Measure=Calc
Formula=#BarState#
MinValue=0
MaxValue=100
IfEqualValue=1
IfEqualAction=[!SetVariable BarGraphColour "#LineColorOK#"]
DynamicVariables=1
;------------------------------------------------------------------------------





