module VRAM(addr, clk, reset, out);
    input clk, reset;
    input [13:0]addr;
    output [2:0] out;

    wire [31:0] outR, outG, outB;

    VRAM_Red VRAM_Red_inst(.addr(addr),
                           .reset(reset),
                           .clk(clk),
                           .out(outR)
                           );

    VRAM_Green VRAM_Green_inst(.addr(addr),
                           .clk(clk),
                           .reset(reset),
                           .out(outG)
                           );

    VRAM_Blue VRAM_Blue_inst(.addr(addr),
                           .reset(reset),
                           .clk(clk),
                           .out(outB)
                           );

    assign out = {outR[0], outG[0], outB[0]};
endmodule