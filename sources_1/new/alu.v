`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 10:29:39
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


module executs32(Read_data_1,Read_data_2,Sign_extend,Function_opcode,Exe_opcode,ALUOp,
                 Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4
                 );
    input[31:0]  Read_data_1;		// �����뵥Ԫ��Read_data_1����
    input[31:0]  Read_data_2;		// �����뵥Ԫ��Read_data_2����
    input[31:0]  Sign_extend;		// �����뵥Ԫ������չ���������???
    
    input[5:0]   Function_opcode;  	// ȡָ��Ԫ����r-����ָ�����,r-form instructions[5:0]
    input[5:0]   Exe_opcode;  		// ȡָ��Ԫ���Ĳ�����
    input[1:0]   ALUOp;             // ���Կ��Ƶ�Ԫ������ָ����Ʊ���???
    input[4:0]   Shamt;             // ����ȡָ��Ԫ��instruction[10:6]��ָ����λ����
    input  		 Sftmd;            // ���Կ��Ƶ�Ԫ�ģ���������λָ��
    input        ALUSrc;            // ���Կ��Ƶ�Ԫ�������ڶ�������������������beq��bne���⣩
    input        I_format;          // ���Կ��Ƶ�Ԫ�������ǳ�beq, bne, LW, SW֮���I-����ָ��
    input        Jr;               // ���Կ��Ƶ�Ԫ��������JRָ��
    output       Zero;              // Ϊ1��������ֵΪ0 
    output[31:0] ALU_Result;        // ��������ݽ��
    output[31:0] Addr_Result;		// ����ĵ�ַ���        
    input[31:0]  PC_plus_4;         // ����ȡָ��Ԫ��PC+4
 
    //assign Addr_Result = Jr? (Read_data_1<<2): (PC_plus_4 + (Sign_extend<<2));
    assign Addr_Result = (PC_plus_4+(Sign_extend<<2));
    wire[31:0] Ainput,Binput; // two operands for calculation
    wire[5:0] Exe_code; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
    wire[2:0] ALU_ctl; // the control signals which affact operation in ALU directely
    wire[2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
    reg[31:0] Shift_Result; // the result of shift operation
    reg[31:0] ALU_output_mux; // the result of arithmetic or logic calculation
    wire[32:0] Branch_Addr; // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]
    
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];
    assign Exe_code = (I_format == 0)? Function_opcode : { 3'b000, Exe_opcode[2:0]};
    assign ALU_ctl[0] = ((Exe_code[0] | Exe_code[3]) & ALUOp[1]);
    assign ALU_ctl[1] = ((~Exe_code[2]) | (~ALUOp[1]));
    assign ALU_ctl[2] = ((Exe_code[1] & ALUOp[1]) | ALUOp[0]);
    
    reg[31:0] ALU_output;
    assign ALU_Result = ALU_output;
    always @*
    begin
        case(ALU_ctl)
        3'b000: ALU_output_mux = (Ainput & Binput);
        3'b001: ALU_output_mux = (Ainput | Binput);
        3'b010: ALU_output_mux = (Ainput + Binput);
        3'b011: ALU_output_mux = (Ainput + Binput);
        3'b100: ALU_output_mux = (Ainput ^ Binput);
        3'b101: ALU_output_mux = ~(Ainput | Binput);
        3'b110: ALU_output_mux = (Ainput +(~Binput+1));
        3'b111: ALU_output_mux = (Ainput - Binput);
        default: ALU_output_mux = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        endcase
    end
    
    assign Sftm = Function_opcode[2:0];
    wire [15:0] sra;
    assign sra = (Binput[15:15]==1'b1)?16'b1111111111111111:16'b0;
    always @* begin // six types of shift instructions
        if(Sftmd)
            case(Sftm[2:0])
            3'b000:Shift_Result = (Binput << Shamt); //Sll rd,rt,shamt 00000
            3'b010:Shift_Result = (Binput >> Shamt); //Srl rd,rt,shamt 00010
            3'b100:Shift_Result = (Binput << Ainput); //Sllv rd,rt,rs 000100
            3'b110:Shift_Result = (Binput >> Ainput); //Srlv rd,rt,rs 000110
            //3'b011:Shift_Result = Binput[31] ? ((((1<<Shamt)-1)<<(32-Shamt)) | (Binput>>Shamt)):(Binput>>Shamt); //Sra rd,rt,shamt 00011
            //3'b111:Shift_Result = Binput[31] ? ((((1<<Ainput)-1)<<(32-Ainput)) | (Binput>>Ainput)):(Binput>>Ainput); //Srav rd,rt,rs 00111
            3'b011: Shift_Result = $signed ({sra,Binput[15:0]}) >>> Shamt;
            3'b111: Shift_Result = $signed (Binput) >>> Ainput;
            default:Shift_Result = Binput;
            endcase
        else
            Shift_Result = Binput;
    end
    
    always @* begin
    //set type operation (slt, slti, sltu, sltiu)
    //    if( (ALU_ctl==3'b111) && (Exe_code[3]==1)&&(ALUOp==2'b10))
    //        ALU_output = (Ainput<Binput)?1:0;
    //    else if ((ALU_ctl==3'b110) && (ALUOp==2'b10)&&(Exe_code[3]==1))
    //        ALU_output = ($signed(Ainput)<$signed(Binput))?1:0;
        if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1)))
            ALU_output = $signed(Ainput)<$signed(Binput)?1:0;
    //lui operation
        else if((ALU_ctl==3'b101) && (I_format==1))
            ALU_output[31:0]= {Binput,16'b0000_0000_0000_0000};
    //shift operation
        else if(Sftmd==1)
            ALU_output = Shift_Result ;
    //other types of operation in ALU (arithmatic or logic calculation)
        else
            ALU_output = ALU_output_mux[31:0];
    end
    assign Zero = (ALU_output_mux==8'h0000_0000)?1:0;
    //assign Zero = ((Exe_opcode==6'b000000&&Function_opcode==6'b001000)||((Ainput==Binput) && (Exe_opcode == 6'b000100))||(Ainput!=Binput)&&(Exe_opcode==6'b000101));
endmodule
