`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/07 15:50:42
// Design Name: 
// Module Name: vga_tb
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


module vga_tb();
    reg clk;
    reg rst;
    wire          hsync;
    wire          vsync;
    wire [3:0]    vga_r;
    wire [3:0]    vga_g;
    wire [3:0]    vga_b;
    initial begin
    clk = 1;
    rst = 0;
    #10 rst = 1;
    #20 rst = 0;
    end
    
   always #5 clk = ~clk;
   top_flyinglogo top_flyinglogo(
               .clk(clk),
               .rst(rst),
               .hsync(hsync),
               .vsync(vsync),
               .vga_r(r),
               .vga_g(g),
               .vga_b(b)
    );
endmodule
