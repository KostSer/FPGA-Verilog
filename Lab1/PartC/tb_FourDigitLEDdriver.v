`timescale 1ns/1ps
module tb_FourDigitLEDdriver;
    reg clk, reset, BTNR;
    wire an7, an6, an5, an4, an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;
    integer i;

    FourDigitLEDdriver FDLEDdriver_inst(.reset(reset), 
                                        .clk(clk),
                                        .BTNR(BTNR),
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
        BTNR = 0;
        clk = 0;

        #4500 reset = 1; 
        #7000000 reset = 0; // 7ms
        for(i = 0; i < 32; i = i + 1) begin
            #7000000 BTNR = 1; // 7ms
            #7000000 BTNR = 0;
            //#2000000000 BTNR = 1; //2s
            //#2000000000 BTNR = 0; //2s
        end
        
        #1000 $finish;
    end

    always #5 clk = ~clk;

endmodule