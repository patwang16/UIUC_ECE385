module reg_16 (input logic 			Clk, Reset, Load,
					input logic          [15:0] D,
					output logic 			[15:0] Data_Out);
					
		always_ff @ (posedge Clk)
		begin
				// Setting the output Q[16..0] of the register to zeros as Reset is pressed
				if(Reset) //notice that this is a synchronous reset
					Data_Out <= 16'b0000000000000000;
				// Loading D into register when load button is pressed (will eiher be switches or result of sum)
				else if(Load)
					Data_Out <= D;
		end
		
endmodule

module reg_1 (input logic Clk, Reset, Load, Shift_In,
				  output logic Shift_Out);
				  
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				Shift_Out <= 0;
			else if (Load)
				Shift_Out <= Shift_In;
		end
endmodule

module reg_3 (input logic Clk, Reset, Load,
				  input logic [2:0] D,
				  output logic [2:0] Data_Out);
				  
		always_ff @ (posedge Clk)
		begin
			if (Reset)
				Data_Out <= 0;
			else if (Load)
				Data_Out <= D;
		end
endmodule

module BEN_Reg (input logic Clk, Reset, Load, LD_CC,
					 input logic [2:0] IR_in,
					 input logic [15:0] BUS,
					 output logic BEN);
					 
	logic [2:0] CC, nzp;
	logic newBEN;
	assign newBEN = ((IR_in[2] && CC[2]) || (IR_in[1] && CC[1]) || (IR_in[0] && CC[0]));
	reg_1 BEN_temp(.Clk, .Reset, .Load, .Shift_In(newBEN), .Shift_Out(BEN));
	reg_3 NZP(.Clk, .Reset, .Load(LD_CC), .D(nzp), .Data_Out(CC));
	always_comb
	begin
		if(BUS[15] == 1'b1)
			nzp = 3'b100;
		else if (BUS == 0)
			nzp = 3'b010;
		else
			nzp = 3'b001;
	end
endmodule
