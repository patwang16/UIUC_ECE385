//module design found on stackoverflow by user Roman Starkov https://stackoverflow.com/questions/757151/random-number-generation-on-spartan-3e

module lsfr(input clk, reset, en, output [7:0] q);
always_ff @ (posedge clk or posedge reset)
begin
	if(reset)
		q <= 8'd1;
	else if (en)
		q <= {{q[6:0]}, {q[7] ^ q[5] ^ q[4] ^ q[3]}};
end

endmodule