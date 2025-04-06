module top(
    input logic sys_clk,
    input logic sys_rst_n,
    output logic led_r,
    output logic led_g
    );
    
    logic [31:0] iaddr;
    logic [31:0] daddr;
    logic MemWrite;
    logic [31:0] instr_little, instr_big;
    logic [31:0] din_little, din_big;
    logic [31:0] dout_little, dout_big;
    assign instr_big = {instr_little[7:0], instr_little[15:8], instr_little[23:16], instr_little[31:24]};
    assign din_little = {din_big[7:0], din_big[15:8], din_big[23:16], din_big[31:24]};
    assign dout_big = {dout_little[7:0], dout_little[15:8], dout_little[23:16], dout_little[31:24]};
    

    testLed testLed(
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .din(din_little),
        .daddr(daddr),
        .led_r(led_r),
        .led_g(led_g)
    );


    cpu cpu (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .instr(instr_big),      // 指令 from inst_rom
        .dout(dout_big),       // 数据 from data_ram

        .iaddr(iaddr),      // 指令地址 to inst_rom
        .daddr(daddr),      // 数据地址 to data_ram
        .MemWrite(MemWrite),      // 是否需要写 data memory
        .din(din_big)         // 数据 to data_ram
    );

    inst_rom inst_rom (
        .a(iaddr[9:2]),      // input wire [9 : 2] a
        .spo(instr_little)  // output wire [31 : 0] spo
    );
    
    data_ram data_ram (
        .a(daddr[9:2]),      // input wire [9 : 2] a
        .d(din_little),      // input wire [31 : 0] d
        .clk(sys_clk),  // input wire clk
        .we(MemWrite),    // input wire we
        .spo(dout_little)  // output wire [31 : 0] spo
    );
endmodule