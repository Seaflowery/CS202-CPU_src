`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 01:29:21
// Design Name: 
// Module Name: tube_tb
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


module tube_tb();
    reg rst, op, clk;
    reg [15:0] data;
    wire [7:0] out1, seg_en;

    Tube tubeTb(
        .rst(rst),
        .op(op),
        .data(data),
        .clk(clk),
        .out1(out1),
        .seg_en(seg_en)
    );

    initial begin
        rst = 1'b0;
        op = 1'b1;
        data = 16'h1234;
        clk = 1'b0;
    end
    
    always #5 clk = ~clk;
endmodule
