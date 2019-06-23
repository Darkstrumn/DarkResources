;------------------------------------------------------------------------------
[Rainmeter]
Update=20
;^--controls timing resolution. 500 should be about .5 seconds, not too tight
;------------------------------------------------------------------------------
[Metadata]
Name=Dark-PulseModulatorType1
Author=Darkstrumn
Information=Include for PulseModulatorType1, pulses from 0 to 100 and back by specified increment
Version=0.0.1
License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
;------------------------------------------------------------------------------
;copy paste block below and remove first comment to activate, update the formula
;values proper for the 2 hook values and should be good to go!
;------------------------------------------------------------------------------
;@Include="#SKINSPATH#\HiveControl\DarkIncludes\Dark-PulseModulatorType1.inc"
;; hook into plug-in-style include attaching known section measures to colourizing
;; feature
;;------------------------------------------------------------------------------
;[OnloadPulseModulatorType1]
;Measure=Calc
;Formula=#OnLoadStatePulseModulatorType1#
;MinValue=0
;MaxValue=100
;IfEqualValue=0
;;Dynamic values
;IfEqualAction=[!SetVariable OnLoadStatePulseModulatorType1 1][!SetOption MeasureHookType1PulseWidth Formula "[*MeasureUsedDrive*]"]
;IfEqualAction=[!SetVariable OnLoadStatePulseModulatorType1 1][!SetOption MeasureHookType1PulseWidth Formula "#*MeasureUsedDrive*#"]
;;Static values
;IfEqualAction=[!SetVariable OnLoadStatePulseModulatorType1 1][!SetOption MeasureHookType1PulseWidth Formula "[MeasureUsedDrive]"]
;IfEqualAction=[!SetVariable OnLoadStatePulseModulatorType1 1][!SetOption MeasureHookType1PulseWidth Formula "#MeasureUsedDrive#"]
;IfEqualAction=[!SetVariable OnLoadStatePulseModulatorType1 1][!SetOption MeasureHookType1PulseWidth Formula "5"]
;DynamicVariables=1
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
[Variables]
OnLoadStatePulseModulatorType1=0
Pulse=[MeasureHookType1PulseWidth]
;------------------------------------------------------------------------------
;Plugin-Hooks, set these to the items to be measured
;ie:[!SetOption MeasureHookType1PulseWidth Formula "5"]
;------------------------------------------------------------------------------
[MeasureHookType1PulseWidth]
Measure=Calc
Formula=0
MinValue=0
MaxValue=100
DynamicVariables=1
;------------------------------------------------------------------------------
[MeasurePulseModulatorType1]
Measure=Calc
Formula=(MeasurePulseModulatorType1+#Pulse#)
IfAboveValue=(100-[MeasureHookType1PulseWidth])
IfAboveAction=!SetVariable Pulse "-[MeasureHookType1PulseWidth]"
IfBelowValue=[MeasureHookType1PulseWidth]
IfBelowAction=!SetVariable Pulse "[MeasureHookType1PulseWidth]"
MinValue=-100
MaxValue=100
DynamicVariables=1
;------------------------------------------------------------------------------





