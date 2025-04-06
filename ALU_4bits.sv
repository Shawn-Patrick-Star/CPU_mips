module ALU_4bits(
        input sys_clk,
        input sys_rst_n,
        input [3 : 0] A,
        input [3 : 0] B,
        input [3 : 0] aluop,
        output ov,
        output zero,
        output logic    [3 : 0]  an,
        output logic    [7 : 0]  a_to_g
    );
    
    logic [3 : 0] alures0, alures1;

    alu #(.N(4)) ALU(
        .A(A),
        .B(B),
        .aluop(aluop),
        .alures0(alures0),
        .alures1(alures1),
        .zero(zero),
        .ov(ov)
    );

    x7seg_d U1(
    .sys_clk    (sys_clk),
    .sys_rst_n  (sys_rst_n),
    .Y0         (alures0),
    .Y1         (alures1),
    .an         (an),
    .a_to_g     (a_to_g)
    );  
    
endmodule