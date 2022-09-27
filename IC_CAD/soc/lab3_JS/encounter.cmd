#######################################################
#                                                     #
#  Encounter Command Logging File                     #
#  Created on Mon Feb 24 01:56:11 2020                #
#                                                     #
#######################################################

#@(#)CDS: Encounter v10.12-s181_1 (32bit) 07/28/2011 22:56 (Linux 2.6)
#@(#)CDS: NanoRoute v10.12-s010 NR110720-1815/10_10_USR2-UB (database version 2.30, 124.2.1) {superthreading v1.15}
#@(#)CDS: CeltIC v10.12-s013_1 (32bit) 07/27/2011 04:13:10 (Linux 2.6.9-89.0.19.ELsmp)
#@(#)CDS: AAE 10.12-s001 (32bit) 07/28/2011 (Linux 2.6.9-89.0.19.ELsmp)
#@(#)CDS: CTE 10.12-s010_1 (32bit) Jul 18 2011 23:05:29 (Linux 2.6.9-89.0.19.ELsmp)
#@(#)CDS: CPE v10.12-s007

win
setUIVar rda_Input ui_gndnet VSS
setUIVar rda_Input ui_leffile muddlib.lef
setUIVar rda_Input ui_netlist controller_syn.v
setUIVar rda_Input ui_topcell controller
setUIVar rda_Input ui_pwrnet VDD
commitConfig
fit
setDrawView fplan
getIoFlowFlag
setIoFlowFlag 0
floorPlan -site core -r 0.888575458392 0.699577 30.0 30.0 30.0 30.0
uiSetTool select
getIoFlowFlag
fit
saveDesign controller_floorplan.enc
addRing -spacing_bottom 1.8 -width_left 9.9 -width_bottom 9.9 -width_top 9.9 -spacing_top 1.8 -layer_bottom metal1 -center 1 -stacked_via_top_layer metal3 -width_right 9.9 -around core -jog_distance 1.5 -offset_bottom 1.5 -layer_top metal1 -threshold 1.5 -offset_left 1.5 -spacing_right 1.8 -spacing_left 1.8 -offset_right 1.5 -offset_top 1.5 -layer_right metal2 -stacked_via_bottom_layer metal1 -layer_left metal2
addRing -spacing_bottom 1.8 -width_left 9.9 -width_bottom 9.9 -width_top 9.9 -spacing_top 1.8 -layer_bottom metal1 -center 1 -stacked_via_top_layer metal3 -width_right 9.9 -around core -jog_distance 1.5 -offset_bottom 1.5 -layer_top metal1 -threshold 1.5 -offset_left 1.5 -spacing_right 1.8 -spacing_left 1.8 -offset_right 1.5 -offset_top 1.5 -layer_right metal2 -stacked_via_bottom_layer metal1 -layer_left metal2
sroute -connect { blockPin padPin padRing corePin } -layerChangeRange { metal1 metal3 } -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer metal1 -allowLayerChange 1 -targetViaTopLayer metal3 -crossoverViaTopLayer metal3 -targetViaBottomLayer metal1
setPlaceMode -fp false
placeDesign -noPrePlaceOpt
setDrawView place
zoomBox 137.100 124.240 140.470 132.900
panCenter 106.860 118.190
panCenter 163.040 101.020
panCenter 169.360 130.510
panCenter 150.790 103.100
saveDesign controller_floorplan_2.enc
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail -wireOpt
getFillerMode -quiet
addFiller -cell fill_1_wide -prefix FILLER
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -viaOverlap false -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000 -warning 50
verifyGeometry
verifyConnectivity -type all -error 1000 -warning 50
saveDesign controller_floorplan_final.enc
saveDesign controller_floorplan_final.enc
