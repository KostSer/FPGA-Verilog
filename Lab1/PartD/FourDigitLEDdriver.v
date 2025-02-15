`timescale 1ns/1ps

module FourDigitLEDdriver(reset, clk, an7, an6, an5, an4, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
    input clk, reset;
    output an7, an6, an5, an4, an3, an2, an1, an0;
    output a, b, c, d, e, f, g, dp;

    wire en;

    wire [3:0] pointer;
    wire [3:0] char_displayed;
    wire [4:0] counter;
    wire [6:0] temp_vector;
    
    wire slow_clock;
    wire reset_sync;
    wire reset_prime;
    wire reset_clear;
    
    // CLKOUT1 = CLK * (5 * 1 / 100)
    // CLKOUT1 the new, slower clock 0.20us-200ns
    MMCME2 MMCME2_inst(.clk(clk),
                       .CLKOUT1(slow_clock)
                       );


    // RESET 2FF
    synchronizer_2FF synchronizer_2FF_inst1_reset(.sig(reset), 
                                           .clk(slow_clock),
                                           .sig_sync(reset_sync),
                                           .sig_prime(reset_prime)
                                           );

    // RESET DEBOUNCER
    debouncer debouncer_inst1_reset(.signal(reset_sync),
                             .en(en),
                             .clk(slow_clock), 
                             .signal_clear(reset_clear)
                             );

    // FSM for the anodes 
    ANcontroller ANcontroller_inst(.clk(slow_clock),
                                   .reset(reset_clear),
                                   .counter(counter),
                                   .an7(an7), 
                                   .an6(an6), 
                                   .an5(an5), 
                                   .an4(an4), 
                                   .an3(an3), 
                                   .an2(an2), 
                                   .an1(an1), 
                                   .an0(an0)
                                   );

    // counter for the Anode FSM (Anode controller)
    counter counter_inst(.clk(slow_clock),
                         .reset(reset_clear),
                         .Q(counter)
                         );

    // LEDdecoder
    LEDdecoder LEDdecoder_inst (.char(char_displayed),
                                .LED(temp_vector)
                                );

    // controller for the cathodes
    CAcontroller CAcontroller_inst (.clk(slow_clock),
                                    .reset(reset_clear),
                                    .counter(counter),
                                    .temp_vector(temp_vector),
                                    .a(a),
                                    .b(b),
                                    .c(c),
                                    .d(d),
                                    .e(e),
                                    .f(f),
                                    .g(g),
                                    .dp(dp)
                                    );

    // counter for the address change of the message memory
    ADDRESSchange ADDRESSchange_inst(.clk(slow_clock),
                                     .reset(reset_clear),
                                     .pointer(pointer)
                                     );

    // transmits the right character to the decoder based on the counter and the clock
    // message: 03604abc00cafe21
    feedDecoder feedDecoder_inst(.clk(slow_clock),
                                 .reset(reset_clear),
                                 .counter(counter),
                                 .pointer(pointer),
                                 .message1(4'b0000), //0
                                 .message2(4'b0011), //3
                                 .message3(4'b0110), //6
                                 .message4(4'b0000), //0
                                 .message5(4'b0100), //4
                                 .message6(4'b1010), //a
                                 .message7(4'b1011), //b
                                 .message8(4'b1100), //c
                                 .message9(4'b0000), //0
                                 .message10(4'b0000), //0
                                 .message11(4'b1100), //c
                                 .message12(4'b1010), //a
                                 .message13(4'b1111), //f
                                 .message14(4'b1110), //e
                                 .message15(4'b0010), //2
                                 .message16(4'b0001), //1
                                 .char_displayed(char_displayed)
                                 );
    // debouncer
    assign en = reset_prime ^ reset_sync;

endmodule