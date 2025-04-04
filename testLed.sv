module testLed(
    input logic sys_clk,
    input logic sys_rst_n,
    input logic [31:0] din,
    input logic [31:0] daddr,
    output logic led_r,
    output logic led_g
);
    
    // 0x80000000对应的地址是0x80040000，0x10000000开始的地址是0x10000000
    // assign we_dram = (daddr[31] == 1'b1) ? 1'b0 : we;
    logic led_r_reg, led_g_reg;
    always_ff @(posedge sys_clk) begin
        if (!sys_rst_n) {led_r_reg, led_g_reg} <= 2'b00;
        else if (daddr[31:16] == 16'h8000) {led_r_reg, led_g_reg} <= {din[24], led_g_reg};
        else if (daddr[31:16] == 16'h8004) {led_r_reg, led_g_reg} <= {led_r_reg, din[24]};
        else {led_r_reg, led_g_reg} <= {led_r_reg, led_g_reg};
    end
    assign led_r = led_r_reg;
    assign led_g = led_g_reg;

endmodule