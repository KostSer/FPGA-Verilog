`timescale 1ns/1ps
module ANcontroller (clk, reset, counter, an7, an6, an5, an4, an3, an2, an1, an0);
    input clk, reset;
    input [4:0]counter;
    output reg an7, an6, an5, an4, an3, an2, an1, an0; 

    always @(posedge clk or posedge reset)
    begin
        if(reset == 1) begin
            {an7, an6, an5, an4, an3, an2, an1, an0} <= 8'b11111111; 
        end
        else begin
            case (counter)
                5'b11111: an7 <= 0;  // 5'b11110 + 1
                5'b11011: an6 <= 0; // 5'b11010 + 1
                5'b10111: an5 <= 0; // 5'b10110 + 1
                5'b10011: an4 <= 0; // 5'b10010 + 1
                5'b01111: an3 <= 0; // 5'b01110 + 1
                5'b01011: an2 <= 0; // 5'b01010 + 1
                5'b00111: an1 <= 0; // 5'b00110 + 1
                5'b00011: an0 <= 0; // 5'b00010 + 1
                default: {an7, an6, an5, an4, an3, an2, an1, an0} <= 8'b11111111; 
            endcase
        end
    end

endmodule