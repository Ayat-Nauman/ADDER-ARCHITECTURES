`timescale 1ns/1ps

module seq_adder_tb;
logic clk;
logic rst;
logic start;
logic [7:0] a;
logic [7:0] b;
logic [7:0] c;
logic [7:0] d;
logic [9:0] out;

//DUT INSTANTIATION
seq_adder dut(
.clk(clk),
.rst(rst),
.start(start),
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
clk = 0; rst = 1; #10;
rst = 0; 
start = 1'b1; a = 8'd3; b = 8'd5; c = 8'd9; d = 8'd2; #30; 		//out = 19
start = 1'b0; #10;
start = 1'b1; a = 8'd1; b = 8'd1; c = 8'd1; d = 8'd1; #30; 		//out = 4
start = 1'b0; #10;
start = 1'b1; a = 8'd3; b = 8'd3; c = 8'd3; d = 8'd3; #30; 		//out = 12
start = 1'b0; #10;
start = 1'b1; a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd255; #30;	//out = 1020
start = 1'b0; #10; 	
$stop;
end

endmodule

