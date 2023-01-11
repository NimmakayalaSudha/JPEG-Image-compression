`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2021 10:25:21 AM
// Design Name: 
// Module Name: product
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


module product(clk,x_in,z_in,c_en,out);
input clk,c_en;
input [63:0] x_in,z_in;
output reg [63:0] out;
integer i,s;
reg [63:0]x_in1;
reg [63:0] y [-20:30];
reg [63:0] z [-20:30];
always @(posedge clk & c_en)
begin
    y[-20]<=0;
    z[-20]<=z_in[63]?-z_in:z_in;
    x_in1=x_in[63]?-x_in:x_in;
    for(i=-20;i<=30;i=i+1)
    begin:yz
         reg z_sign;
         assign z_sign =z[i][63];
         y[i+1]=z_sign ? y[i]-((i<1)?x_in1<<-i:x_in1>>i) :y[i]+((i<1)?x_in1<<-i:x_in1>>i);
         z[i+1]=z_sign ? z[i]+((i<1)?64'h1000000<<-i:64'h1000000>>i)  :z[i]-((i<1)?64'h1000000<<-i:64'h1000000>>i);
         if(z[i][63:12]==0)
             begin
             out=(x_in[63]^z_in[63])?-y[i]:y[i];
             end
    end
end
endmodule
