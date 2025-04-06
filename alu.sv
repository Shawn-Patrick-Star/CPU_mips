`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/10 11:39:49
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    input [3:0] aluop,
    output logic [N-1:0] alures0,     // 非乘法运算结果 || 乘法运算结果的低位
    output logic [N-1:0] alures1,     // 乘法运算结果的高位
    output logic zero,
    output logic ov
    );

	localparam	AND   =	4'b0000;
	localparam	OR    =	4'b0001;
	localparam	XOR   =	4'b0010;
	localparam	NAND  =	4'b0011;
	localparam	NOT   =	4'b0100;
	localparam	SLL   =	4'b0101;
	localparam	SRL   =	4'b0110;
	localparam	SRA   =	4'b0111;
	localparam	MULU  =	4'b1000;
	localparam	MUL   =	4'b1001;
	localparam	ADD   =	4'b1010;
	localparam  ADDU  = 4'b1011;
	localparam  SUB   = 4'b1100;
	localparam  SUBU  = 4'b1101;
	localparam  SLT   = 4'b1110;
	localparam  SLTU  = 4'b1111;

    logic [N-1:0] and_res;    // AND运算结果
    logic [N-1:0] or_res;     // OR运算结果
    logic [N-1:0] xor_res;    // XOR运算结果
    logic [N-1:0] nand_res;   // NAND运算结果
    logic [N-1:0] not_res;    // NOT运算结果
    logic [N-1:0] sll_res;    // SLL运算结果
    logic [N-1:0] srl_res;    // SRL运算结果
    logic [N-1:0] sra_res;    // SRA运算结果
    logic [2*N-1:0] product;    // MULU MUL运算结果
    logic [N-1:0] S;          // ADD ADDU SUB SUBU运算结果
    logic [N-1:0] slt_res;    // SLT运算结果
    logic [N-1:0] sltu_res;   // SLTU运算结果

    assign and_res = A & B;
    assign or_res = A | B;
    assign xor_res = A ^ B;
    assign nand_res = ~(A & B);
    assign not_res = ~A;
    assign sll_res = A << B[2:0];
    assign srl_res = A >> B[2:0];
    assign sra_res = $signed(A) >>> B[2:0];


    // 加减法
    logic [N-1:0] B_tmp;
    logic Cout;
    assign B_tmp = (aluop[2] == 1) ? ~B+1 : B;
    rca #(.N(N)) rca4 (.A(A), .B(B_tmp), .Cin(1'b0), .S(S), .Cout(Cout));

    // 乘法
    logic [N-1:0] A_mul;
    logic [N-1:0] B_mul;
    logic [2*N-1:0] res_tmp;
    assign A_mul = aluop[0] ? (A[N-1] ? ~A+1 : A) : A;
    assign B_mul = aluop[0] ? (B[N-1] ? ~B+1 : B) : B;
    assign res_tmp = A_mul * B_mul;
    assign product = (aluop[0] && A[N-1]^B[N-1]) ?  ~res_tmp+1 : res_tmp;


    assign slt_res = $signed(A) < $signed(B) ? 1 : 0;
    assign sltu_res = (A < B) ? 1 : 0;

    always_comb begin
        {alures1, alures0} = {2*N{1'b0}};
        
        case (aluop)
            AND :                   alures0 = and_res;
            OR  :                   alures0 = or_res;
            XOR :                   alures0 = xor_res;
            NAND:                   alures0 = nand_res;
            NOT :                   alures0 = not_res; 
            SLL :                   alures0 = sll_res;
            SRL :                   alures0 = srl_res;
            SRA :                   alures0 = sra_res;
            MULU, MUL :             alures0 = product;
            ADD, ADDU, SUB, SUBU:   alures0 = S;
            SLT :                   alures0 = slt_res;
            SLTU:                   alures0 = sltu_res;
        endcase
        
        // zero
        zero = ({alures1, alures0} == 0);

        // overflow
        case (aluop)
            ADD, SUB: ov = (A[N-1] == B_tmp[N-1]) && (A[N-1] != S[N-1]);
            default: ov = 0;
        endcase

    end



endmodule
