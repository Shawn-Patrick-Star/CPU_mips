`timescale 1ns / 1ps

module RegFile (
    input logic         sys_clk,
    input logic         sys_rst_n,

    input logic [4:0]   ra1,    // 32 registers
    input logic [4:0]   ra2,
    input logic [4:0]   wa3,
    input logic         we3,
    input logic [31:0]  wd3,
    output logic [31:0] rd1,
    output logic [31:0] rd2

    );
    
    logic [31:0] regs [31:0];
    
    always_ff @(posedge sys_clk) begin
        if(~sys_rst_n) begin
            for(int i=0; i<32; i=i+1) begin
                regs[i] <= 32'h00000000;
            end
        end
        else if (we3) begin
            regs[wa3] <= wd3;
        end
    end

    always_comb begin
        rd1 = regs[ra1];
        rd2 = regs[ra2];
    end



endmodule