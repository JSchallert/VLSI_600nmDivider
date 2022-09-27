* fo4.sp
* David_Harris@hmc.edu 1/23/08
* Delay of FO4 inverter in 0.5 um process

***********************************************************************
* Parameters and models
***********************************************************************
.param SUP=3.3
.param H=4
.option scale=0.3u
.lib '/proj/models/mosisami600/opConditions.lib' TT
.option post

***********************************************************************
* Subcircuits
***********************************************************************
.global vdd gnd

.subckt inv a y N=8 P=16
M1	y	a	gnd	gnd	NMOS	W='N'	L=2 
+ AS='N*5' PS='2*N+10' AD='N*5' PD='2*N+10'
M2	y	a	vdd	vdd	PMOS	W='P'	L=2
+ AS='P*5' PS='2*P+10' AD='P*5' PD='2*P+10'
.ends

***********************************************************************
* Simulation netlist
***********************************************************************
Vdd	vdd	gnd	'SUPPLY'
Vin	a	gnd	PULSE	0 'SUPPLY' 0ps 1000ps 1000ps 5000ps 10000ps
X1	a	b	inv		 * shape input waveform
X2	b	c	inv	M='H'	 * reshape input waveform
X3	c	d	inv	M='H**2' * device under test
X4	d	e	inv	M='H**3' * load
x5	e	f	inv	M='H**4' * load on load

***********************************************************************
* Stimulus
***********************************************************************
.tran 5ps 10000ps SWEEP H 1 8 1
.measure tpdr				* rising propagation delay
+     TRIG v(c)	VAL='SUPPLY/2' FALL=1 
+     TARG v(d)  	VAL='SUPPLY/2' RISE=1
.measure tpdf				* falling propagation delay
+     TRIG v(c)  	VAL='SUPPLY/2' RISE=1
+     TARG v(d)  	VAL='SUPPLY/2' FALL=1 
.measure tpd param='(tpdr+tpdf)/2'	* average propagation delay
.measure trise					* rise time
+	TRIG v(d)	VAL='0.2*SUPPLY' RISE=1
+	TARG v(d)	VAL='0.8*SUPPLY' RISE=1
.measure tfall					* fall time
+	TRIG v(d)	VAL='0.8*SUPPLY' FALL=1
+	TARG v(d)	VAL='0.2*SUPPLY' FALL=1
.end
