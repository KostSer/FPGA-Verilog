`timescale 1ns/1ps
module feedDecoder (clk, reset, counter, pointer, message1, message2, message3, message4, 
                    message5, message6, message7, message8, message9,
                     message10, message11, message12, message13, message14, 
                     message15, message16, char_displayed);

    input clk, reset;
    input [4:0] counter;
    input [3:0] pointer, message1, message2, message3, message4, 
                message5, message6, message7, message8, message9,
                message10, message11, message12, message13, message14, 
                message15, message16;
    output reg [3:0] char_displayed;
    reg [3:0] message [15:0];

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            message[0] <= message1;
            message[1] <= message2;
            message[2] <= message3;
            message[3] <= message4;
            message[4] <= message5;
            message[5] <= message6;
            message[6] <= message7;
            message[7] <= message8;
            message[8] <= message9;
            message[9] <= message10;
            message[10] <= message11;
            message[11] <= message12;
            message[12] <= message13;
            message[13] <= message14;
            message[14] <= message15;
            message[15] <= message16;
        end
        else begin
            case (counter)
                5'b11110: char_displayed <= (pointer+1 > 15) ? message[pointer + 1 - 16]: message[pointer + 1]; // +2 on the counter
                5'b11010: char_displayed <= (pointer+2 > 15) ? message[pointer + 2 - 16]: message[pointer + 2]; // +2 on the counter
                5'b10110: char_displayed <= (pointer+3 > 15) ? message[pointer + 3 - 16]: message[pointer + 3]; // +2 on the counter
                5'b10010: char_displayed <= (pointer+4 > 15) ? message[pointer + 4 - 16]: message[pointer + 4]; // +2 on the counter 
                5'b01110: char_displayed <= (pointer+5 > 15) ? message[pointer + 5 - 16]: message[pointer + 5]; // +2 on the counter 
                5'b01010: char_displayed <= (pointer+6 > 15) ? message[pointer + 6 - 16]: message[pointer + 6]; // +2 on the counter 
                5'b00110: char_displayed <= (pointer+7 > 15) ? message[pointer + 7 - 16]: message[pointer + 7]; // +2 on the counter 
                5'b00010: char_displayed <= message[pointer];
            endcase
        end
    end
    
endmodule