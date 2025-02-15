`timescale 1ns/1ps
module ADDRESSchange (clk, reset, pointer);
    input clk, reset;
    output reg [3:0] pointer;
    wire [22:0] cntr;
    
    // 1,6777214s
    counter #(23) autochangeCounter(.clk(clk),
                                    .reset(reset),
                                    .Q(cntr)
                                    );

    always @(posedge clk or posedge reset) begin
        if(reset)
            pointer <= 4'b0000;
        else if(cntr == 23'b0) begin
            if(pointer == 4'b1111)
                pointer <= 4'b0000;
            else
                pointer <= pointer + 1;
        end
    end
endmodule