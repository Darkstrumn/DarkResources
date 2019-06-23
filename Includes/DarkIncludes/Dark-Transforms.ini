;------------------------------------------------------------------------------
[Rainmeter]
Update=500
;------------------------------------------------------------------------------
[Metadata]
Name=Transforms
Author=Darkstrumn
Information=Provides transforms maths that correct 
Description=Include Template, provides bases for future plug-in-style includes
Instructions=
Version=0.0.1
Config=
Tags=
License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0
Variant=
Preview=
;End of added Metadata
;------------------------------------------------------------------------------
;copy paste block below and remove first comment to activate, update the formula
;values proper for the 2 hook values and should be good to go!
;------------------------------------------------------------------------------
;@Include="#SKINSPATH#\HiveControl\DarkIncludes\Dark-Transforms.inc"
;; hook into plug-in-style include attaching known section measures to colourizing
;; feature
;;------------------------------------------------------------------------------
;[OnloadTransforms]
;Measure=Calc
;Formula=#OnLoadStateTransforms#
;MinValue=0
;MaxValue=100
;IfEqualValue=0
;;Dynamic values
;IfEqualAction=[!SetVariable OnLoadStateTransforms 1][!SetOption MeasureHookNewTX Formula "#*ObjX0*#"][!SetOption MeasureHookNewTY Formula "#*ObjY0*#"]
;DynamicVariables=1
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
[Variables]
OnLoadStateTransforms=0
ResultValue=0
;------------------------------------------------------------------------------
;Plugin-Hooks, set these to the items to be measured
; NewT(X)::specifies the destination object (var,measure,meter...) of the transform element specified
;ie:[!SetOption MeasureHookNewTX Formula "#*ObjX0*#"]
;ie:[!SetOption MeasureHookNewTY Formula "#*ObjY0*#"]
;transformationmatrix=-0.8;-0.8;0.3;0.8;203;33 changes to below, ObjX0 and Y0 are defined in includer
;transformationmatrix=-0.8;-0.8;0.3;0.8;#ObjX0#;#ObjY0#
;------------------------------------------------------------------------------
; ElementTarget::specifies the destination object (var,measure,meter...) of the transform, allows extraction of x,y for transform calculations
[MeasureHookElementTarget]
Measure=Calc
Formula=MeasureHookElementTarget
DynamicVariables=1
;------------------------------------------------------------------------------
; NewTX::specifies the destination object (var,measure,meter...) of the transform element specified
[MeasureHookNewTX]
Measure=Calc
Formula=MeasureHookNewTX
DynamicVariables=1
;------------------------------------------------------------------------------
; NewTY::specifies the destination object (var,measure,meter...) of the transform element specified
[MeasureHookNewTY]
Measure=Calc
Formula=MeasureHookNewTY
DynamicVariables=1
;------------------------------------------------------------------------------
[MeasureTransforms]
Measure=Script
ScriptFile=C:\Users\Darkstrumn\Documents\Rainmeter\Skins\HiveControl\DarkIncludes\luaScripts\Dark-Transforms.lua
;MyOption=Hello, world!
DynamicVariables=1
;------------------------------------------------------------------------------
