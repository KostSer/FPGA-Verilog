module LEDdecoder(char, LED);
    input [3:0] char;
    output reg [6:0] LED;

    // LSB -> MSB
    //0 A top
    //1 B top right
    //2 C bottom right
    //3 D bottom
    //4 E bottom left
    //5 F top left
    //6 G middle

    always @(char)
    begin
        case (char)
            //                GFEDCBA
            4'b0000: LED = 7'b1000000; // 0
            4'b0001: LED = 7'b1111001; // 1
            4'b0010: LED = 7'b0100100; // 2
            4'b0011: LED = 7'b0110000; // 3
            4'b0100: LED = 7'b0011001; // 4
            4'b0101: LED = 7'b0010010; // 5 
            4'b0110: LED = 7'b0000010; // 6 
            4'b0111: LED = 7'b1111000; // 7 
            4'b1000: LED = 7'b0000000; // 8 
            4'b1001: LED = 7'b0011000; // 9 
            4'b1010: LED = 7'b0100000; // a  
            4'b1011: LED = 7'b0000011; // b 
            4'b1100: LED = 7'b0100111; // c 
            4'b1101: LED = 7'b0100001; // d 
            4'b1110: LED = 7'b0000100; // e 
            4'b1111: LED = 7'b0001110; // F 
        endcase
    end
endmodule