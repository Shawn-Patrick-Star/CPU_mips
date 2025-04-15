module Npc(
    input logic  [31:0] pc,
    input logic  [1:0]  npc_op,
    input logic  [31:0] imm_extend,
    input logic  [25:0] target,
    input logic         isBranch, 
    output logic [31:0] npc
    );


    logic [31:0] pc_plus4;
    always_comb begin
        pc_plus4 = pc + 4; 
        case (npc_op)
            2'b00: begin // 非跳转指令
                npc = pc_plus4;
            end

            2'b01: begin // 条件跳转指令
                if (isBranch) 
                    npc = pc_plus4 + (imm_extend << 2);
                else
                    npc = pc_plus4;
            end

            2'b10: begin // Jump
                npc = {pc_plus4[31:28], target, 2'b00}; 
            end

            default: npc = pc_plus4;
        endcase
    end



endmodule