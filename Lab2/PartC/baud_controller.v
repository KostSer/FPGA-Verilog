`timescale 1ns/1ps
module baud_controller(reset, clk, baud_select, sample_ENABLE, enable, type);
    input reset, clk, enable, type;
    input [2:0] baud_select;
    output sample_ENABLE;
    
    wire [18:0] counter;
    wire [18:0] maximum_cycles; // max to cover all transmission rates
    wire reset_prime, reset_sync;   
    
    synchronizer_2FF sync_inst(.clk(clk),
                               .sig(reset),
                               .sig_sync(reset_sync),
                               .sig_prime(reset_prime)
                               );

    counter #(19) counter_inst1 (.clk(clk),
                         .reset(reset_sync || ~enable),
                         .Q(counter),
                         .MAX_VAL(maximum_cycles)
                         );

    baud_func baud_func_inst (.clk(clk),
                              .type(type),
                              .reset(reset_sync),
                              .baud_select(baud_select),
                              .counter(counter),
                              .maximum_cycles(maximum_cycles),
                              .sample_ENABLE(sample_ENABLE)
                             );

endmodule