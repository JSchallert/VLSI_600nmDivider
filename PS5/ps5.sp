* ps5.sp
* jschallert@hmc.edu 3/9/20
* Delay of VLSI PS4 P3 Gate Selection Using 0.5 um process

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

.subckt inv a y N=4 P=8
M1	y	a	gnd	gnd	NMOS	W='N'	L=2 
+ AS='N*5' PS='2*N+10' AD='N*5' PD='2*N+10'
M2	y	a	vdd	vdd	PMOS	W='P'	L=2
+ AS='P*5' PS='2*P+10' AD='P*5' PD='2*P+10'
.ends

.subckt invTwo a y N=4 P=8
M1	y	a	gnd	gnd	NMOS	W='N'	L=2
+ AS='N*25' PS='8*N+40' AD='N*25' PD='8*N+40'
M2	y	a	vdd	vdd	PMOS	W='P'	L=2
+ AS='P*25' PS='8*P+40' AD='P*25' PD='8*P+40'
.ends

***********************************************************************
* Simulation netlist
***********************************************************************
Vdd	vdd	gnd	'SUPPLY'
Vin	a	gnd	PULSE	0 'SUPPLY' 0ps 1000ps 1000ps 5000ps 10000ps
X1	a	b	inv		 * input 1
X2	b	c	inv	  	 * input 2
X3	c	d	inv	M='H**3' * load
***********************************************************************
* Stimulus
***********************************************************************
.tran 5ps 10000ps
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
