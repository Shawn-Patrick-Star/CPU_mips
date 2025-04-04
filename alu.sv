`timescale 1ns / 1ps

module alu (
    input [31:0]            SrcA,
    input [31:0]            SrcB,
    input [2:0]             aluop,
    output logic [31:0]     alures
    );

	localparam ADD = 3'b010;
    localparam ORI = 3'b001;
    localparam LUI = 3'b000;

    always_comb begin
        case (aluop)
            ADD: alures = SrcA + SrcB;
            ORI: alures = SrcA | SrcB;
            LUI: alures = SrcB << 16; // Shift left immediate value
            default: alures = 32'h00000000;
        endcase
        
    end


endmodule
