`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/28 21:27:05
// Design Name: 
// Module Name: ifetch_tb
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


module ifetch_tb();
wire [31:0] Instruction;
wire [31:0] branch_base_addr;
wire [31:0] link_addr;
reg [31:0] addr_res, read_data_1;
reg clock, reset, zero, branch, nbranch, jmp, jal, jr;
reg upg_rst_i, upg_clk_i, upg_wen_i, upg_done_i;
reg [13:0] upg_adr_i;
reg [31:0] upg_dat_i;

Ifetc32 ifetch_tb(
    .Instruction(Instruction),
    .branch_base_addr(branch_base_addr),
    .link_addr(link_addr),
    .clock(clock),
    .reset(reset),
    .Addr_result(addr_res),
    .Zero(zero),
    .Read_data_1(read_data_1),
    .Branch(branch),
    .nBranch(nbranch),
    .Jmp(jmp),
    .Jal(jal),
    .Jr(jr),
    .upg_rst_i(upg_rst_i),
    .upg_clk_i(upg_clk_i),
    .upg_wen_i(upg_wen_i),
    .upg_adr_i(upg_adr_i),
    .upg_dat_i(upg_dat_i),
    .upg_done_i(upg_done_i)
);

initial begin
    clock = 1'b0;
    reset = 1'b1;
    zero = 1'b0;
    branch = 1'b0;
    nbranch = 1'b0;
    jmp = 1'b0;
    jal = 1'b0;
    jr = 1'b0;
    addr_res = 32'h00000000;
    read_data_1 = 32'h00000000;
    #20 reset = 1'b0;
end

always #5 clock = ~clock;

endmodule
