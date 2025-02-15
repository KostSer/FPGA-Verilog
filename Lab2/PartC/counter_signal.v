`timescale 1ns/1ps
// counter based on signals being ON
module counter_signal #(parameter WIDTH = 5) (input clk, reset, signal, input [WIDTH-1:0] MAX_VAL,
                                   output reg [WIDTH-1:0] Q
                                   );

    always @(posedge clk or posedge reset) begin
        if(reset == 1)
            Q <= {WIDTH{1'b0}};
        else if (signal) begin
            if (Q == MAX_VAL)
                Q <= {WIDTH{1'b0}};
            else
                Q <= Q + 1'b1;
        end
    end
    
endmodule