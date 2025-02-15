`timescale 1ns/1ps
module synchronizer_2FF(sig, clk, sig_sync, sig_prime);
    input sig, clk;
    output sig_prime, sig_sync;
    reg sig_prime, sig_sync;

    always @(posedge clk) begin
        sig_prime <= sig;
        sig_sync <= sig_prime;
    end
    
endmodule