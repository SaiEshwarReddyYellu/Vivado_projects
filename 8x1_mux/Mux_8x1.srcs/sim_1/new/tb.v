`timescale 1ns/1ns
 
module tb ();
 
reg clk = 0;
reg [7:0] a,b,c,d,e,f,g,h;
reg [2:0] sel;
wire [7:0] dout;
 
top t1 (clk,a,b,c,d,e,f,g,h,sel,dout);
 
always #5 clk = ~clk;
 
initial begin
a = 8'h34;
b = 8'h12;
c = 8'h45;
d = 8'ha3;
e = 8'h3d;
f = 8'hff;
g = 8'h67;
h = 8'h93;
 
#110 sel = 0;
#20 sel = 1;
#20 sel = 2;
#20 sel = 3;
#20 sel = 4;
#20 sel = 5;
#20 sel = 6;
#20 sel = 7;
#20 $stop;
end
endmodule
