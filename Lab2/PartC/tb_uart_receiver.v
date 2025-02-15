module tb_uart_receiver;
    reg reset, clk;
    reg [2:0] baud_select;
    reg Rx_EN;
    reg RxD;

    wire [7:0] Rx_DATA;
    wire Rx_FERROR; 
    wire Rx_PERROR;
    wire Rx_VALID;

    uart_receiver uart_receiver_inst(.clk(clk),
                                     .reset(reset),
                                     .Rx_DATA(Rx_DATA),
                                     .baud_select(baud_select),
                                     .Rx_EN(Rx_EN),
                                     .RxD(RxD),
                                     .Rx_FERROR(Rx_FERROR),
                                     .Rx_PERROR(Rx_PERROR),
                                     .Rx_VALID(Rx_VALID)
                                     );

    initial begin
        clk = 0;
        reset = 1;
        baud_select = 3'b111;
        
        #1000 reset = 0;
        Rx_EN = 0;
        // SWITCH TRANSMITTER ON
        #10000 Rx_EN = 1;
        #10 Rx_EN = 0;
        #10 Rx_EN = 1;

        //...
    end

    always #5 clk = ~clk;

endmodule