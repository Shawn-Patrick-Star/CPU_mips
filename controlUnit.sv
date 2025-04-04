module controlUnit(
    input logic [5:0] opcode, // Opcode from instruction
    input logic [5:0] funct,  // Function code from instruction

    output logic MemtoReg,    // 回写的数据来自于 ALU计算结果(0) or 存储器读取结果(1)
    output logic MemWrite,    // 是否需要写 data memory
    output logic Branch,      // 是否需要分支跳转
    output logic [2:0] ALUOp, 
    output logic ALUSrc,      // ALUSrcB来自于立即数32位扩展(1) or 寄存器(0)
    output logic RegDst,      // 寄存器写入地址来自于 rt(0) or rd(1)
    output logic RegWrite     // 是否需要写 RegFiles
    );

    // Control unit logic
    always_comb begin
        // Default values
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        ALUOp = 3'b000; 
        ALUSrc = 1'b0;
        RegDst = 1'b0;
        RegWrite = 1'b0;

        case (opcode)
            6'b000000: begin // R-type instructions
                RegDst = 1'b1; // Write to rd
                RegWrite = 1'b1; // Enable register write
                case (funct)
                    6'b100000: ALUOp = 3'b010; // ADD
                    6'b100010: ALUOp = 3'b110; // SUB
                    6'b100100: ALUOp = 3'b001; // AND
                    6'b100101: ALUOp = 3'b001; // OR 
                    default:   ALUOp = 3'b000; // Default case for unsupported funct 
                endcase
            end

            6'b100011: begin // LW 
                MemtoReg = 1'b1; 
                RegWrite = 1'b1; 
                ALUSrc = 1'b1;   
                ALUOp = 3'b010;
            end

            6'b101011: begin // SW 
                MemWrite = 1'b1; 
                ALUSrc = 1'b1;   
                ALUOp = 3'b010;
            end

            default: begin // Default case for unsupported opcodes
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOp = 3'b000;
                ALUSrc = 1'b0;
                RegDst = 1'b0;
                RegWrite = 1'b0;
            end
        endcase

    end

    


endmodule