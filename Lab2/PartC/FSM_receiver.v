`timescale 1ns/1ps
module FSM_receiver(reset, clk, Rx_sample_ENABLE, Rx_EN, RxD, Rx_DATA, Rx_FERROR, Rx_PERROR, Rx_VALID, ready);
    input clk, reset;
    input Rx_sample_ENABLE;
    input Rx_EN;
    input RxD;

    output reg [7:0] Rx_DATA;
    output reg Rx_FERROR;
    output reg Rx_PERROR;
    output reg Rx_VALID;
    output reg ready;

    wire [7:0] counter;
    wire [2:0] counter_data;
    // RECEIVER STATE
    reg [4:0] CurrState, NextState;
    
    reg start_counter;
    reg data_ready;
    reg [7:0] maximum_cycles;

    parameter IDLE_START = 5'b00000,
              StartBit = 5'b00001,
              Bit1 = 5'b00010,
              Bit2 = 5'b00011,
              Bit3 = 5'b00100,
              Bit4 = 5'b00101,
              Bit5 = 5'b00110,
              Bit6 = 5'b00111,
              Bit7 = 5'b01000,
              Bit8 = 5'b01001,
              ParityBit= 5'b01010,
              StopBit = 5'b01011,
              IDLE_P_ERR = 5'b01100, // "IDLE" FOR PARITY ERROR
              IDLE_F_ERR_1 = 5'b01101, // "IDLE" FOR FRAME ERROR IN START BIT
              IDLE_F_ERR_2 = 5'b01110, // "IDLE" FOR FRAME ERROR IN STOP BIT
              IDLE_VALID = 5'b01111, // "IDLE" AFTER VALID
              OFF = 5'b11111;

    // counts sample_ENABLE for maximum cycles
    counter_signal #(8) sample_ENABLE_counter_signal_inst (.clk(clk),
                                                           .reset(reset || ~start_counter),
                                                           .signal(Rx_sample_ENABLE),
                                                           .Q(counter),
                                                           .MAX_VAL(maximum_cycles)
                                                           );

    // counts data ready 8 times
    counter_signal #(3) data_ready_counter_signal_inst (.clk(clk),
                                                        .reset(reset || ~start_counter),
                                                        .signal(data_ready),
                                                        .Q(counter_data),
                                                        .MAX_VAL(3'b111)
                                                        );

    // sequential always block assigning the NextState to the CurrState of the FSM
    always @(posedge clk) begin
        if(reset)
            CurrState <= OFF; 
        else
            CurrState <= NextState;
    end

    // combinational always block for NextStates-Out of FSM
    always @(Rx_EN or RxD or Rx_DATA or CurrState or Rx_sample_ENABLE or counter) begin
        NextState = CurrState;
        Rx_FERROR = 0;
        Rx_PERROR = 0;
        Rx_VALID = 0;
        ready = 1'b0; // "busy" of Receiver
        start_counter = 1'b1; // starts the counter
        data_ready = 1'b0; // bit is ready to be retrieved
        maximum_cycles = 8'b00001111;

        case (CurrState)
            OFF: begin
                start_counter = 1'b0; // samples counter is off

                if(Rx_EN) begin
                    NextState = IDLE_START;
                end
            end
            IDLE_START: begin
                ready = 1'b1;
                start_counter = 1'b0; // samples counter is off

                if(~Rx_EN) begin 
                    NextState = OFF;
                end
                else if(RxD == 0) begin
                    NextState = StartBit;
                end
            end
            StartBit: begin
                maximum_cycles = 8'b00000111;

                if(counter == 8'b00000111 && Rx_sample_ENABLE) begin // synchronize with the center of the StartBit (8 samples)
                    NextState = Bit1;
                end 
                else if(RxD == 1) begin // FRAME ERROR
                    NextState = IDLE_F_ERR_1;
                end
            end
            Bit1: begin
                
                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = Bit2;
                end
            end
            Bit2: begin
                
                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = Bit3;
                end
            end
            Bit3: begin

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = Bit4;
                end
            end
            Bit4: begin

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = Bit5;
                end
            end
            Bit5: begin

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = Bit6;
                end
            end
            Bit6: begin

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = Bit7;
                end
            end
            Bit7: begin

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = Bit8;
                end
            end
            Bit8: begin

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    data_ready = 1'b1;
                    NextState = ParityBit;
                end
            end
            ParityBit: begin
                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    if(^Rx_DATA == RxD) begin
                        NextState = StopBit;
                    end
                    else begin
                        NextState = IDLE_P_ERR;
                    end
                end
            end
            StopBit: begin
                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    if(RxD == 0) begin
                        NextState = IDLE_F_ERR_2;
                        // maximum cycles are already 16 and samples needed for end of transmission are 16 too, so no change needed
                    end
                    else begin
                        NextState = IDLE_VALID;
                    end
                end
            end
            IDLE_F_ERR_1: begin
                maximum_cycles = 8'd176; // 175 cycles to end transmission
                Rx_FERROR = 1;

                if(counter == 8'd176 && Rx_sample_ENABLE) begin
                    NextState = IDLE_START;
                end
            end
            IDLE_F_ERR_2: begin
                Rx_FERROR = 1;

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    NextState = IDLE_START;
                end
            end
            IDLE_P_ERR: begin
                maximum_cycles = 8'b00011111; // wait 32 cycles
                Rx_PERROR = 1;
                
                if(counter == 8'b00011111 && Rx_sample_ENABLE) begin
                    NextState = IDLE_START;
                end
            end
            IDLE_VALID: begin
                Rx_VALID = 1;

                if(counter == 8'b00001111 && Rx_sample_ENABLE) begin
                    NextState = IDLE_START;
                end
            end
            default: begin
                NextState = IDLE_START;
                Rx_FERROR = 0;
                Rx_PERROR = 0;
                Rx_VALID = 0;
                start_counter = 1'b1;
                maximum_cycles = 8'b00001111;
            end
        endcase
    end

    // handles Rx_DATA based on the counter_Data
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            Rx_DATA = 8'b0;
        end
        else if(data_ready) begin
            case (counter_data)
                3'b000: Rx_DATA[0] = RxD;
                3'b001: Rx_DATA[1] = RxD;
                3'b010: Rx_DATA[2] = RxD; 
                3'b011: Rx_DATA[3] = RxD; 
                3'b100: Rx_DATA[4] = RxD; 
                3'b101: Rx_DATA[5] = RxD; 
                3'b110: Rx_DATA[6] = RxD; 
                3'b111: Rx_DATA[7] = RxD; 
            endcase
        end
    end
endmodule