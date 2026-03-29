v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {H. J. Oguey and D. Aebischer, “CMOS current reference without resistance,” 
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132–1135, Jul. 1997} 440 -170 0 0 0.3 0.3 {}
N 600 -360 620 -360 { lab=vbp}
N 620 -420 620 -360 { lab=vbp}
N 620 -420 840 -420 { lab=vbp}
N 840 -420 840 -360 { lab=vbp}
N 820 -360 840 -360 { lab=vbp}
N 600 -320 620 -320 { lab=vbr}
N 620 -320 620 -240 { lab=vbr}
N 620 -240 840 -240 { lab=vbr}
N 840 -320 840 -240 { lab=vbr}
N 820 -320 840 -320 { lab=vbr}
N 600 -340 640 -340 { lab=vbn}
N 640 -340 640 -260 { lab=vbn}
N 640 -260 860 -260 { lab=vbn}
N 860 -340 860 -260 { lab=vbn}
N 820 -340 860 -340 { lab=vbn}
N 760 -300 760 -200 { lab=0}
N 540 -200 760 -200 { lab=0}
N 540 -300 540 -200 { lab=0}
N 540 -500 540 -380 { lab=vdd}
N 540 -500 760 -500 { lab=vdd}
N 760 -500 760 -380 { lab=vdd}
N 440 -200 540 -200 { lab=0}
N 380 -200 380 -180 { lab=0}
N 380 -420 380 -200 { lab=0}
N 380 -500 380 -480 { lab=vdd}
N 380 -500 540 -500 { lab=vdd}
N 440 -320 440 -300 { lab=disable}
N 440 -240 440 -200 { lab=0}
N 440 -320 480 -320 { lab=disable}
N 380 -200 440 -200 { lab=0}
C {devices/title.sym} 160 -40 0 0 {name=l1 author="Christoph Maier"}
C {OgueyAebischerBias.sym} 760 -340 0 0 {name=xbias}
C {ToBiasStartup.sym} 540 -340 0 0 {name=xstart}
C {devices/gnd.sym} 380 -180 0 0 {name=l2 lab=0}
C {devices/vsource.sym} 380 -450 0 1 {name=VDD value="dc 1.2 pwl(0 0 100m 1.2)" }
C {devices/vsource.sym} 440 -270 0 1 {name=Voff value=0}
C {devices/lab_wire.sym} 470 -500 0 0 {name=l3 lab=vdd}
C {devices/lab_wire.sym} 470 -320 0 0 {name=l5 lab=disable}
C {devices/lab_wire.sym} 690 -420 0 0 {name=l6 lab=vbp}
C {devices/lab_wire.sym} 690 -260 0 0 {name=l7 lab=vbn}
C {devices/lab_wire.sym} 690 -240 0 0 {name=l8 lab=vbr}
C {devices/code_shown.sym} 0 -750 0 0 {name=ngspice 
only_toplevel=true 
value=" 
.options gmin=1e-15 abstol=1p
.option savecurrents
.nodeset v(vbp)=200m
.control
save all
op
remzerovec
write test_OgueyAebischerBias.op.raw
tran 20u .2
remzerovec
write test_OgueyAebischerBias.raw
plot vdd vbp vbn vbr xbias.vres
plot v.xbias.vi1#branch v.xbias.vi4#branch v.xbias.viaux#branch
.endc
"}
C {devices/code.sym} 110 -210 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value=".lib cornerMOShv.lib mos_tt

.param mc_mm_switch=0
.param mc_pr_switch=1

"}
