module HSYNC_FSM(clk, reset, HPIXEL, offDisplay_H, HSYNC);
    input clk, reset;
    output [6:0] HPIXEL;
    output reg HSYNC, offDisplay_H; // signals to show black pixel when off display

    wire [8:0] counter;
    reg [1:0] CurrState, NextState;
    reg [8:0] maximum_cycles;
    
    parameter B_PULSE = 2'b00,
              C_BACKPORCH = 2'b01,
              D_DISPLAYTIME = 2'b10,
              E_FRONTPORCH = 2'b11;

    //counter for horizontal drive
    counter #(9) counter_inst(.clk(clk),
                         .reset(reset),
                         .MAX_VAL(maximum_cycles), // 
                         .Q(counter)
                         );

    // for HPIXEL
    counter_signal #(7, 9) counter_signal_inst(.clk(clk),
                                            .reset(reset),
                                            .en(~offDisplay_H),
                                            .signal(counter),
                                            .signal_max(maximum_cycles),
                                            .MAX_VAL(7'b1111111), // 127
                                            .Q(HPIXEL)
                                            );

    // sequential always block FSM
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            CurrState <= B_PULSE;
        end 
        else begin
            CurrState <= NextState;
        end
    end

    //combinational always block FSM
    always @(CurrState or counter or HPIXEL) begin
        NextState = CurrState;
        offDisplay_H = 1'b1;
        HSYNC = 1'b1;
        maximum_cycles = 9'b101111111; // 384 cycles

        case (CurrState)
            B_PULSE: begin
                HSYNC = 1'b0;

                if(counter == maximum_cycles) NextState = C_BACKPORCH;
            end
            C_BACKPORCH: begin
                maximum_cycles = 9'b010111111; // 192 cycles

                if(counter == maximum_cycles) NextState = D_DISPLAYTIME;
            end
            D_DISPLAYTIME: begin
                offDisplay_H = 1'b0; // valid addresses and enable new counter
                maximum_cycles = 9'b000010011; // per 20 change PIXEL

                if((HPIXEL == 7'b1111111) && (counter == maximum_cycles)) NextState = E_FRONTPORCH;
            end
            E_FRONTPORCH: begin
                maximum_cycles = 9'b000111111; // 64c

                if(counter == maximum_cycles) NextState = B_PULSE;
            end
            default: begin
                NextState = B_PULSE;
                offDisplay_H = 1'b0;
                HSYNC = 1'b1;
                maximum_cycles = 9'b0;
            end
        endcase
    end
endmodule