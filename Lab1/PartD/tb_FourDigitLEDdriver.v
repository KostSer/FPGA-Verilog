`timescale 1ns/1ps
module tb_FourDigitLEDdriver;
    reg clk, reset;
    wire an7, an6, an5, an4, an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;
    integer i;

    FourDigitLEDdriver FDLEDdriver_inst(.reset(reset), 
                                        .clk(clk),
                                        .an7(an7), 
                                        .an6(an6), 
                                        .an5(an5), 
                                        .an4(an4), 
                                        .an3(an3), 
                                        .an2(an2), 
                                        .an1(an1), 
                                        .an0(an0), 
                                        .a(a), 
                                        .b(b), 
                                        .c(c), 
                                        .d(d), 
                                        .e(e), 
                                        .f(f), 
                                        .g(g), 
                                        .dp(dp)
                                        );
                                        
    // message displayed: 03604abc00cafe21
    initial begin
        reset = 0;
        clk = 0;

        #4500 reset = 1; 
        #7000000 reset = 0; // 7ms
        repeat(25000000) @(posedge(clk)); //2.5s

        repeat(25000000) @(posedge(clk)); //2.5s
        #1000 $finish;
    end

    always #5 clk = ~clk;

endmodule