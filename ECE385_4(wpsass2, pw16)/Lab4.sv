module Lab4 (input logic   Clk,     // Internal
                           Cloare,   // Push button 0
                           Run, // Push button 1
				 input  logic [7:0]  Din,     // input data, switches
				  //Hint for SignalTap, you want to comment out the following 2 lines to hardwire values for F and R
             output logic [7:0]  A,    // DEBUG
                                 B,    // DEBUG
				 output logic 			X,
             output logic [6:0]  AhexL,
                                 AhexU,
                                 BhexL,
                                 BhexU);
		logic [7:0] Din_S;
		logic Cloare_S, Run_S;
		logic [8:0] Sum;
		logic unused, alsoUseless, B_in;
		logic Add, Shift, Clear_A, Sub, Load_B;
		logic Override;
		
		
		reg_8 regA(.Clk, .Reset((Clear_A)), .Shift_In(X), .Load(Add | Sub), .Shift_En(Shift), .D(Sum[7:0]), .Shift_Out(B_in), .Data_Out(A[7:0]));
		
		reg_8 regB(.Clk, .Reset(1'b0), .Shift_In(B_in), .Load(Load_B), .Shift_En(Shift), .D(Din_S), .Shift_Out(unused), .Data_Out(B[7:0]));
		
		reg_1 regX(.Clk, .Reset(Clear_A), .Load(Add | Sub), .Shift_In(Sum[8]), .Shift_Out(X));
		
		control dom(.Clk, .Cloare(Cloare_S), .Run(Run_S), .M(B[0]), .Add, .Shift, .Clear_A, .Sub, .Load_B);
		
		ADDER9 adder(.A({A[7],A}), .B({Din[7], Din}), .c_in(Sub), .S(Sum[8:0]), .c_out(alsoUseless));
		
		
		
		HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(AhexL) );
		HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(BhexL) );
								
		HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(AhexU) );	
		HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(BhexU) );
							
							

					 
		sync button_sync[1:0] (Clk, {~Run, ~Cloare}, {Run_S, Cloare_S});
	   sync Din_sync[7:0] (Clk, Din, Din_S);
										  
endmodule