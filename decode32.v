`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 22:09:22
// Design Name: 
// Module Name: decode32
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

module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
    output[31:0] read_data_1;               // ����ĵ�һ������?
    output[31:0] read_data_2;               // ����ĵڶ�������?
    input[31:0]  Instruction;               // ȡָ��Ԫ����ָ��
    input[31:0]  mem_data;   				//  ��DATA RAM or I/O portȡ��������
    input[31:0]  ALU_result;   				// ��ִ�е�Ԫ��������Ľ��
    input        Jal;                       //  ���Կ��Ƶ�Ԫ��˵����JALָ�� 
    input        RegWrite;                  // ���Կ��Ƶ�Ԫ
    input        MemtoReg;              // ���Կ��Ƶ�Ԫ
    input        RegDst;             
    output[31:0] Sign_extend;               // ��չ���?32λ������
    input		 clock,reset;                // ʱ�Ӻ͸�λ
    input[31:0]  opcplus4;                 // ����ȡָ��Ԫ��JAL����

    reg[31:0] r[0:31];
    reg[4:0]  wreg=0;
    reg[31:0] wdata=0;
    
    wire[4:0] rreg_1;       //ins[25:21]
    wire[4:0] rreg_2;       //ins[20:16]
    wire[4:0] wreg_I;       //ins[20:16]
    wire[4:0] wreg_R;       //ins[15:11]
    wire[15:0] imm;         //ins[15:0]
    wire[5:0] opcode;       //ins[31:26]
    wire sign;              //ins[15]       
    assign rreg_1=Instruction[25:21];
    assign rreg_2=Instruction[20:16];
    assign wreg_I=Instruction[20:16];
    assign wreg_R=Instruction[15:11];
    assign imm=Instruction[15:0];
    assign sign=Instruction[15];
    assign opcode=Instruction[31:26];
    
    wire [15:0]sign_ex_16;
    assign sign_ex_16=sign ? 16'b1111111111111111:16'b0000000000000000;
    assign Sign_extend = (12 == opcode || 13 == opcode||opcode==14||opcode==11||opcode==9)?{16'b0000000000000000,imm}:{sign_ex_16,imm};
    assign read_data_1 = r[rreg_1];
    assign read_data_2 = r[rreg_2];
    
    integer i;
    initial begin
        for (i=0;i<32;i=i+1)r[i] <= 0;
    end
    always @(posedge clock or posedge reset)begin
        if (reset==1)begin
            for (i=0;i<32;i=i+1)r[i] <= 0;
        end
        else if (RegWrite)begin
            r[wreg]<=wdata;
        end
    end
    always @* begin
        if ((opcode==3)&&Jal)begin
            wdata=opcplus4;
        end
        else if(~MemtoReg)begin
            wdata=ALU_result;
        end
        else begin
            wdata = mem_data;
        end
    end
    always @* begin
        if(RegWrite)
            wreg = Jal ? 5'b11111:(RegDst ? wreg_R : wreg_I);
    end
endmodule