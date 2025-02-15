`timescale 1ns/1ps
module counter #(parameter WIDTH = 5) (input clk, reset,
                                   output reg [WIDTH-1:0] Q
                                   );

    always @(posedge clk or posedge reset) begin
        if(reset == 1)
            Q <= {WIDTH{1'b1}}; //
        else if(Q == {WIDTH{1'b0}})
            Q <= {WIDTH{1'b1}};
        else
            Q <= Q - 1'b1;
    end


    
endmodule