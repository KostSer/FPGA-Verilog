module vgacontroller(reset, clk, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC);
    input reset, clk;
    output VGA_RED, VGA_GREEN, VGA_BLUE;
    output VGA_HSYNC, VGA_VSYNC;

    wire reset_prime, reset_sync, reset_clear;
    wire [13:0]vga_addr; // log2(128*96) {7,7}
    wire [6:0] HPIXEL, VPIXEL;
    wire en;
    wire offDisplay_H, offDisplay_V;

    //RESET 2FF
    synchronizer_2FF synchronizer_2FF_inst(.sig(reset),
                                           .clk(clk),
                                           .sig_sync(reset_sync),
                                           .sig_prime(reset_prime)
                                           );

    // RESET DEBOUNCER
    debouncer debouncer_inst1_reset(.signal(reset_sync),
                                    .en(en),
                                    .clk(clk), 
                                    .signal_clear(reset_clear)
                                    );

    VRAM VRAM_inst(.addr(vga_addr),
                   .reset(reset_clear),
                   .clk(clk),
                   .out({VGA_RED, VGA_GREEN, VGA_BLUE})
                   );

    HSYNC HSYNC_inst(.clk(clk),
                     .reset(reset_clear),
                     .HSYNC(VGA_HSYNC),
                     .HPIXEL(HPIXEL),
                     .offDisplay_H(offDisplay_H)
                     );

    VSYNC VSYNC_inst(.clk(clk),
                     .reset(reset_clear),
                     .VSYNC(VGA_VSYNC),
                     .VPIXEL(VPIXEL),
                     .offDisplay_V(offDisplay_V)
                     );

    //addr of vram based on display or not           //black pixel in photo.// 
    assign vga_addr = (offDisplay_V || offDisplay_H)? 14'b10010100000000: {VPIXEL, HPIXEL};
    
    // debouncer
    assign en = reset_prime ^ reset_sync;
endmodule