`include "LEDdecoder.v"
module LEDdecoder_tb;
    reg [3:0]char;
    wire [6:0]LED;
    integer i;

    LEDdecoder LEDdecoder_inst(char, LED);

    initial begin
        char = 4'b0000;
        for (i = 0; i < 16; i = i + 1) begin
            #5 $display("Char is: %b", char);
            $display("                     GFEDCBA");
            $display("For %0h, LED state is: %b\n", i, LED);
            char = char + 1'b1;
        end
    end

endmodule