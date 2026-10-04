module unrolled_adder(
input logic clk,
input logic rst,
input logic [7:0] a,
input logic [7:0] b,
input logic [7:0] c,
input logic [7:0] d,
output logic [9:0] out
);


wire [8:0]a_plus_b;
wire [9:0]sum_plus_c;
wire [9:0]sum_plus_d;

reg  [7:0] reg_a;
reg  [7:0] reg_b;
reg  [7:0] reg_c;
reg  [7:0] reg_d;

assign a_plus_b = reg_a + reg_b;
assign sum_plus_c = a_plus_b + reg_c;
assign sum_plus_d = sum_plus_c + reg_d;

always_ff @(posedge clk or posedge rst) begin
	if(rst) begin
		reg_a <= '0;
		reg_b <= '0;
		reg_c <= '0;
		reg_d <= '0;
		out   <= '0;
	end else begin
		reg_a <= a;
		reg_b <= b;
		reg_c <= c;
		reg_d <= d;
		out   <= sum_plus_d;
	end
end

endmodule

