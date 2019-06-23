;------------------------------------------------------------------------------
[Rainmeter]
Update=500
;------------------------------------------------------------------------------
[Metadata]
Name=Dark-PulseModulatorType0
Author=Darkstrumn
Information=Include for OnLoadStatePulseModulatorType0, toggles from 1 to -1 and back by specified increment
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
;[OnloadOnLoadStatePulseModulatorType0]
;Measure=Calc
;Formula=#OnLoadStateOnLoadStatePulseModulatorType0#
;MinValue=0
;MaxValue=100
;IfEqualValue=0
;;Dynamic values
;IfEqualAction=[!SetVariable OnLoadStateOnLoadStatePulseModulatorType0 1][!SetOption MeasureHookPulseWidth Formula "[*MeasureUsedDrive*]"]
;IfEqualAction=[!SetVariable OnLoadStateOnLoadStatePulseModulatorType0 1][!SetOption MeasureHookPulseWidth Formula "#*MeasureUsedDrive*#"]
;;Static values
;IfEqualAction=[!SetVariable OnLoadStateOnLoadStatePulseModulatorType0 1][!SetOption MeasureHookPulseWidth Formula "[MeasureUsedDrive]"]
;IfEqualAction=[!SetVariable OnLoadStateOnLoadStatePulseModulatorType0 1][!SetOption MeasureHookPulseWidth Formula "#MeasureUsedDrive#"]
;IfEqualAction=[!SetVariable OnLoadStateOnLoadStatePulseModulatorType0 1][!SetOption MeasureHookPulseWidth Formula "5"]
;DynamicVariables=1
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
[Variables]
OnLoadStateOnLoadStatePulseModulatorType0=0
Pulse=[MeasureHookPulseWidth]
;------------------------------------------------------------------------------
;Plugin-Hooks, set these to the items to be measured
;ie:[!SetOption MeasureHookPulseWidth Formula "5"]
;------------------------------------------------------------------------------
[MeasureHookPulseWidth]
Measure=Calc
Formula=1
MinValue=0
MaxValue=100
DynamicVariables=1
;------------------------------------------------------------------------------
[MeasurePulseModulatorTimeBase]
Measure=Time
AverageSize=[MeasureHookPulseWidth]

[MeasureOnLoadStatePulseModulatorType0Type0]
Measure=Calc
Formula=(MeasurePulseModulatorTimeBase % 2)
MinValue=0
MaxValue=1
DynamicVariables=1

[MeasurePulseModulatorType0]
Measure=Calc
Formula= -1 ** (MeasureOnLoadStatePulseModulatorType0Type0)
MinValue=-1
MaxValue=1
DynamicVariables=1
;------------------------------------------------------------------------------





