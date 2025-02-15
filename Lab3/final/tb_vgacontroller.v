module tb_vgacontroller;
    reg clk, reset;
    wire VGA_RED, VGA_GREEN, VGA_BLUE;
    wire VGA_HSYNC, VGA_VSYNC;

    vgacontroller vgacontroller_inst(.clk(clk),
                                     .reset(reset),
                                     .VGA_RED(VGA_RED),
                                     .VGA_GREEN(VGA_GREEN),
                                     .VGA_BLUE(VGA_BLUE),
                                     .VGA_HSYNC(VGA_HSYNC),
                                     .VGA_VSYNC(VGA_VSYNC)
                                     );
                                     
    initial begin
        clk = 0;
        reset = 0;
        #100 reset = 1;

        #10000000 reset = 0;

        repeat(10) begin
            #10000000;
        end

        #10000 $finish;
    end

    always #5 clk = ~clk;
endmodule