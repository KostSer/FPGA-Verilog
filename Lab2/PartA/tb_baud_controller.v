module tb_baud_controller;
    reg reset, clk, enable, type;
    reg [2:0] baud_select;
    wire sample_ENABLE;
    integer i;

    baud_controller baud_controller_inst(.clk(clk),
                                         .reset(reset),
                                         .baud_select(baud_select),
                                         .sample_ENABLE(sample_ENABLE),
                                         .enable(enable),
                                         .type(type)
                                         );

    initial begin
        clk = 0;
        reset = 1;
        enable = 1;
        type = 1;

        for(i = 0; i < 2; i = i + 1) begin
            #103 reset = 0;

            baud_select = 3'b111;
            
            reset = 1;
            #100 reset = 0;
            repeat (3) @(sample_ENABLE == 1);

            baud_select = 3'b110;
            
            reset = 1;
            #100 reset = 0;
            repeat (3) @(sample_ENABLE == 1);

            baud_select = 3'b101;
            
            enable = 0; // SWITCH OFF

            baud_select = 3'b101;
            
            #15000;

            baud_select = 3'b100;
            #30000;

            baud_select = 3'b011;
            #60000;

            enable = 1; //SWITCH BACK ON

            baud_select = 3'b101;
            reset = 1;
            #100 reset = 0;

            repeat (3) @(sample_ENABLE == 1);
            /////////////////

            baud_select = 3'b100;        
            reset = 1;
            #100 reset = 0;
            
            repeat (3) @(sample_ENABLE == 1);

            /////////////////

            baud_select = 3'b011;
            
            reset = 1;
            #100 reset = 0;
            repeat (3) @(sample_ENABLE == 1);

            //////////////////////
            baud_select = 3'b010;
            
            reset = 1;
            #100 reset = 0;
            repeat (3) @(sample_ENABLE == 1);

            //////////////////////
            baud_select = 3'b001;
            
            reset = 1;
            #100 reset = 0;
            repeat (3) @(sample_ENABLE == 1);

            //////////////////////

            baud_select = 3'b000;
            
            reset = 1;
            #100 reset = 0;
            repeat (3) @(sample_ENABLE == 1);

            type = 0;
        end

        #100 $finish;
    end

    always #5 clk = ~clk;
endmodule