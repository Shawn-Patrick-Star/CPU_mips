`timescale 1ns / 1ps

module PC(
    input logic sys_clk,
    input logic sys_rst_n,
    input logic [31:0] next_pc,
    output logic [31:0] pc
    );
    
    always_ff @(posedge sys_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            pc <= 32'h00000000;
        else
            pc <= next_pc;
    end

    
endmodule
