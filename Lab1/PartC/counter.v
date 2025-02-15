`timescale 1ns/1ps
module counter(clk, reset, Q);
    input clk, reset;
    output reg [4:0] Q;

    always @(posedge clk) begin
        if(reset == 1)
            Q <= 5'b11111; //
        else if(Q == 5'b00000)
                Q <= 5'b11111;
        else
            Q <= Q - 1'b1;
    end
endmodule