`timescale 1ns / 1ps

module alu (
    input [31:0]            SrcA,
    input [31:0]            SrcB,
    input [2:0]             aluop,
    output logic [31:0]     alures,
    output logic            zero
    );

	localparam ADD = 3'b010;
    localparam SUB = 3'b110;
    localparam ORI = 3'b001;
    localparam LUI = 3'b000;
    localparam SLT = 3'b111;

    always_comb begin
        case (aluop)
            ADD: alures = SrcA + SrcB;
            SUB: alures = SrcA - SrcB;
            ORI: alures = SrcA | SrcB;
            LUI: alures = SrcB << 16; // Shift left immediate value
            SLT: alures = (SrcA < SrcB) ? 32'h00000001 : 32'h00000000; // Set less than
            default: alures = 32'h00000000;
        endcase


        // Set zero flag
        if (alures == 32'h00000000) zero = 1'b1; 
        else                        zero = 1'b0; 
        
    end


endmodule
