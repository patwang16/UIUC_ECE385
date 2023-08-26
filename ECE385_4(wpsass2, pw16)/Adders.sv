module full_adder (input logic x, y, z,
                   output logic s, c); //1-bit adding module
	assign s = x^y^z;
	assign c = (x&y) | (y&z) | (x&z);
endmodule

module ADDER9 (input logic	[8:0] A, B,
		         input logic 		c_in,
               output logic    [8:0] S,
					output logic    c_out); //9-bit ripple carry adder using 9 1-bit adders
logic c1, c2, c3, c4, c5, c6, c7, c8;

// if c_in is 1, engage subtract mode A-B
logic [8:0] temp;
always_comb
begin
	if(c_in == 1)
	begin
		temp = ~B;
	end
	else
	begin
		temp = B;
	end
end

full_adder FA0(.x(A[0]), .y(temp[0]), .z(c_in), .s(S[0]), .c(c1));
full_adder FA1(.x(A[1]), .y(temp[1]), .z(c1), .s(S[1]), .c(c2));
full_adder FA2(.x(A[2]), .y(temp[2]), .z(c2), .s(S[2]), .c(c3));
full_adder FA3(.x(A[3]), .y(temp[3]), .z(c3), .s(S[3]), .c(c4));
full_adder FA4(.x(A[4]), .y(temp[4]), .z(c4), .s(S[4]), .c(c5));
full_adder FA5(.x(A[5]), .y(temp[5]), .z(c5), .s(S[5]), .c(c6));
full_adder FA6(.x(A[6]), .y(temp[6]), .z(c6), .s(S[6]), .c(c7));
full_adder FA7(.x(A[7]), .y(temp[7]), .z(c7), .s(S[7]), .c(c8));
full_adder FA8(.x(A[8]), .y(temp[8]), .z(c8), .s(S[8]), .c(c_out));

endmodule
