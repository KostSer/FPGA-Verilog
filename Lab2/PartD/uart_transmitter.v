module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    input reset, clk;
    input [7:0] Tx_DATA;
    input [2:0] baud_select;
    input Tx_EN;
    input Tx_WR;

    output TxD;
    output Tx_BUSY;

    wire Tx_sample_ENABLE;
    wire GotData;

    baud_controller baud_controller_tx_inst(.reset(reset),
                                            .clk(clk), 
                                            .baud_select(baud_select), 
                                            .sample_ENABLE(Tx_sample_ENABLE),
                                            .enable(Tx_EN && GotData),
                                            .type(1'b0) // TX
                                            );

    FSM_transmitter FSM_transmitter_inst(.clk(clk),
                                         .reset(reset),
                                         .Tx_DATA(Tx_DATA), 
                                         .Tx_sample_ENABLE(Tx_sample_ENABLE),
                                         .Tx_WR(Tx_WR), 
                                         .Tx_EN(Tx_EN), 
                                         .TxD(TxD), 
                                         .Tx_BUSY(Tx_BUSY),
                                         .GotData(GotData)
                                         );

endmodule