module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	//logic Lc1, Lc2, Lc3;
	logic [3:0] PG, GG; // PG and GG bits for calculating carry in values
	logic [2:0] CC; // carry in values

	/*** each 4-bit lookahead adder produces 4 bits of the sum as well as PG and GG,
	which are used to calculate the carry-in of the next adder according to formulas given in lab doc ***/

	LADDER4 LA0(.A(A[3:0]), .B(B[3:0]), .c_in(cin), .S(S[3:0]), .PG(PG[0]), .GG(GG[0]));
	assign CC[0] = GG[0] | (cin & PG[0]);
	LADDER4 LA1(.A(A[7:4]), .B(B[7:4]), .c_in(CC[0]), .S(S[7:4]), .PG(PG[1]), .GG(GG[1]));
	assign CC[1] = GG[1] | (GG[0] & PG[1]) | (cin & PG[0] & PG[1]);
	LADDER4 LA2(.A(A[11:8]), .B(B[11:8]), .c_in(CC[1]), .S(S[11:8]), .PG(PG[2]), .GG(GG[2]));
	assign CC[2] = GG[2] | (GG[1] & PG[2]) | (GG[0] & PG[1] & PG[2]) | (cin & PG[0] & PG[1] & PG[2]);
	LADDER4 LA3(.A(A[15:12]), .B(B[15:12]), .c_in(CC[2]), .S(S[15:12]), .PG(PG[3]), .GG(GG[3]));
	assign cout = GG[3] | (GG[2] & PG[3]) | (GG[1] & PG[2] & PG[3]) | (GG[0] & PG[1] & PG[2] & PG[3]) | (cin & PG[0] & PG[1] & PG[2] & PG[3]);

endmodule
