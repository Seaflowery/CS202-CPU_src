`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/11 10:27:08
// Design Name: 
// Module Name: control32
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


module control32(Opcode,addr,Function_opcode,Jr,RegDST,ALUSrc,MemtoReg,RegWrite,
                    MemWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd,ALUOp,IOwrite,IOread,Memread);
    input[5:0]   Opcode;            // ????IFetch????????6bit??instruction[31..26]
    input[1:0]   addr;
    input[5:0]   Function_opcode;  	// ????IFetch????????6bit??????????r-?????е????instructions[5..0]
    output       Jr;         	 // ?1????????????jr???0???????????jr
    output       RegDST;          // ?1?????????????rd???????????????rt
    output       ALUSrc;          // ?1?????????????????ALU?е?Binput????????????beq??bne???????0???????????????????????
    output       MemtoReg;     // ?1?????????�?????I/O????????????
    output       RegWrite;   	  //  ?1????????????д?????
    output       MemWrite;       //  ?1????????????д?�???
    output       Branch;        //  ?1??????beq????0????????beq???
    output       nBranch;       //  ?1??????Bne????0????????bne???
    output       Jmp;            //  ?1??????J????0????????J???
    output       Jal;            //  ?1??????Jal????0????????Jal???
    output       I_format;      //  ?1????????????beq??bne??LW??SW????????I-???????
    output       Sftmd;         //  ?1????????λ????0??????????λ???
    output[1:0]  ALUOp;        //  ??R-?????I_format=1?λ1????bitλ???1, beq??bne?????λ0????bitλ???1
    output       IOwrite;
    output       IOread;
    output       Memread;
    wire R;
    wire I;

    assign R=(Opcode==0);
    assign I=~(R||Jal||Jmp);
    assign MemtoReg = (Opcode==35);    
    assign MemWrite= (Opcode==43)&&(addr==2'b11);
    assign Branch=(Opcode==4);
    assign nBranch=(Opcode==5);
    assign Jmp = (Opcode == 2);
    assign Jal = (Opcode == 3);
    assign Sftmd=(Opcode==0)&&(Function_opcode<=7);
    assign Jr = (Opcode==0 && Function_opcode==8);
    
    assign RegWrite=(R||I_format||MemtoReg||Jal)&&(~(Jr||nBranch||Branch||Jmp));//sw beq  bne
    assign RegDST = R;
    assign ALUSrc = I&&(~(Branch ||nBranch));
    assign I_format=(I)&&(Opcode != 4)&&(Opcode!=5)&&(Opcode!=35)&&(Opcode!=43);
    
    assign ALUOp[1] = (R||I_format);
    assign ALUOp[0] = (Branch ||nBranch);
    //sw 43   lw:25
    assign IOwrite=(Opcode==43)&&(addr==2'b00);//sw&&qianliangweishi0
    assign IOread=(Opcode==35)&&(addr==2'b00);
    assign Memread=(Opcode==35)&&(addr==2'b11);


endmodule
