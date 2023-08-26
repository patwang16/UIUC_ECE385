module testbench();

timeunit 10ns;

timeprecision 1ns;

logic [15:0] A,B;
logic cin;
logic [15:0] S;
logic cout;

lookahead_adder radder(.*);

initial begin: TEST_VECTORS
A = 16'b1001110100001001;
B = 16'b1110011011100000;
cin = 0;

#10 A = 16'b1001110100001001;
B = 16'b1110011011100000;
cin = 1;


end

endmodule