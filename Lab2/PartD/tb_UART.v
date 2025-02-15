module tb_uart_transmitter;
    reg reset, clk;
    reg [2:0] baud_select_R, baud_select_T;
    reg Rx_EN, Tx_EN;
    reg [7:0] Tx_DATA;
    reg Tx_WR;

    wire Tx_BUSY;
    wire [7:0] Rx_DATA;
    wire Rx_FERROR; // Framing Error //
    wire Rx_PERROR; // Parity Error //
    wire Rx_VALID; // Rx_DATA is Valid //
    wire Rx_ready;

    UART UART_inst(.clk(clk),
                   .reset(reset),
                   .Tx_DATA(Tx_DATA),
                   .baud_select_R(baud_select_R),
                   .baud_select_T(baud_select_T),
                   .Tx_EN(Tx_EN),
                   .Rx_EN(Rx_EN),
                   .Tx_WR(Tx_WR),
                   .Tx_BUSY(Tx_BUSY),
                   .Rx_DATA(Rx_DATA),
                   .Rx_FERROR(Rx_FERROR),
                   .Rx_PERROR(Rx_PERROR),
                   .Rx_VALID(Rx_VALID),
                   .ready(Rx_ready)
                   );

    initial begin
        clk = 0;
        reset = 1;
        Tx_EN = 0;
        Rx_EN = 0;
        Tx_DATA = 8'b0;
        baud_select_T = 3'b000;
        baud_select_R = 3'b000;
        Tx_WR = 1'b0;

        #1000 baud_select_T = 3'b111; // 7
        baud_select_R = 3'b111; // 7

        #1000 reset = 0;

        // SWITCH TRANSMITTER AND RECIEVER ON
        #10000;
        Tx_EN = 1;
        Rx_EN = 1;

        ///////////////////////
        // FIRST TWO CHARACTERS
        ///////////////////////
        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;
        ///////////////////
        //2nd TWO CHARACTERS
        ///////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

//???????????????????????????????????????//
        //#######################//
        // TRY FOR DIFF BAUD SEL //
        //#######################//        
//???????????????????????????????????????//

        // SWITCH TRANSMITTER AND RECIEVER OFF
        Tx_EN = 0;
        Rx_EN = 0;

        // SWITCH TRANSMITTER AND RECIEVER ON
        #25000;
        Tx_EN = 1;
        Rx_EN = 1;

        reset = 1;
        baud_select_T = 3'b110; // 6
        baud_select_R = 3'b110; // 6

        #1000 reset = 0;

        ///////////////////////
        // FIRST TWO CHARACTERS
        ///////////////////////
        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;
        ///////////////////
        //2nd TWO CHARACTERS
        ///////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

//???????????????????????????????????????//
        //#######################//
        // TRY FOR ERRORS TO OCCUR
        //#######################//        
//???????????????????????????????????????//

        // SWITCH TRANSMITTER AND RECIEVER OFF
        Tx_EN = 0;
        Rx_EN = 0;

        // SWITCH TRANSMITTER AND RECIEVER ON
        #25000;
        Tx_EN = 1;
        Rx_EN = 1;

        reset = 1;
        baud_select_T = 3'b111; // 7
        baud_select_R = 3'b011; // 3

        #1000 reset = 0;

        ///////////////////////
        // FIRST TWO CHARACTERS
        ///////////////////////
        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;
        ///////////////////
        //2nd TWO CHARACTERS
        ///////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        
        #30000;

    // AGAIN AGAIN AGAIN AGAIN //

        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;
        ///////////////////
        //2nd TWO CHARACTERS
        ///////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        
        #30000;

//???????????????????????????????????????????????//
        //#################################//
        // TRY FOR GOOD TRANSMISSION AGAIN
        //#################################//        
// ??????????????????????????????????????????????//

        // SWITCH TRANSMITTER AND RECIEVER OFF
        Tx_EN = 0;
        Rx_EN = 0;

        // SWITCH TRANSMITTER AND RECIEVER ON
        #25000;
        Tx_EN = 1;
        Rx_EN = 1;

        reset = 1;
        baud_select_T = 3'b100; // 4
        baud_select_R = 3'b100; // 4

        #1000 reset = 0;

        ///////////////////////
        // FIRST TWO CHARACTERS
        ///////////////////////
        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;
        ///////////////////
        //2nd TWO CHARACTERS
        ///////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #30000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        
        #30000;

//???????????????????????????????????????//
        //#######################//
        // TRY FOR ERRORS TO OCCUR
        //#######################//        
//???????????????????????????????????????//

        // SWITCH TRANSMITTER AND RECIEVER OFF
        Tx_EN = 0;
        Rx_EN = 0;

        // SWITCH TRANSMITTER AND RECIEVER ON
        #25000;
        Tx_EN = 1;
        Rx_EN = 1;

        reset = 1;
        baud_select_T = 3'b111; // 7
        baud_select_R = 3'b110; // 6

        #1000 reset = 0;

        ///////////////////////
        // FIRST TWO CHARACTERS
        ///////////////////////
        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #120000;
        ///////////////////
        //2nd TWO CHARACTERS
        ///////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #120000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #120000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        
        #120000;
        
//???????????????????????????????????????????????//
        //#################################//
        // TRY FOR GOOD TRANSMISSION AGAIN
        //#################################//        
// ??????????????????????????????????????????????//

        // SWITCH TRANSMITTER AND RECIEVER OFF
        Tx_EN = 0;
        Rx_EN = 0;

        // SWITCH TRANSMITTER AND RECIEVER ON
        #25000;
        Tx_EN = 1;
        Rx_EN = 1;

        reset = 1;
        baud_select_T = 3'b010; // 2
        baud_select_R = 3'b010; // 2

        #1000 reset = 0;

        ///////////////////////
        // FIRST TWO CHARACTERS
        ///////////////////////
        #2000 Tx_DATA = 8'hAA;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #300000;
        ///////////////////
        //2nd TWO CHARACTERS
        ///////////////////
        #2000 Tx_DATA = 8'h55;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #300000;

        /////////////////////
        // 3rd TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'hCC;
        Tx_WR = 1;
        #15 Tx_WR = 0;

        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        #300000;

        /////////////////////
        // 4th TWO CHARACTERS
        /////////////////////
        #2000 Tx_DATA = 8'h89;
        Tx_WR = 1;
        #15 Tx_WR = 0;
        
        repeat(1) @((Tx_BUSY == 0) && (Rx_ready == 1));
        
        #700000;

        $finish;
    end

    always #5 clk = ~clk;

endmodule
