`timescale 1ns/1ps
module tb_HSYNC;
    reg clk, reset;
    wire [6:0] HPIXEL;
    wire HSYNC, offDisplay_H;

    HSYNC HSYNC_inst(.HSYNC(HSYNC),
                   .reset(reset),
                   .clk(clk),
                   .HPIXEL(HPIXEL),
                   .offDisplay_H(offDisplay_H)
                   );

    initial begin
        clk = 0;
        reset = 1;

        #10000 reset = 0;

        #100000 $finish;
    end

    always #5 clk = ~clk;
endmodule