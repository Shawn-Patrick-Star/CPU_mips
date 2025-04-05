module cpu(
    input  logic sys_clk,
    input  logic sys_rst_n,
    input  logic [31:0] instr,      // 指令 from inst_rom
    input  logic [31:0] dout,       // 数据 from data_ram

    output logic [31:0] iaddr,      // 指令地址 to inst_rom
    output logic [31:0] daddr,      // 数据地址 to data_ram
    output logic MemWrite,
    output logic [31:0] din         // 数据 to data_ram
);


// control signals
logic MemtoReg;     // √
logic Branch;       // √
logic [2:0] ALUOp;  // √
logic ALUSrc;       // √
logic RegDst;       // √
logic RegWrite;     // √

// regfile signals
logic [5:0] opcode;
logic [4:0] rs;
logic [4:0] rt;
logic [4:0] rd;
logic [15:0] imm;
logic [5:0] funct;
assign opcode = instr[31:26]; 
assign rs = instr[25:21]; 
assign rt = instr[20:16]; 
assign rd = instr[15:11];
assign imm = instr[15:0]; 
assign funct = instr[5:0];

// regfile signals
logic [31:0] rd1;
logic [31:0] rd2;
logic [4:0] wa3;
logic [31:0] wd3;


// alu signals
logic [31:0] imm_extend;
logic [31:0] SrcB;
logic [31:0] aluRes;
logic zero;

// pc signals
logic pcSrc;
logic [31:0] pc;
logic [31:0] next_pc;
logic [31:0] pc_plus4;



assign pcSrc = Branch & zero; // 1'b0 or 1'b1
assign iaddr = pc; 
assign pc_plus4 = pc + 4; // pc+4
assign next_pc = pcSrc ? (pc_plus4 + (imm_extend << 2)) : pc_plus4;
PC prgramCounter(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .next_pc(next_pc),
    .pc(pc)
);

controlUnit controlUnit (
    .opcode(opcode), 
    .funct(funct),

    .MemtoReg(MemtoReg),    
    .MemWrite(MemWrite),   
    .Branch(Branch),    
    .ALUOp(ALUOp), 
    .ALUSrc(ALUSrc),     
    .RegDst(RegDst),     
    .RegWrite(RegWrite)   
);


assign din = rd2; 
assign wa3 = RegDst ? rd : rt; 
assign wd3 = MemtoReg ? dout : aluRes;
RegFile regFile (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .ra1(rs),                   // rs
    .ra2(rt),                   // rt
    .wa3(wa3),                  // rt or rd
    .we3(RegWrite),            
    .wd3(wd3),                  // aluRes or dout

    .rd1(rd1),
    .rd2(rd2)
);


// imm sign extend
signExtend signExtend (
    .imm(imm),  
    .imm_ext(imm_extend)
);

// alu
assign SrcB = ALUSrc ? imm_extend : rd2;
assign daddr = aluRes;
alu alu (
    .SrcA(rd1),
    .SrcB(SrcB),                // rd2 or imm_extend
    .aluop(ALUOp),

    .alures(aluRes),
    .zero(zero)
);



endmodule
