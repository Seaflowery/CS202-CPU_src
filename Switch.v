`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 22:15:07
// Design Name: 
// Module Name: Switch
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


module Switch(
       clk,rst,rd,data,r_data
    );
    input clk;                  //ʱ���ź�
    input rst;                  //��λ�ź�
    input rd;                   //���ź�
    output [31:0]data;
    input [23:0]r_data;
    reg [31:0]res;
    always @(negedge clk or posedge rst)begin
        if (rst)begin
            res<=0;
        end 
        else if (rd)begin
            res<={8'b00000000,r_data[23:0]};
        end
        else begin
            res<=res;
        end
    end
    assign data=res;
endmodule
