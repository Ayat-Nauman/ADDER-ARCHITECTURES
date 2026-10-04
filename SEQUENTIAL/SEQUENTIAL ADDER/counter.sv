// 2 bit counter to count upto 4 
module counter(
input logic clk,
input logic rst,
input logic start,
output logic [1:0]count
);

always_ff @(posedge clk or posedge rst) begin
	if(rst) 
		count <= '0;
	else if(start)
		count <= count+1;
	else
		count <= '0;
end
endmodule

