module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk = 1'b0;
logic [7:0] Din;
logic [7:0] A, B;
logic [6:0] AhexL, AhexU, BhexL, BhexU;

logic Cloare, Run, X;

Lab4 processor(.*);

always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
	Clk = 1'b0;
end

initial begin: TEST_VECTORS
Cloare = 1'b1;
Run = 1'b1;
Din = 8'b11111001;

#2 Cloare = 1'b0;
#2 Cloare = 1'b1;

#2 Din = 8'b11000101;
#2 Run = 1'b0;

#2 Run = 1'b1;

#50 Cloare = 1'b1;
Run = 1'b1;
Din = 8'b11111001;

#2 Cloare = 1'b0;
#2 Cloare = 1'b1;

#2 Din = 8'b00111011;
#2 Run = 1'b0;

#2 Run = 1'b1;


//#20 Run = 1'b0;

//#2 Run = 1'b1;



end
endmodule