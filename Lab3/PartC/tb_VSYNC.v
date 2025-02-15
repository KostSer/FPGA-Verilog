`timescale 1ns/1ps
module tb_VSYNC;
    reg clk, reset;
    wire [6:0] VPIXEL;
    wire VSYNC, offDisplay_V;

    VSYNC VSYNC_inst(.VSYNC(VSYNC),
                   .reset(reset),
                   .clk(clk),
                   .VPIXEL(VPIXEL),
                   .offDisplay_V(offDisplay_V)
                   );

    initial begin
        clk = 0;
        reset = 1;
        
        #10000 reset = 0;
        
        #10000000;
        #10000000;
        #10000000;
        #10000000;
        #10000000 $finish;
    end

    always #5 clk = ~clk;
endmodule