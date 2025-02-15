`timescale 1ns/1ps
module uart_receiver(reset, clk, Rx_DATA, baud_select, Rx_EN, 
                     RxD, Rx_FERROR, Rx_PERROR, Rx_VALID, ready);

input reset, clk;
input [2:0] baud_select;
input Rx_EN;
input RxD;

output [7:0] Rx_DATA;
output Rx_FERROR; // Framing Error //
output Rx_PERROR; // Parity Error //
output Rx_VALID; // Rx_DATA is Valid //
output ready;

wire Rx_sample_ENABLE;

baud_controller baud_controller_tx_inst(.reset(reset),
                                        .clk(clk), 
                                        .baud_select(baud_select), 
                                        .sample_ENABLE(Rx_sample_ENABLE),
                                        .enable(Rx_EN),
                                        .type(1'b1) // RX
                                        );

FSM_receiver FSM_receiver_inst(.clk(clk),
                               .reset(reset),
                               .Rx_sample_ENABLE(Rx_sample_ENABLE),
                               .Rx_EN(Rx_EN),
                               .RxD(RxD),
                               .Rx_DATA(Rx_DATA),
                               .Rx_FERROR(Rx_FERROR),
                               .Rx_PERROR(Rx_PERROR),
                               .Rx_VALID(Rx_VALID),
                               .ready(ready)
                               );

endmodule
