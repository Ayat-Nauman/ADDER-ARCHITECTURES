module dff_10bit(
input logic start,
input logic clk,
input logic rst,
input logic [9:0]d,
output logic [9:0]q
);

always_ff@(posedge clk or posedge rst) begin
	if(rst) 
		q <= '0;
	else if(start)
		q <= d;
	else 
		q <= '0;
end

endmodule

