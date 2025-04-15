`timescale 1ns / 1ps

module alu (
    input [31:0]            SrcA,
    input [31:0]            SrcB,
    input [2:0]             aluop,
    output logic [31:0]     alures,
    output logic            isBranch
    );

	localparam ADD = 3'b010;
    localparam SUB = 3'b110;
    localparam ORI = 3'b001;
    localparam LUI = 3'b000;
    localparam SLT = 3'b111;
    localparam BEQ = 3'b100;
    localparam BNE = 3'b101;

    always_comb begin
        case (aluop)
            ADD: alures = SrcA + SrcB;
            SUB: alures = SrcA - SrcB;
            ORI: alures = SrcA | SrcB;
            LUI: alures = SrcB << 16; // Shift left immediate value
            SLT: alures = ($signed(SrcA) < $signed(SrcB)) ? 32'h00000001 : 32'h00000000; // Set less than

            default: alures = 32'h00000000;
        endcase


        // Set is_equal flag
        case (aluop)
            BEQ: isBranch = (SrcA == SrcB) ? 1'b1 : 1'b0; // Set isBranch for BEQ
            BNE: isBranch = (SrcA != SrcB) ? 1'b1 : 1'b0; // Set isBranch for BNE
            default: isBranch = 1'b0; // Default case
        endcase
        
    end


endmodule
