`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/28 22:19:45
// Design Name: 
// Module Name: decoder_tb
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


module decoder_tb();
    wire [31:0] read_data_1, read_data_2, Sign_extend;
    reg [31:0] instruction, mem_data, ALU_Result, opcplus4;
    wire [31:0] r;
    reg jal, RegWrite, MemtoReg, RegDst, clock, rst;

    decode32 decode(
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .Instruction(instruction),
        .mem_data(mem_data),
        .ALU_result(ALU_Result),
        .Jal(jal),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .Sign_extend(Sign_extend),
        .clock(clock),
        .reset(rst),
        .opcplus4(opcplus4),
        .res(r)
    );

    initial begin
        instruction = 32'h00000000;
        jal = 1'b0;
        clock = 1'b0;
        RegWrite = 1'b0;
        MemtoReg = 1'b0;
        RegDst = 1'b0;
        rst = 1'b1;
        instruction = 32'h00000000;
        ALU_Result = 32'h00000001;
        opcplus4 = 32'h00000000;
        mem_data = 32'h00000000;
        RegWrite = 1'b1;

       
        #10 rst = 1'b0;
        #10 instruction = 32'h24020001;
        
        ALU_Result = 32'h00000000;
        
       
        #20 instruction = 32'h3c010000;
        
        
        #20 instruction = 32'hac220000;
        RegWrite = 1'b0;

        
        #20 
        instruction = 32'h00000000;

    end

    always #5 clock = ~clock;
endmodule
