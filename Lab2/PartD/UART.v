module UART(reset, clk, baud_select_R, baud_select_T, Rx_EN, Tx_EN, Tx_DATA,
             Tx_WR, Tx_BUSY, Rx_DATA, Rx_FERROR, Rx_PERROR, 
             Rx_VALID, ready);
             
    input reset, clk;
    input [2:0] baud_select_R, baud_select_T;
    input Rx_EN, Tx_EN;
    input [7:0] Tx_DATA;
    input Tx_WR;

    // out to system
    output Tx_BUSY;
    output [7:0] Rx_DATA;
    output Rx_FERROR; // Framing Error //
    output Rx_PERROR; // Parity Error //
    output Rx_VALID; // Rx_DATA is Valid //
    output ready;

    // COMMON CHANNEL
    wire channel; // RxD, TxD

    // TRANSMITTER INSTANTIATION
    uart_transmitter uart_transmitter_inst(.clk(clk),
                                           .reset(reset),
                                           .Tx_DATA(Tx_DATA),
                                           .baud_select(baud_select_T),
                                           .Tx_WR(Tx_WR),
                                           .Tx_EN(Tx_EN),
                                           .TxD(channel),
                                           .Tx_BUSY(Tx_BUSY)
                                           );

    // RECEIVER INSTANTIATION
    uart_receiver uart_receiver_inst(.clk(clk),
                                     .reset(reset),
                                     .Rx_DATA(Rx_DATA),
                                     .baud_select(baud_select_R),
                                     .Rx_EN(Rx_EN),
                                     .RxD(channel),
                                     .Rx_FERROR(Rx_FERROR),
                                     .Rx_PERROR(Rx_PERROR),
                                     .Rx_VALID(Rx_VALID),
                                     .ready(ready)
                                     );
endmodule