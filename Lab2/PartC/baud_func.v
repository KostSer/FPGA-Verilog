module baud_func (clk, reset, type, baud_select, counter, maximum_cycles, sample_ENABLE);
    input clk, type, reset;
    input [2:0] baud_select;
    input [18:0] counter;
    output reg [18:0] maximum_cycles;
    output reg sample_ENABLE;

    parameter RX = 1'b1,
              TX = 1'b0; 

    always @ (baud_select or type) begin
        case(baud_select)
            3'b000: maximum_cycles = (type == RX)? 19'd20832 : 19'd333332;
            3'b001: maximum_cycles = (type == RX)? 19'd5207 : 19'd83332;
            3'b010: maximum_cycles = (type == RX)? 19'd1301 : 19'd20832;
            3'b011: maximum_cycles = (type == RX)? 19'd652 : 19'd10416;
            3'b100: maximum_cycles = (type == RX)? 19'd325 : 19'd5207;
            3'b101: maximum_cycles = (type == RX)? 19'd162 : 19'd2603;
            3'b110: maximum_cycles = (type == RX)? 19'd108 : 19'd1735;
            3'b111: maximum_cycles = (type == RX)? 19'd53: 19'd867;
        endcase
    end

    always @ (posedge clk) begin
        if(reset) begin
            sample_ENABLE <= 0;
        end
        else begin
            if(sample_ENABLE == 1)
                sample_ENABLE <= 0;
            else if(counter == 0)
                sample_ENABLE <= 1;
        end
    end
endmodule