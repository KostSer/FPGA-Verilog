`timescale 1ns/1ps
module pulseconverter(sig, clk, out);
    input sig, clk;
    output out;
    reg q1, q2;

    always @(posedge clk) begin
        q1 <= sig;
        q2 <= sig & q1;
    end

    assign out = q1 & ~q2;
endmodule