`timescale 1ns/1ps
module counter #(parameter WIDTH = 5) (input clk, reset, input [WIDTH-1:0] MAX_VAL,
                                   output reg [WIDTH-1:0] Q
                                   );

    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            Q <= MAX_VAL; //
        end
        else begin
            if(Q == {WIDTH{1'b0}})
                Q <= MAX_VAL;
            else
                Q <= Q - 1'b1;
        end
    end
    
endmodule