`timescale 1ns / 1ps

module signExtend(
    input logic [15:0] imm,
    output logic [31:0] imm_ext
    );
    
    assign imm_ext = {{16{imm[15]}}, imm};

endmodule