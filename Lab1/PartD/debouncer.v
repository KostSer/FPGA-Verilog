`timescale 1ns/1ps
module debouncer(signal, en, clk, signal_clear);
    input signal, clk, en;
    output reg signal_clear = 0;
    reg [14:0]counter;

    always@(posedge clk) begin
        if(en) // reset
            //counter <= 15'b000000000000100; // 64 for test
            counter <= 15'b111111111111111; // 32768 cycles with new, slower clock = 6.5ms
        else if(counter == 0) // signal stabilized
            signal_clear <= signal;
        else // counts
            counter <= counter - 1'b1;
    end
endmodule