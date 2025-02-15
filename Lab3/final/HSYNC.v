`timescale 1ns/1ps
module HSYNC(clk, reset, HSYNC, HPIXEL, offDisplay_H);
    input clk, reset;
    output [6:0] HPIXEL; // 0 - 127
    output HSYNC, offDisplay_H;

    HSYNC_FSM HSYNC_FSM_inst(.clk(clk),
                             .reset(reset),
                             .HPIXEL(HPIXEL),
                             .HSYNC(HSYNC),
                             .offDisplay_H(offDisplay_H)
                             );

endmodule