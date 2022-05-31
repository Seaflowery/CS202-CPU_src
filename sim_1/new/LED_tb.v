`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/28 21:54:11
// Design Name: 
// Module Name: LED_tb
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


module LED_tb();
    reg [5:0] opcode;
    reg [31:0] instruction;
    reg op;
    wire [23:0] data;
    reg [15:0] r_data;

    Led led(
        .opcode(opcode),
        .Instruction(instruction),
        .op(op),
        .data(data),
        .r_data(r_data)
    );

    initial begin
        instruction = 32'h00000000;
        opcode = 6'b000000;
        op = 1;
        r_data = 16'h0000;

        #20 instruction = 32'h24020001;
        opcode = 6'b001001;
        #20 instruction = 32'h3c010000;
        opcode = 6'b001111;
        #20 instruction = 32'hac220000;
        r_data = 16'h0001;
        opcode = 6'b101011;
        #20 opcode = 6'b000000;
        instruction = 32'h00000000;
        op = 0;
    end

endmodule
