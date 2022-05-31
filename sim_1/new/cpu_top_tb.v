`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 21:43:16
// Design Name: 
// Module Name: cpu_top_tb
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


module cpu_top_tb(

    );
    reg rst;
    reg clk;
    reg [23:0]switch ;
    wire [23:0]led;
    wire [7:0]tube_en;
    wire [7:0]tube_num;
    reg start_pg;
    reg rx;
    wire tx;
    CPU_top cpu_top(
        .fpga_rst(rst),
        .fpga_clk(clk),
        .switch2N4(switch),
        .led2N4(led),
        .en_tube(tube_en),
        .tube_num(tube_num),
        .start_pg(start_pg),
        .rx(rx),
        .tx(tx)

    );
    
    initial begin
        rst=1;
        clk=0;
        switch=0;
        start_pg=0;
        rx=0;
        
        #5000
        rst=0;
        #5000

        #5000 switch=24'b0001_0000_0000_0000_0000_0000;
        #5000 switch=24'b0000_0000_0000_0000_0000_0010;
        
        #5000 switch=24'b0001_0000_0000_0000_0000_1010;
        
        #5000 switch=24'b0000_0000_0000_0000_0000_0001;
        
        #5000 switch=24'b0011_0000_0000_0000_0000_0000;
                        
        #5000 switch=24'b1000_0000_0000_0000_0000_0000;
        #5000 switch=24'b1001_0000_0000_0000_0000_0001;
        // #50 switch[20]=1; 
                
        // #50 switch=24'b1001_0000_0000_0000_0000_0001;
        // #50 switch[20]=0;
        
         
        // #5000 switch=24'b1000_0000_0000_0000_0000_0001;
        // #50 switch[20]=0;
                       
        
    end
    always #5 clk=~clk;
    
endmodule
