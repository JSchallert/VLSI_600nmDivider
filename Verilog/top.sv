// Richie Harris, Jonathan Schallert
// rkharris@hmc.edu, jschallert@hmc.edu

// 16 bit Radix-2 unsigned divider
// computes N/D = Q in 16 cycles
// inputs N and D are shifted in when load is asserted
// output Q is shifted out when done is asserted



// divider testbench
// 13205/486 = 27
// 0011001110010101/0000000111100110 = 0000000000011011

// set the delay unit to 1 ns and the simulation precision to 0.1 ns
//`timescale 1ns / 100ps

module testbench();

	// divider signals
	logic ph1, ph2;
	logic load;
	logic n, d;
	logic done;
	logic q;
	// registers to hold the dividend, divisor, and quotient
	logic [15:0] N;
	logic [15:0] D;
	logic [15:0] Q;
	// signals to shift in input and check result
	logic [5:0] count;
	logic checkresult;
	
	// instantiate dut
	top dut(ph1, ph2, load, n, d, done, q);

	// initialize test
	initial
		begin
			count = 0;
			checkresult = 0;
			N = 16'd13205;
			D = 16'd486;
			load = 0; 
			#1;
			load = 1;
		end
		
		
	// generate 2 phase non-overlapping clock
	always
		begin
			ph1 = 0; ph2 = 0; #1;
			ph1 = 1; 			#4;
			ph1 = 0;				#1;
			ph2 = 1;				#4;
		end

	// n and d are the msb of N and D
	assign n = N[15];
	assign d = D[15];
		
	always @(posedge ph1)
		// delay for one cycle
		if (count == 0)	count <= count + 1;
		// shift in n and d
		else if (count < 16) begin
			N <= {N[14:0], 1'b0};
			D <= {D[14:0], 1'b0};
			count <= count + 1;
		end
		// when done shifting in inputs, de-assert load
		else if (count == 16)	begin
			load <= 0;
			count <= count + 1;
		end
		// when divider asserts done, capture the output
		else if (done) begin
			Q <= {Q[14:0], q};
			checkresult <= 1;
		end
		// check the result
		else if (checkresult) begin
			if (Q == 16'd27) begin
				$display("Simulation succeeded!!");
				$finish;
			end
			else begin
				$display("Simulation failed");
				$stop;
			end
		end
endmodule


module top(input  logic ph1, ph2,
					input  logic load,
					input  logic n, d,
					output logic done,
					output logic q);
	
	// control signals
	logic shiftorset, q_en;
	// shiftorset: determines whether A should be set with the result from the adder or
	//					whether it should shift left
	//	q_en: enable signal for q shift register flops
	
	controller c(ph1, ph2, load, shiftorset, q_en, done);
	datapath dp(ph1, ph2, n, d, load, shiftorset, q_en, q);

endmodule

////////////////////////////////////////////////////
// controller
////////////////////////////////////////////////////

module controller(input  logic ph1, ph2,
						input  logic load,
						output logic shiftorset,
						output logic q_en, 
						output logic done);
	
		// current state of the counter
		logic flop1q, flop2q, flop3q, flop4q, flop5q, flop6q;
		
		// inverse of flop5q and flop6q
		logic flop5qi, flop6qi;
		
		// sum and carry from half adders
		logic add1s, add1c, add2s, add2c, add3s, 
				add3c, add4s, add4c, add5s, add5c, add6s, add6c;
				
		// results from intermediate nor gates		
		logic nor1, nor2, nor3;		
		
		// intermediate signal from nand gate		
		logic nandcount16donei;
		
		// result from the counter
		// count16i=1 if count is not 16
		// count32i=1 if count is not 32
		logic count16i, count32i;
		
		//the next done signal going into the flop
		// donenexti=~donenext
		logic donenexti, donenext;
		
		// donei=~done
		logic donei;
		
		// determines whether we should be adding to the counter.
		// we want to increment when shiftorset=1 or when done=1
		// counti = ~count
		logic counti, count;
		
		// loadi=~load
		logic loadi;
		
		// gates to determine count
		nor_2 cn(shiftorset, done, counti);
		inv ci(counti, count);
		
		// generate the enable signal for shifter_q as shiftorset=0 (we are shifting)
		// or load (we are shifting in the input N into Q to initialize)
		inv noai(load, loadi);
		nand_2 nenable(shiftorset, loadi, q_en);
		
		// half adders for counter
		halfadder h1(count, flop1q, add1s, add1c);
		halfadder h2(add1c, flop2q, add2s, add2c);
		halfadder h3(add2c, flop3q, add3s, add3c);
		halfadder h4(add3c, flop4q, add4s, add4c);	
		halfadder h5(add4c, flop5q, add5s, add5c);
		halfadder h6(add5c, flop6q, add6s, add6c);	
		
		// flops to hold current count state
		flop_r flop1(ph1, ph2, load, add1s, flop1q);	
		flop_r flop2(ph1, ph2, load, add2s, flop2q);	
		flop_r flop3(ph1, ph2, load, add3s, flop3q);	
		flop_r flop4(ph1, ph2, load, add4s, flop4q);		
		flop_r flop5(ph1, ph2, load, add5s, flop5q);
		flop_r flop6(ph1, ph2, load, add6s, flop6q);
		
		// oscillating signal to generate shiftorset control signal
		// shiftorset=0 means shift, shiftorset=1 means set
		ctrl_sig cs(ph1, ph2, load, done, shiftorset);
		
		// when count gets to 16, assert done to signal it is time to shift out the result
		// when count gets to 32, deassert done to signal that the result has been shifted out
		// gates to produce count16i
		inv if5(flop5q, flop5qi);
		nor_3 no1(flop6q, flop5qi, flop4q, nor1);
		nor_3 no2(flop3q, flop2q, flop1q, nor2);
		nand_2 na1(nor1, nor2, count16i);
		// gates to produce count32i
		inv if6(flop6q, flop6qi);
		nor_3 no3(flop6qi, flop5q, flop4q, nor3);
		nand_2 na2(nor3, nor2, count32i);
		// gates to produce donenext
		inv idone(done, donei);
		nand_2 na3(count16i, donei, nandcount16donei);
		nand_2 na4(nandcount16donei, count32i, donenexti);
		inv idonenext(donenexti, donenext);
		// flop to hold done
		flop_r fdone(ph1, ph2, load, donenext, done);

endmodule


module ctrl_sig(input logic ph1, ph2,
				  input logic load,
				  input logic done,
				  output logic q);
		
		// generates the shift or parallel load signal for A
		// it just alternates between 0 and 1
		// we stop shifting and parallel loading when done is asserted
		logic nextq;
		
		nor_2 n(done, q, nextq);
		flop_r f(ph1, ph2, load, nextq, q);
		
endmodule

/////////////////////////////////////////////////
// datapath
/////////////////////////////////////////////////

module datapath(input  logic ph1, ph2,
					 input  logic n, d,
					 input  logic load,
					 input  logic shiftorset,
					 input  logic q_en,
					 output logic q);

	// D, ~D, and selectedD from mux based on whether we are
	// adding or subtracing D.  selectedD goes to adder
	logic [15:0] D, notD, selectedD;
	// sum is result from adder, A is partial remainder, the other
	// input to the adder
	logic [15:0] sum, A;
	// newq is the new quotient bit, sel is whether we are choosing
	// positive or negative D as input to the adder
	logic newq, sel;
	// if we choose negative D, we need to carry 1 in to get 2s complement
	logic cin;
					 
	shift_reg_16 sd(ph1, ph2, load, d, D);
	shifter_q sq(ph1, ph2, n, load, shiftorset, q_en, newq, q);
	shifter_a sa(ph1, ph2, load, shiftorset, q, sum, A, sel, cin);
	inv_16 i16(D, notD);
	mux_16 m16(sel, D, notD, selectedD);
	carryselectadder csa(selectedD, A, cin, sum);
	
	// the new quotient bit is the inverse of the msb from the previous sum
	inv i(A[15], newq);
					 
endmodule 


////////////////////////////////////////////////////////
// Datapath blocks
////////////////////////////////////////////////////////


module shifter_q(input  logic ph1, ph2,
					  input  logic n,
					  input  logic load,
					  input  logic shiftorset,
					  input  logic q_en,
					  input  logic newq,
					  output logic q);

	// hold all the intermediate values for the flops
	logic [15:0] Q;
					  
	// choose between input n or result from msb of adder
	// Q is initialized as N, so choose input n when load is high
	mux_2 m(load, n, newq, selectedq);
	// shift register with enables so we only shift left
	// when we are loading in N, or when A is also being shifted left
	shift_reg_16 s16(ph1, ph2, q_en, selectedq, Q);
	assign q = Q[15];

endmodule


module shifter_a(input  logic 		 ph1, ph2,
					  input  logic 		 reset,
					  input  logic 		 shiftorset,
					  input  logic 		 q,
					  input  logic [15:0] sum,
					  output logic [15:0] A,
					  output logic 		 sel,
					  output logic 		 cin);

	// intermediate signals in the shift register
	logic sa0, sa1, sa2, sa3, sa4, sa5, sa6, sa7,
			sa8, sa9, sa10, sa11, sa12, sa13, sa14, sa15;
					  
	// muxes and flops to perform shift or parallel load
	mux_2 m0(shiftorset, sum[0], q, sa0);
	flop_r f0(ph1, ph2, reset, sa0, A[0]);
	mux_2 m1(shiftorset, sum[1], A[0], sa1);
	flop_r f1(ph1, ph2, reset, sa1, A[1]);
	mux_2 m2(shiftorset, sum[2], A[1], sa2);
	flop_r f2(ph1, ph2, reset, sa2, A[2]);
	mux_2 m3(shiftorset, sum[3], A[2], sa3);
	flop_r f3(ph1, ph2, reset, sa3, A[3]);
	mux_2 m4(shiftorset, sum[4], A[3], sa4);
	flop_r f4(ph1, ph2, reset, sa4, A[4]);
	mux_2 m5(shiftorset, sum[5], A[4], sa5);
	flop_r f5(ph1, ph2, reset, sa5, A[5]);
	mux_2 m6(shiftorset, sum[6], A[5], sa6);
	flop_r f6(ph1, ph2, reset, sa6, A[6]);
	mux_2 m7(shiftorset, sum[7], A[6], sa7);
	flop_r f7(ph1, ph2, reset, sa7, A[7]);
	mux_2 m8(shiftorset, sum[8], A[7], sa8);
	flop_r f8(ph1, ph2, reset, sa8, A[8]);
	mux_2 m9(shiftorset, sum[9], A[8], sa9);
	flop_r f9(ph1, ph2, reset, sa9, A[9]);
	mux_2 m10(shiftorset, sum[10], A[9], sa10);
	flop_r f10(ph1, ph2, reset, sa10, A[10]);
	mux_2 m11(shiftorset, sum[11], A[10], sa11);
	flop_r f11(ph1, ph2, reset, sa11, A[11]);
	mux_2 m12(shiftorset, sum[12], A[11], sa12);
	flop_r f12(ph1, ph2, reset, sa12, A[12]);
	mux_2 m13(shiftorset, sum[13], A[12], sa13);
	flop_r f13(ph1, ph2, reset, sa13, A[13]);
	mux_2 m14(shiftorset, sum[14], A[13], sa14);
	flop_r f14(ph1, ph2, reset, sa14, A[14]);
	mux_2 m15(shiftorset, sum[15], A[14], sa15);
	flop_r f15(ph1, ph2, reset, sa15, A[15]);

	// delay the select signal for the D/notD mux for one cycle
	// so that we can left shift A
	// if the msb of A was 1, we select D, if it is
	// 0, we select notD
	flop fsel(ph1, ph2, A[15], sel);
	// if we select notD, we need to add 1 so we get the 
	// 2's complement of D: -D = ~D+1
	inv i(sel, cin);

endmodule


module carryselectadder(input  logic [15:0] A, B,
								input  logic 		  cin,
								output logic [15:0] sum);
								
	logic zero, one;
	
	// true carry outs
	logic cout3, cout7, cout11;
	
	// intermediate carry outs: cout70 = cout7 with cin
	// assumed to be 0.  cout71 = cout7 with cin assumed to be 1
	logic cout70, cout71, cout110, cout111, cout150, cout151;
	
	// intermediate sums: s0 is with cin assumed
	// to be 0, s1 is with cin assumed to be 1
	logic [11:0] s0, s1;
								
	// first group uses the true carry in	
	fa_group4 g0(A[3:0], B[3:0], cin, sum[3:0], cout3);
	
	// the carry ins
	assign one = 1;
	assign zero = 0;

	// six more groups of full adders: one assumes cin=0,
	// the other assumes cin=1
	fa_group4 g10(A[7:4], B[7:4], zero, s0[3:0], cout70);
	fa_group4 g11(A[7:4], B[7:4], one, s1[3:0], cout71);
	
	fa_group4 g20(A[11:8], B[11:8], zero, s0[7:4], cout110);
	fa_group4 g21(A[11:8], B[11:8], one, s1[7:4], cout111);
	
	fa_group4 g30(A[15:12], B[15:12], zero, s0[11:8], cout150);
	fa_group4 g31(A[15:12], B[15:12], one, s1[11:8], cout151);
	
	// select the true result based on the actual carry in
	mux_group4 mg0(cout3, s1[3:0], s0[3:0], sum[7:4]);
	
	mux_group4 mg1(cout7, s1[7:4], s0[7:4], sum[11:8]);
	
	mux_group4 mg2(cout11, s1[11:8], s0[11:8], sum[15:12]);
	
	// choose the carry in to the next level
	mux_2 mcout7(cout3, cout71, cout70, cout7);
	mux_2 mcout11(cout7, cout111, cout110, cout11);
	
endmodule


module fa_group4(input  logic [3:0] A, B,
					  input  logic 		cin,
					  output logic [3:0] sum,
					  output logic 		cout);
	
	logic cout0, cout1, cout2;
	
	fulladder f0(A[0], B[0], cin, sum[0], cout0);
	fulladder f1(A[1], B[1], cout0, sum[1], cout1);
	fulladder f2(A[2], B[2], cout1, sum[2], cout2);
	fulladder f3(A[3], B[3], cout2, sum[3], cout);

endmodule


module mux_group4(input  logic 		 sel,
						input  logic [3:0] D1, D0,
						output logic [3:0] Y);

	mux_2 m0(sel, D1[0], D0[0], Y[0]);
	mux_2 m1(sel, D1[1], D0[1], Y[1]);
	mux_2 m2(sel, D1[2], D0[2], Y[2]);
	mux_2 m3(sel, D1[3], D0[3], Y[3]);

endmodule


module shift_reg_16(input  logic 		 ph1, ph2,
						  input  logic 		 en,
						  input  logic 		 in,
						  output logic [15:0] out);
						  
	flop_en f0(ph1, ph2, en, in, out[0]);
	flop_en f1(ph1, ph2, en, out[0], out[1]);
	flop_en f2(ph1, ph2, en, out[1], out[2]);
	flop_en f3(ph1, ph2, en, out[2], out[3]);
	flop_en f4(ph1, ph2, en, out[3], out[4]);
	flop_en f5(ph1, ph2, en, out[4], out[5]);
	flop_en f6(ph1, ph2, en, out[5], out[6]);
	flop_en f7(ph1, ph2, en, out[6], out[7]);
	flop_en f8(ph1, ph2, en, out[7], out[8]);
	flop_en f9(ph1, ph2, en, out[8], out[9]);
	flop_en f10(ph1, ph2, en, out[9], out[10]);
	flop_en f11(ph1, ph2, en, out[10], out[11]);
	flop_en f12(ph1, ph2, en, out[11], out[12]);
	flop_en f13(ph1, ph2, en, out[12], out[13]);
	flop_en f14(ph1, ph2, en, out[13], out[14]);
	flop_en f15(ph1, ph2, en, out[14], out[15]);

endmodule


module mux_16(input  logic 		 select,
				  input  logic [15:0] D0, D1,
				  output logic [15:0] Y);
	
	// datapath select mux: chooses between D and ~D
	mux_2 m0(select, D0[0], D1[0], Y[0]);
	mux_2 m1(select, D0[1], D1[1], Y[1]);
	mux_2 m2(select, D0[2], D1[2], Y[2]);
	mux_2 m3(select, D0[3], D1[3], Y[3]);
	mux_2 m4(select, D0[4], D1[4], Y[4]);
	mux_2 m5(select, D0[5], D1[5], Y[5]);
	mux_2 m6(select, D0[6], D1[6], Y[6]);
	mux_2 m7(select, D0[7], D1[7], Y[7]);
	mux_2 m8(select, D0[8], D1[8], Y[8]);
	mux_2 m9(select, D0[9], D1[9], Y[9]);
	mux_2 m10(select, D0[10], D1[10], Y[10]);
	mux_2 m11(select, D0[11], D1[11], Y[11]);
	mux_2 m12(select, D0[12], D1[12], Y[12]);
	mux_2 m13(select, D0[13], D1[13], Y[13]);
	mux_2 m14(select, D0[14], D1[14], Y[14]);
	mux_2 m15(select, D0[15], D1[15], Y[15]);

endmodule


module inv_16(input  logic [15:0] A,
				  output logic [15:0] Y);
				  
	// datapath inverter to produce ~D
	assign Y = ~A;
				  
endmodule


/////////////////////////////////////////
// Lower Level Blocks
/////////////////////////////////////////

module halfadder(input  logic a, b,
					  output logic s, cout);
					  
	assign s = a^b;
	assign cout = a&b;
					  
endmodule


module inv(input logic  a,
			  output logic y);
			  
	assign y = ~a;

endmodule


module nor_2(input logic a,
			   input logic b,
			   output logic y);
			  
	assign y = ~(a|b);

endmodule


module nor_3(input logic a,
			   input logic b,
				input logic c,
			   output logic y);
			  
	assign y = ~(a|b|c);

endmodule


module nand_2(input logic a,
			   input logic b,
			   output logic y);
			  
	assign y = ~(a&b);

endmodule


module fulladder(input  logic a, b, cin,
					  output logic s, cout);
					  
	assign s = a^b^cin;
	assign cout = ((a^b)&cin)|(a&b);
					  
endmodule


module flop_en(input  logic ph1, ph2,
					input  logic en,
					input  logic d,
					output logic q);

	logic d2;
					
	mux_2 enmux(en, d, q, d2);
	flop f(ph1, ph2, d2, q);

endmodule


module flop_r(input  logic ph1, ph2,
				  input  logic reset,
				  input  logic d,
				  output logic q);

	logic d2, zero;
	
	assign zero = 0;
					
	mux_2 rmux(reset, zero, d, d2);
	flop f(ph1, ph2, d2, q);

endmodule


module flop(input  logic ph1, ph2,
				input  logic d,
				output logic q);

	logic mid;
	
	latch_ master(ph2, d, mid);
	latch_ slave(ph1, mid, q);

endmodule


module latch_(input  logic ph,
				 input  logic d,
				 output logic q);

	always_latch
		if (ph) q <= d;

endmodule


module mux_2(input  logic select,
				 input  logic d1, d0,
				 output logic y);

	assign y = select ? d1 : d0;

endmodule

