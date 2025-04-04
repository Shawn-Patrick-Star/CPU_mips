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

logic [31:0] imm_extend;
logic [31:0] rd1;


// pc
PC prgramCounter(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .next_pc(),
    .pc(iaddr)
);

logic [5:0] opcode;
logic [4:0] rs;
logic [4:0] rt;
logic [15:0] imm;
logic [5:0] funct;
assign opcode = instr[31:26]; 
assign rs = instr[25:21]; 
assign rt = instr[20:16]; 
assign imm = instr[15:0]; 
assign funct = instr[5:0];


logic MemtoReg;    
logic Branch;      
logic [2:0] ALUOp;
logic ALUSrc;      
logic RegDst;      
logic RegWrite;     

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

// register file
RegFile regFile (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .ra1(rs),     // rs
    .ra2(rt),     // rt
    .wa3(rt),     // rt
    .we3(RegWrite),         // write enable
    .wd3(dout),

    .rd1(rd1),
    .rd2(din)
);


// imm sign extend
signExtend signExtend (
    .imm(imm),  
    .imm_ext(imm_extend)
);

// alu
alu alu (
    .SrcA(rd1),
    .SrcB(imm_extend),
    .aluop(ALUOp), // ADD
    .alures(daddr)
);



endmodule
