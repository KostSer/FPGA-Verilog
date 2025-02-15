`timescale 1ns/1ps
module VSYNC(clk, reset, VSYNC, VPIXEL, offDisplay_V);
    input clk, reset;
    output [6:0] VPIXEL; // 0 - 95
    output VSYNC, offDisplay_V;

    VSYNC_FSM VSYNC_FSM_inst(.clk(clk),
                             .reset(reset),
                             .VPIXEL(VPIXEL),
                             .VSYNC(VSYNC),
                             .offDisplay_V(offDisplay_V)
                             );

endmodule