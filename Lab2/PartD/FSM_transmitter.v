module FSM_transmitter(clk, reset, Tx_DATA, Tx_sample_ENABLE, Tx_WR, Tx_EN, TxD, Tx_BUSY, GotData);
    input clk, reset;
    input [7:0] Tx_DATA;
    input Tx_sample_ENABLE;
    input Tx_WR;
    input Tx_EN;

    output reg TxD;
    output reg Tx_BUSY;
    output reg GotData;

    // TRANSMITTER STATE
    reg [3:0] CurrState, NextState;

    parameter IDLE = 4'b0000,
              StartBit = 4'b0001,
              Bit1 = 4'b0010,
              Bit2 = 4'b0011,
              Bit3 = 4'b0100,
              Bit4 = 4'b0101,
              Bit5 = 4'b0110,
              Bit6 = 4'b0111,
              Bit7 = 4'b1000,
              Bit8 = 4'b1001,
              ParityBit= 4'b1010,
              StopBit = 4'b1011,
              OFF = 4'b1111;

    always @(posedge clk) begin
        if(reset)
            CurrState <= OFF; 
        else
            CurrState <= NextState;
    end

    always @(Tx_WR or Tx_DATA or Tx_EN or CurrState or Tx_sample_ENABLE) begin
        NextState = CurrState;
        Tx_BUSY = 1'b1;
        GotData = 1'b1;
        TxD = 1'b0;

        case (CurrState)
            OFF: begin
                GotData = 1'b0;
                Tx_BUSY = 0;
                if(Tx_EN) begin
                    NextState = IDLE;
                end
            end
            IDLE: begin
                Tx_BUSY = 1'b0;
                GotData = 1'b0;
                TxD = 1'b1;

                if(Tx_EN == 0) begin
                    NextState = OFF;
                end
                else begin
                    if(Tx_WR) begin
                        NextState = StartBit;
                    end 
                end
            end
            StartBit: begin
                TxD = 1'b0; // START BIT

                if(Tx_sample_ENABLE) begin
                    NextState = Bit1;
                end
            end
            Bit1: begin
                TxD = Tx_DATA[0]; // BIT 1

                if(Tx_sample_ENABLE) begin
                    NextState = Bit2;
                end
            end
            Bit2: begin
                TxD = Tx_DATA[1]; // BIT 2

                if(Tx_sample_ENABLE) begin
                    NextState = Bit3;
                end
            end
            Bit3: begin
                TxD = Tx_DATA[2]; // BIT 3

                if(Tx_sample_ENABLE) begin
                    NextState = Bit4;
                end
            end
            Bit4: begin
                TxD = Tx_DATA[3]; // BIT 4

                if(Tx_sample_ENABLE) begin
                    NextState = Bit5;
                end
            end
            Bit5: begin
                TxD = Tx_DATA[4]; // BIT 5

                if(Tx_sample_ENABLE) begin
                    NextState = Bit6;
                end
            end
            Bit6: begin
                TxD = Tx_DATA[5]; // BIT 6

                if(Tx_sample_ENABLE) begin
                    NextState = Bit7;
                end
            end
            Bit7: begin
                TxD = Tx_DATA[6]; // BIT 7

                if(Tx_sample_ENABLE) begin
                    NextState = Bit8;
                end
            end
            Bit8: begin
                TxD = Tx_DATA[7]; // BIT 8

                if(Tx_sample_ENABLE) begin
                    NextState = ParityBit;
                end
            end
            ParityBit: begin    
                TxD = ^Tx_DATA; // xor of all 8 bits || 0: even 1: odd

                if(Tx_sample_ENABLE) begin
                    NextState = StopBit;
                end
            end
            StopBit: begin
                TxD = 1'b1; // STOP BIT
                
                if(Tx_sample_ENABLE) begin
                    NextState = IDLE;
                end
            end
            default: begin
                NextState = IDLE;
                TxD = 1'bx;
            end
        endcase
    end
endmodule