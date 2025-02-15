module VSYNC_FSM(clk, reset, VPIXEL, offDisplay_V, VSYNC);
    input clk, reset;
    output [6:0] VPIXEL;
    output reg VSYNC, offDisplay_V; // signals to show black pixel when off display

    wire [16:0] counter; // 17 BITS NEEDED FOR 92800c
    reg [1:0] CurrState, NextState;
    reg [16:0] maximum_cycles;
    
    parameter P_PULSE = 2'b00,
              Q_BACKPORCH = 2'b01,
              R_DISPLAYTIME = 2'b10,
              S_FRONTPORCH = 2'b11;

    //counter for horizontal drive
    counter #(17) counter_inst(.clk(clk),
                         .reset(reset),
                         .MAX_VAL(maximum_cycles), // 
                         .Q(counter)
                         );

    // for HPIXEL
    counter_signal #(7, 17) counter_signal_inst(.clk(clk),
                                            .reset(reset),
                                            .en(~offDisplay_V),
                                            .signal(counter),
                                            .signal_max(maximum_cycles),
                                            .MAX_VAL(7'b1011111), // 95
                                            .Q(VPIXEL)
                                            );

    // sequential always block FSM
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            CurrState <= P_PULSE;
        end 
        else begin
            CurrState <= NextState;
        end
    end

    //combinational always block FSM
    always @(CurrState or counter or VPIXEL) begin
        NextState = CurrState;
        offDisplay_V = 1'b1;
        VSYNC = 1'b1;
        maximum_cycles = 17'b00001100011111111; // 64000 cycles

        case (CurrState)
            P_PULSE: begin
                VSYNC = 1'b0;

                if(counter == maximum_cycles) NextState = Q_BACKPORCH;
            end
            Q_BACKPORCH: begin
                maximum_cycles = 17'b10110101001111111; // 92800 cycles

                if(counter == maximum_cycles) NextState = R_DISPLAYTIME;
            end
            R_DISPLAYTIME: begin
                offDisplay_V = 1'b0; // valid addresses and enable new counter
                maximum_cycles = 17'b00011111001111111; // per 16000c change VPIXEL

                if((VPIXEL == 7'b1011111) && (counter == maximum_cycles)) NextState = S_FRONTPORCH;
            end
            S_FRONTPORCH: begin
                maximum_cycles = 17'b00111110011111111; // 32,000c

                if(counter == maximum_cycles) NextState = P_PULSE;
            end
            default: begin
                NextState = P_PULSE;
                offDisplay_V = 1'b0;
                VSYNC = 1'b1;
                maximum_cycles = 17'b0;
            end
        endcase
    end
endmodule