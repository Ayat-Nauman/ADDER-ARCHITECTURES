`timescale 1ns/1ps

module unrolled_adder_tb;
logic clk;
logic rst;
logic [7:0] a;
logic [7:0] b;
logic [7:0] c;
logic [7:0] d;
logic [9:0] out;

//DUT INSTANTIATION
unrolled_adder dut(
.clk(clk),
.rst(rst),
.a(a),
.b(b),
.c(c),
.d(d),
.out(out)
);

//CLOCK GENERATION
always begin
	clk = ~clk;
	#5;
end

//TEST CASES
initial begin
clk = 1; rst = 1; #10;
rst = 0;
a = 8'd3; b = 8'd5; c = 8'd9; d = 8'd2; #10; 		//out = 19
a = 8'd1; b = 8'd1; c = 8'd1; d = 8'd1; #10; 		//out = 4
a = 8'd3; b = 8'd3; c = 8'd3; d = 8'd3; #10; 		//out = 12
a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd255; #10; 	//out = 1020
#10;
$stop;
end

endmodule

