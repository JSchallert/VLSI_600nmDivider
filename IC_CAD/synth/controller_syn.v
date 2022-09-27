/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : L-2016.03-SP4
// Date      : Mon Feb 24 01:40:27 2020
/////////////////////////////////////////////////////////////


module controller ( ph1, ph2, reset, Instr, Funct, Rd, ALUFlags, FlagW, 
        PCWrite, MemWrite, RegWrite, IRWrite, AdrSrc, RegSrc, ALUOp, ALUSrcA, 
        ALUSrcB, ResultSrc, ImmSrc );
  input [31:25] Instr;
  input [0:0] Funct;
  input [2:0] Rd;
  input [1:0] ALUFlags;
  input [1:0] FlagW;
  output [3:0] IRWrite;
  output [1:0] RegSrc;
  output [1:0] ALUSrcB;
  output [1:0] ResultSrc;
  input ph1, ph2, reset;
  output PCWrite, MemWrite, RegWrite, AdrSrc, ALUOp, ALUSrcA, ImmSrc;
  wire   cl_CondExDelayed, cl_flagreg1_d2_0_, cl_condreg_d2_0_,
         cl_flagreg0_d2_0_, cl_flagreg1_f_mid_0_, cl_condreg_f_mid_0_,
         cl_flagreg0_f_mid_0_, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120;
  wire   [1:0] cl_Flags;
  wire   [3:0] dec_fsm_state;
  wire   [3:0] dec_fsm_statereg_d2;
  wire   [3:0] dec_fsm_statereg_f_mid;

  latch_c_1x cl_flagreg1_f_slave_q_reg_0_ ( .ph(ph1), .d(cl_flagreg1_f_mid_0_), 
        .q(cl_Flags[1]) );
  latch_c_1x cl_condreg_f_master_q_reg_0_ ( .ph(ph2), .d(cl_condreg_d2_0_), 
        .q(cl_condreg_f_mid_0_) );
  latch_c_1x cl_condreg_f_slave_q_reg_0_ ( .ph(ph1), .d(cl_condreg_f_mid_0_), 
        .q(cl_CondExDelayed) );
  latch_c_1x cl_flagreg0_f_master_q_reg_0_ ( .ph(ph2), .d(cl_flagreg0_d2_0_), 
        .q(cl_flagreg0_f_mid_0_) );
  latch_c_1x cl_flagreg0_f_slave_q_reg_0_ ( .ph(ph1), .d(cl_flagreg0_f_mid_0_), 
        .q(cl_Flags[0]) );
  latch_c_1x cl_flagreg1_f_master_q_reg_0_ ( .ph(ph2), .d(cl_flagreg1_d2_0_), 
        .q(cl_flagreg1_f_mid_0_) );
  latch_c_1x dec_fsm_statereg_f_slave_q_reg_3_ ( .ph(ph1), .d(
        dec_fsm_statereg_f_mid[3]), .q(dec_fsm_state[3]) );
  latch_c_1x dec_fsm_statereg_f_master_q_reg_2_ ( .ph(ph2), .d(
        dec_fsm_statereg_d2[2]), .q(dec_fsm_statereg_f_mid[2]) );
  latch_c_1x dec_fsm_statereg_f_slave_q_reg_2_ ( .ph(ph1), .d(
        dec_fsm_statereg_f_mid[2]), .q(dec_fsm_state[2]) );
  latch_c_1x dec_fsm_statereg_f_master_q_reg_1_ ( .ph(ph2), .d(
        dec_fsm_statereg_d2[1]), .q(dec_fsm_statereg_f_mid[1]) );
  latch_c_1x dec_fsm_statereg_f_slave_q_reg_1_ ( .ph(ph1), .d(
        dec_fsm_statereg_f_mid[1]), .q(dec_fsm_state[1]) );
  latch_c_1x dec_fsm_statereg_f_master_q_reg_0_ ( .ph(ph2), .d(
        dec_fsm_statereg_d2[0]), .q(dec_fsm_statereg_f_mid[0]) );
  latch_c_1x dec_fsm_statereg_f_slave_q_reg_0_ ( .ph(ph1), .d(
        dec_fsm_statereg_f_mid[0]), .q(dec_fsm_state[0]) );
  latch_c_1x dec_fsm_statereg_f_master_q_reg_3_ ( .ph(ph2), .d(
        dec_fsm_statereg_d2[3]), .q(dec_fsm_statereg_f_mid[3]) );
  inv_1x U84 ( .a(dec_fsm_state[1]), .y(n89) );
  inv_1x U85 ( .a(dec_fsm_state[3]), .y(n104) );
  inv_1x U86 ( .a(reset), .y(n82) );
  inv_1x U87 ( .a(Instr[27]), .y(n62) );
  inv_1x U88 ( .a(ALUSrcA), .y(n63) );
  inv_1x U89 ( .a(n62), .y(ImmSrc) );
  inv_1x U90 ( .a(n63), .y(ALUSrcB[1]) );
  nor2_1x U91 ( .a(dec_fsm_state[3]), .b(dec_fsm_state[0]), .y(n92) );
  nor2_1x U92 ( .a(dec_fsm_state[3]), .b(dec_fsm_state[2]), .y(n90) );
  a2o1_1x U93 ( .a(n92), .b(n89), .c(n90), .y(ALUSrcA) );
  nor2_1x U94 ( .a(Instr[26]), .b(n62), .y(RegSrc[0]) );
  nand2_1x U95 ( .a(dec_fsm_state[1]), .b(dec_fsm_state[0]), .y(n107) );
  inv_1x U96 ( .a(n90), .y(n108) );
  nand2_1x U97 ( .a(dec_fsm_state[3]), .b(dec_fsm_state[2]), .y(n66) );
  nand2_1x U98 ( .a(n108), .b(n66), .y(n85) );
  inv_1x U99 ( .a(cl_CondExDelayed), .y(n64) );
  nor3_1x U100 ( .a(n107), .b(n85), .c(n64), .y(RegWrite) );
  and2_1x U101 ( .a(Rd[1]), .b(RegWrite), .y(n65) );
  nand3_1x U102 ( .a(Rd[0]), .b(Rd[2]), .c(n65), .y(n68) );
  inv_1x U103 ( .a(n66), .y(n87) );
  nand2_1x U104 ( .a(cl_CondExDelayed), .b(n87), .y(n67) );
  nand3_1x U105 ( .a(n68), .b(n108), .c(n67), .y(PCWrite) );
  or2_1x U106 ( .a(n104), .b(dec_fsm_state[2]), .y(n69) );
  nor3_1x U107 ( .a(dec_fsm_state[1]), .b(dec_fsm_state[0]), .c(n69), .y(n88)
         );
  and2_1x U108 ( .a(cl_CondExDelayed), .b(n88), .y(MemWrite) );
  inv_1x U109 ( .a(Instr[28]), .y(n74) );
  nor2_1x U110 ( .a(Instr[31]), .b(Instr[29]), .y(n70) );
  mux2_c_1x U111 ( .d0(cl_Flags[0]), .d1(cl_Flags[1]), .s(n70), .y(n72) );
  nand2_1x U112 ( .a(cl_Flags[1]), .b(Instr[31]), .y(n71) );
  nand2_1x U113 ( .a(n72), .b(n71), .y(n73) );
  mux2_c_1x U114 ( .d0(n74), .d1(Instr[28]), .s(n73), .y(n75) );
  nor2_1x U115 ( .a(Instr[30]), .b(n75), .y(n76) );
  nor2_1x U116 ( .a(reset), .b(n76), .y(cl_condreg_d2_0_) );
  inv_1x U117 ( .a(n76), .y(n80) );
  nand2_1x U118 ( .a(cl_Flags[0]), .b(n82), .y(n77) );
  a2o1_1x U119 ( .a(FlagW[0]), .b(n80), .c(n77), .y(n79) );
  nand3_1x U120 ( .a(FlagW[0]), .b(cl_condreg_d2_0_), .c(ALUFlags[0]), .y(n78)
         );
  nand2_1x U121 ( .a(n79), .b(n78), .y(cl_flagreg0_d2_0_) );
  nand2_1x U122 ( .a(FlagW[1]), .b(n80), .y(n81) );
  nand3_1x U123 ( .a(cl_Flags[1]), .b(n82), .c(n81), .y(n84) );
  nand3_1x U124 ( .a(cl_condreg_d2_0_), .b(ALUFlags[1]), .c(FlagW[1]), .y(n83)
         );
  nand2_1x U125 ( .a(n84), .b(n83), .y(cl_flagreg1_d2_0_) );
  nor2_1x U126 ( .a(dec_fsm_state[0]), .b(n89), .y(n99) );
  nand2_1x U127 ( .a(n89), .b(dec_fsm_state[0]), .y(n115) );
  inv_1x U128 ( .a(n115), .y(n100) );
  a2o1_1x U129 ( .a(n100), .b(n104), .c(n85), .y(n86) );
  a2o1_1x U130 ( .a(dec_fsm_state[3]), .b(n99), .c(n86), .y(ALUSrcB[0]) );
  nand2_1x U131 ( .a(dec_fsm_state[2]), .b(n104), .y(n116) );
  nor2_1x U132 ( .a(n116), .b(n107), .y(ResultSrc[0]) );
  or2_1x U133 ( .a(ALUSrcA), .b(n87), .y(ResultSrc[1]) );
  nor2_1x U134 ( .a(dec_fsm_state[0]), .b(n116), .y(n109) );
  a2o1_1x U135 ( .a(n109), .b(dec_fsm_state[1]), .c(n88), .y(AdrSrc) );
  nor2_1x U136 ( .a(dec_fsm_state[0]), .b(n108), .y(n97) );
  and2_1x U137 ( .a(n97), .b(n89), .y(IRWrite[0]) );
  and2_1x U138 ( .a(n99), .b(n90), .y(IRWrite[2]) );
  nor2_1x U139 ( .a(n100), .b(n99), .y(n91) );
  nor3_1x U140 ( .a(n91), .b(dec_fsm_state[2]), .c(n104), .y(ALUOp) );
  inv_1x U141 ( .a(n92), .y(n95) );
  nor2_1x U142 ( .a(Instr[27]), .b(Instr[25]), .y(n93) );
  nor3_1x U143 ( .a(n93), .b(Instr[26]), .c(dec_fsm_state[1]), .y(n94) );
  nor2_1x U144 ( .a(n95), .b(n94), .y(n96) );
  nor3_1x U145 ( .a(n97), .b(n96), .c(ALUOp), .y(n98) );
  nor2_1x U146 ( .a(reset), .b(n98), .y(dec_fsm_statereg_d2[0]) );
  nor2_1x U147 ( .a(n115), .b(n108), .y(IRWrite[1]) );
  a2o1_1x U148 ( .a(n100), .b(Funct[0]), .c(n99), .y(n103) );
  nand2_1x U149 ( .a(Instr[25]), .b(n109), .y(n101) );
  nor3_1x U150 ( .a(Instr[27]), .b(Instr[26]), .c(n101), .y(n102) );
  a2o1_1x U151 ( .a(n104), .b(n103), .c(n102), .y(n105) );
  nor3_1x U152 ( .a(IRWrite[1]), .b(n105), .c(ALUOp), .y(n106) );
  nor2_1x U153 ( .a(reset), .b(n106), .y(dec_fsm_statereg_d2[1]) );
  nor2_1x U154 ( .a(n108), .b(n107), .y(IRWrite[3]) );
  inv_1x U155 ( .a(n109), .y(n117) );
  nor3_1x U156 ( .a(Instr[26]), .b(Instr[27]), .c(dec_fsm_state[1]), .y(n110)
         );
  nor2_1x U157 ( .a(n117), .b(n110), .y(n113) );
  inv_1x U158 ( .a(Funct[0]), .y(n111) );
  nor3_1x U159 ( .a(n115), .b(n116), .c(n111), .y(n112) );
  nor3_1x U160 ( .a(n113), .b(IRWrite[3]), .c(n112), .y(n114) );
  nor2_1x U161 ( .a(reset), .b(n114), .y(dec_fsm_statereg_d2[2]) );
  and2_1x U162 ( .a(n62), .b(Instr[26]), .y(RegSrc[1]) );
  nor3_1x U163 ( .a(Funct[0]), .b(n116), .c(n115), .y(n119) );
  nor3_1x U164 ( .a(dec_fsm_state[1]), .b(RegSrc[1]), .c(n117), .y(n118) );
  nor3_1x U165 ( .a(ALUOp), .b(n119), .c(n118), .y(n120) );
  nor2_1x U166 ( .a(reset), .b(n120), .y(dec_fsm_statereg_d2[3]) );
endmodule

