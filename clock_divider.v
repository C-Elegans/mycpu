module clock_divider(clk_in, clk_out);
parameter DIV = 23;
input clk_in;
output wire clk_out;
reg [32:0] counter;
always @(posedge clk_in)counter = counter + 1;
assign clk_out = counter[DIV];

endmodule