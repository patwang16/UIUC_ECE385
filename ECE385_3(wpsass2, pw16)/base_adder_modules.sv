module full_adder (input logic x, y, z,
                   output logic s, c);
	assign s = x^y^z;
	assign c = (x&y) | (y&z) | (x&z);
endmodule

module ADDER4 (input logic	[3:0] A, B,
					input logic 		c_in,
               output logic    [3:0] S,
					output logic    c_out); //4-bit ripple carry adder using 4 1-bit adders
	logic c1, c2, c3;

	full_adder FA0(.x(A[0]), .y(B[0]), .z(c_in), .s(S[0]), .c(c1));
	full_adder FA1(.x(A[1]), .y(B[1]), .z(c1), .s(S[1]), .c(c2));
	full_adder FA2(.x(A[2]), .y(B[2]), .z(c2), .s(S[2]), .c(c3));
	full_adder FA3(.x(A[3]), .y(B[3]), .z(c3), .s(S[3]), .c(c_out));

endmodule

module LADDER4 (input logic   [3:0] A, B, 
					 input logic		c_in, 
					 output logic		[3:0] S,
					 output logic		PG, GG);//4-bit carry lookahead adder

	logic [3:0] P, G, U;  // U=dummy variable, P=propogate, G=generate
	logic [2:0] C; //carry in
	assign P[3:0] = A[3:0] ^ B[3:0]; //assign propagate according to lab doc
	assign G[3:0] = A[3:0] & B[3:0];//assign generate according to lab doc
	/***Below is assigning the carry in values and the carry out (PG/GG) for the adder according to formulas given by lab doc***/
	
	assign C[0] = G[0] | (P[0] & c_in);
	assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c_in);
	assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c_in);
	assign PG = P[3] & P[2] & P[1] & P[0];
	assign GG = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]);

	/*** Four one-bit adders that use dedicated carry-in values in parallel ***/
	
	full_adder ADD1(.x(A[0]), .y(B[0]), .z(c_in), .s(S[0]), .c(U[0]));
	full_adder ADD2(.x(A[1]), .y(B[1]), .z(C[0]), .s(S[1]), .c(U[1]));
	full_adder ADD3(.x(A[2]), .y(B[2]), .z(C[1]), .s(S[2]), .c(U[2]));
	full_adder ADD4(.x(A[3]), .y(B[3]), .z(C[2]), .s(S[3]), .c(U[3]));
endmodule

module SADDER4 (input logic	[3:0] A, B,
					 input logic			c_in,
					 output logic	[3:0] S,
					 output logic c_out); //4-bit select adder
		// Separately stores the intermediate calculations when c_in is still unknown
		logic [3:0] S0, S1;
		logic c_out0, c_out1;
		logic logic1, logic2;
		assign logic1 = 1'b0;
		assign logic2 = 1'b1;
		// Using a 4-bit ripple adder to do the calculations
		ADDER4 C0(.A(A[3:0]), .B(B[3:0]), .c_in(logic1), .S(S0[3:0]), .c_out(c_out0));
		ADDER4 C1(.A(A[3:0]), .B(B[3:0]), .c_in(logic2), .S(S1[3:0]), .c_out(c_out1));
		// Below is a 2-1 4-bit mux, using c_in as the select bit
		// It chooses between the two results calculated previously
		always_comb
		begin
				unique case(c_in)
						1'b0	:	begin S[3:0] = S0[3:0];
									c_out = c_out0;
									end
						1'b1	:	begin S[3:0] = S1[3:0];
									c_out = c_out1;
									end
				endcase
		end
					 
endmodule