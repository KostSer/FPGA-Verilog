module tb_VRAM;
    reg clk, reset;
    reg [13:0] addr;
    wire [2:0] out_RGB;

    VRAM VRAM_inst(.addr(addr),
                   .reset(reset),
                   .clk(clk),
                   .out(out_RGB)
                   );

    initial begin
        clk = 0;
        reset = 1;

        #100 reset = 0;
        $monitor("For addr: %d, R is %b, G is %b and B is %b", addr, out_RGB[2], out_RGB[1], out_RGB[0]);
        #1000 addr = 14'b00000000000000; // first white
        #1000 addr = 14'b00000100000000; // first non white should be red
        #1000 addr = 14'b00110100000000; // first green
        #1000 addr = 14'b01100100000000; // first blue
        #1000 addr = 14'b10010100000000; // first black
        #1000 addr = 14'b10010100000010; // next to first black, first color
        #1000 addr = 14'b10010110000000; // first white
        #1000 addr = 14'b10010110000010; // next to first white, first color

        #1000 $finish;
    end

    always #5 clk = ~clk;
endmodule