`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/10 11:37:17
// Design Name: 
// Module Name: rca
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


module rca #(parameter N = 4) (
    input logic [N-1:0]     A,
    input logic [N-1:0]     B,
    input logic             Cin,
    output logic [N-1:0]    S,
    output logic            Cout
    );

    logic [N:0] carry;
    assign carry[0] = Cin;    // 最低位进位输入来自模块输入Cin
    assign Cout = carry[N];   // 最高位进位输出到模块输出Cout

    // 生成N个全加器实例
    generate
        genvar i;
        for (i = 0; i < N; i = i + 1) begin : gen_rca
            fulladder fa_inst (
                .A(A[i]),           // 当前位A输入
                .B(B[i]),           // 当前位B输入
                .Cin(carry[i]),     // 来自前一位的进位输入
                .S(S[i]),           // 当前位和输出
                .Cout(carry[i+1])   // 传递给下一位的进位输出
            );
        end
    endgenerate


endmodule
