`timescale 1ns/1ps
module debouncer(signal, en, clk, signal_clear);
    input signal, clk, en;
    output reg signal_clear = 0;
    reg [19:0]counter;

    always@(posedge clk) begin
        if(en) // reset
            counter <= 20'b10011110101100010000; // 6.5ms
        else if(counter == 0) // signal stabilized
            signal_clear <= signal;
        else // counts
            counter <= counter - 1'b1;
    end
endmodule