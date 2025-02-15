`timescale 1ns/1ps
    module ADDRESSchange (clk, BTNR, reset, pointer);
    input BTNR, reset, clk;
    output reg [3:0] pointer;

    always @(posedge clk or posedge reset) begin
        if(reset)
            pointer <= 4'b0000;
        else if(BTNR) begin
            if(pointer == 4'b1111)
                pointer <= 4'b0000;
            else
                pointer <= pointer + 1;
        end
    end
endmodule