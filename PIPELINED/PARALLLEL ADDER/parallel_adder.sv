module parallel_adder(
input logic clk,
input logic rst,
input logic [7:0] a,
input logic [7:0] b,
input logic [7:0] c,
input logic [7:0] d,
output logic [9:0] out
);


wire [8:0]adder1_out;
wire [9:0]adder2_out;
wire [9:0]adder3_out;
reg  [(8+8+9)-1:0] ff1; //sum of a+b, c, d
reg  [(10+8)-1:0] ff2; // sum of a+b+c, d

// Assignments for the ease of readability
wire [8:0]ff1_sum;
wire [7:0]ff1_c;
wire [7:0]ff1_d;
wire [9:0]ff2_sum;
wire [7:0]ff2_d;

assign ff1_sum  = ff1[8:0];
assign ff1_c 	= ff1[16:9];
assign ff1_d 	= ff1[24:17];
assign ff2_sum 	= ff2[9:0];
assign ff2_d 	= ff2[17:10];

//adders
assign adder1_out = a + b;
assign adder2_out = ff1_sum + ff1_c;
assign adder3_out = ff2_sum + ff2_d;

//FF1
always_ff @(posedge clk or posedge rst) begin
	if(rst) 
		ff1 <= '0;
	else
		ff1 <= {d,c,adder1_out};
end

//FF2
always_ff @(posedge clk or posedge rst) begin
	if(rst) 
		ff2 <= '0;
	else
		ff2 <= {ff1_d,adder2_out};
end

//FF3
always_ff @(posedge clk or posedge rst) begin
	if(rst) 
		out <= '0;
	else
		out <= adder3_out;
end

endmodule
