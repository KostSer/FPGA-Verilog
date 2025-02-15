`timescale 1ns/1ps
module HSYNC(clk, reset, HSYNC, HPIXEL, offDisplay_H);
    input clk, reset;
    output [6:0] HPIXEL; // 0 - 127
    output HSYNC, offDisplay_H;

    //RESET 2FF
    synchronizer_2FF synchronizer_2FF_inst(.sig(reset),
                                           .clk(clk),
                                           .sig_sync(reset_sync),
                                           .sig_prime(reset_prime)
                                           );

    HSYNC_FSM HSYNC_FSM_inst(.clk(clk),
                             .reset(reset_sync),
                             .HPIXEL(HPIXEL),
                             .HSYNC(HSYNC),
                             .offDisplay_H(offDisplay_H)
                             );

endmodule