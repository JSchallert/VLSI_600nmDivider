module testbench();
    logic a, b, y;
    
    // The device under test
    or2 dut(a, b, y);

	`include "testfixture.verilog"
    
endmodule

module or2(input  logic a,
           input  logic b,
           output logic y);
             
   assign #1 y = (a || b);    
endmodule

