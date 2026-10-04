module seq_adder(
input logic clk,
input logic rst,
input logic start,	//counter
input logic [7:0] a,
input logic [7:0] b,
input logic [7:0] c,
input logic [7:0] d,
output logic [9:0] out
);

//INTERNAL SIGNALS
logic [1:0]counter_out; //connects counter's output to mux select input
logic [9:0]mux_out;
logic [9:0]dff_out;
logic [9:0]adder_out;

//COUNTER INSTANCE
counter counter_dut(
.clk(clk),
.rst(rst),
.start(start),
.count(counter_out)
);

//MUX INSTANCE
mux mux_dut(
.a(a),
.b(b),
.c(c),
.d(d),
.sel(counter_out),
.mux_out(mux_out)
);

//ADDER INSTANCE
adder adder_dut(
.a(dff_out),
.b(mux_out),
.out(adder_out)
);

//DFF INSTANCE
dff_10bit dff_dut(
.start(start),
.clk(clk),
.rst(rst),
.d(adder_out),
.q(dff_out)
);

assign out = (counter_out == 2'b11)? adder_out : '0;

endmodule
