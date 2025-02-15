`timescale 1ns/1ps

// load cathodes 2 cycles before the anode's activation
module CAcontroller (clk, reset, counter, temp_vector, a, b, c, d, e, f, g, dp);
    input clk, reset;
    input [4:0] counter;
    input [6:0] temp_vector;

    output reg a, b, c, d, e, f, g, dp;

    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            {g, f, e, d, c, b, a} <= 7'b1111111;
            dp <= 1;
        end
        else begin
            //latch before changing to new number
            case (counter)
                5'b11101: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
                5'b11001: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
                5'b10101: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
                5'b10001: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
                5'b01101: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
                5'b01001: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
                5'b00101: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
                5'b00001: begin
                    {g, f, e, d, c, b, a} <= temp_vector; // 5'b11100 + 1
                    dp <= 1;
                end
            endcase
        end
    end
endmodule