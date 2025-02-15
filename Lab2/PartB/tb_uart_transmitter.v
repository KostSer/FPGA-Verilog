module tb_uart_transmitter;
    reg reset, clk;
    reg [7:0] Tx_DATA;
    reg [2:0] baud_select;
    reg Tx_EN;
    reg Tx_WR;

    wire TxD;
    wire Tx_BUSY;

    uart_transmitter uart_transmitter_inst(.clk(clk),
                                           .reset(reset),
                                           .Tx_DATA(Tx_DATA),
                                           .baud_select(baud_select),
                                           .Tx_EN(Tx_EN),
                                           .Tx_WR(Tx_WR),
                                           .TxD(TxD),
                                           .Tx_BUSY(Tx_BUSY)
                                           );

    initial begin
        clk = 0;
        reset = 1;
        baud_select = 3'b111;
        #1000 reset = 0;
        Tx_EN = 0;
        // SWITCH TRANSMITTER ON
        #10000 Tx_EN = 1;
        #10 Tx_EN = 0;
        #10 Tx_EN = 1;

        ///////////////////////
        // FIRST TWO CHARACTERS
        ///////////////////////
        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @(Tx_BUSY == 0);

        #30000;

        /////////////////////
        // 2nd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @(Tx_BUSY == 0);

        #30000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @(Tx_BUSY == 0);

        #30000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @(Tx_BUSY == 0);

        #30000;
        $finish;
    end

    always #5 clk = ~clk;

endmodule