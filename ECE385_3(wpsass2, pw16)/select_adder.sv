module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	// Extending select_adder to 16-bits using 4x4 hierarchical structure
	logic Sc1,Sc2,Sc3;  //Used to store intermediate calculations
	
	// Each adder carries in the c_out of the previous adder
	  
	SADDER4 A0(.A(A[3:0]), .B(B[3:0]), .c_in(cin), .S(S[3:0]), .c_out(Sc1));
	SADDER4 A1(.A(A[7:4]), .B(B[7:4]), .c_in(Sc1), .S(S[7:4]), .c_out(Sc2));
	SADDER4 A2(.A(A[11:8]), .B(B[11:8]), .c_in(Sc2), .S(S[11:8]), .c_out(Sc3));
	SADDER4 A3(.A(A[15:12]), .B(B[15:12]), .c_in(Sc3), .S(S[15:12]), .c_out(cout));  


endmodule
