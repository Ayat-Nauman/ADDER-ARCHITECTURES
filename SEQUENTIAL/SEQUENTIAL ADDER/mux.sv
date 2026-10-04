module mux(
input logic [7:0] a,
input logic [7:0] b,
input logic [7:0] c,
input logic [7:0] d,
input logic [1:0] sel,
output logic [9:0]mux_out //append zeros after 8 bits 
);

always_comb begin
	case(sel)
	2'b00: mux_out = {2'b0,a};
	2'b01: mux_out = {2'b0,b};
	2'b10: mux_out = {2'b0,c};
	2'b11: mux_out = {2'b0,d};
	default mux_out = 'x;
	endcase
end

endmodule
