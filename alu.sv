`timescale 1ns / 1ps

module alu (
    input [31:0]            SrcA,
    input [31:0]            SrcB,
    input [2:0]             aluop,
    output logic [31:0]     alures
    );

	localparam	ADD   =	3'b010;

    always_comb begin
        case (aluop)
            ADD: alures = SrcA + SrcB;
            default: alures = 32'h00000000;
        endcase
        
    end


endmodule
