module Reg_File (input logic [2:0] DRmux_out, SR1mux_out, SR2,
					  input logic LD_REG, Clk, Reset,
					  input logic [15:0] BUS_out,
					  output logic [15:0] SR2_out, SR1_out);
					  
		logic [15:0]R[8];
		logic [7:0]Load;
					  
		reg_16 R0(.Clk, .Reset, .Load(Load[0]), .D(BUS_out), .Data_Out(R[0]));
		reg_16 R1(.Clk, .Reset, .Load(Load[1]), .D(BUS_out), .Data_Out(R[1]));
		reg_16 R2(.Clk, .Reset, .Load(Load[2]), .D(BUS_out), .Data_Out(R[2]));
		reg_16 R3(.Clk, .Reset, .Load(Load[3]), .D(BUS_out), .Data_Out(R[3]));
		reg_16 R4(.Clk, .Reset, .Load(Load[4]), .D(BUS_out), .Data_Out(R[4]));
		reg_16 R5(.Clk, .Reset, .Load(Load[5]), .D(BUS_out), .Data_Out(R[5]));
		reg_16 R6(.Clk, .Reset, .Load(Load[6]), .D(BUS_out), .Data_Out(R[6]));
		reg_16 R7(.Clk, .Reset, .Load(Load[7]), .D(BUS_out), .Data_Out(R[7]));
		
		always_comb
		begin
			if(LD_REG)
				unique case(DRmux_out)
					3'b000 : Load = 8'b00000001;
					3'b001 : Load = 8'b00000010;
					3'b010 : Load = 8'b00000100;
					3'b011 : Load = 8'b00001000;
					3'b100 : Load = 8'b00010000;
					3'b101 : Load = 8'b00100000;
					3'b110 : Load = 8'b01000000;
					3'b111 : Load = 8'b10000000;
					default : ;
				endcase
			else
				Load = 0;
		end
		
		REGmux sr1(.Select(SR1mux_out),.In0(R[0]), .In1(R[1]), .In2(R[2]), .In3(R[3]),
					  .In4(R[4]), .In5(R[5]), .In6(R[6]), .In7(R[7]), .mux_out(SR1_out));
		REGmux sr2(.Select(SR2),.In0(R[0]), .In1(R[1]), .In2(R[2]), .In3(R[3]),
					  .In4(R[4]), .In5(R[5]), .In6(R[6]), .In7(R[7]), .mux_out(SR2_out));
		
endmodule