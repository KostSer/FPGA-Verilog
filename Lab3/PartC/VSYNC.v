`timescale 1ns/1ps
module VSYNC(clk, reset, VSYNC, VPIXEL, offDisplay_V);
    input clk, reset;
    output [6:0] VPIXEL; // 0 - 95
    output VSYNC, offDisplay_V;

    //RESET 2FF
    synchronizer_2FF synchronizer_2FF_inst(.sig(reset),
                                           .clk(clk),
                                           .sig_sync(reset_sync),
                                           .sig_prime(reset_prime)
                                           );

    VSYNC_FSM VSYNC_FSM_inst(.clk(clk),
                             .reset(reset_sync),
                             .VPIXEL(VPIXEL),
                             .VSYNC(VSYNC),
                             .offDisplay_V(offDisplay_V)
                             );

endmodule