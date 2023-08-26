module testbench();

timeunit 10ns;
timeprecision 1ns;

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
logic       CE, UB, LB, OE, WE, BEN, newBEN;
logic [15:0] ADDR;
logic Run_ctrl, Continue_ctrl;
assign Run = ~ Run_ctrl;
assign Continue = ~ Continue_ctrl;

logic [15:0] MAR, MDR, PC, IR, ADDR2mux_out;
logic [1:0] ADDR2MUX;
logic [4:0] state;
logic [15:0] R0, R1, BUS;

assign MAR = testslc3.slc.MAR;
assign MDR = testslc3.slc.MDR;
assign PC = testslc3.slc.PC;
assign IR = testslc3.slc.IR;
assign ADDR2mux_out = testslc3.slc.d0.ADDR2_out;
assign ADDR2MUX = testslc3.slc.d0.ADDR2MUX;
assign state = testslc3.slc.state_controller.State;
assign BEN = testslc3.slc.d0.BEN;
assign newBEN = testslc3.slc.d0.ben.newBEN;
assign R0 = testslc3.slc.d0.reginald.R0.Data_Out;
assign R1 = testslc3.slc.d0.reginald.R1.Data_Out;
assign BUS = testslc3.slc.d0.BUS_out;

slc3_testtop testslc3(.*);


   always begin : CLOCK_GENERATION 
		#1 Clk = ~Clk;
   end


	initial begin: CLOCK_INITIALIZATION 
		Clk = 0;
   end
	

	initial begin: TEST_VECTORS
	#0
	
	Run_ctrl = 1'b1;
	Continue_ctrl = 1'b1;
	#3
	SW = 10'b0000000011;
	Run_ctrl = 1'b0;
	Continue_ctrl = 1'b0;


	#20
	//SW = 10'b0000000110;
	Run_ctrl = 1'b1;
	#3
	Run_ctrl = 1'b0;


	#20
	//SW = 10'b0000001011;
	Continue_ctrl = 1'b1;
	#3
	Continue_ctrl = 1'b0;

	#20
	Continue_ctrl = 1'b1;
	#3
	Continue_ctrl = 1'b0;

	#20
	Continue_ctrl = 1'b1;
	#3
	Continue_ctrl = 1'b0;

	#10
	Run_ctrl = 1'b1;
	Continue_ctrl = 1'b1;
	#3
	Run_ctrl = 1'b0;
	Continue_ctrl = 1'b0;

	#20
	Run_ctrl = 1'b1;
	#3
	Run_ctrl = 1'b0;


	#20
	Continue_ctrl = 1'b1;
	#3
	Continue_ctrl = 1'b0;

	#20
	Continue_ctrl = 1'b1;
	#3
	Continue_ctrl = 1'b0;

	#20
	Continue_ctrl = 1'b1;
	#3
	Continue_ctrl = 1'b0;

	end
	 
endmodule
