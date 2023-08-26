module datapath(input logic LD_MAR, LD_MDR, LD_IR, LD_PC, LD_LED, LD_CC, LD_BEN, LD_REG, 
					 input logic GatePC, GateMDR, GateALU, GateMARMUX,
					 input logic [1:0] PCMUX, ADDR2MUX, ALUK,
					 input logic ADDR1MUX, DRMUX, SR1MUX, SR2MUX,
					 input logic MIO_EN,
					 input logic [15:0] MDR_In,
					 output logic [15:0] MAR, MDR, IR, PC,
					 output logic BEN,
					 output logic [9:0] LED,
					 input logic Clk, Reset);
					 
					 
					 logic [15:0] PCmux_out, BUS_out, MIOmux_out, SR1_out, SR2_out, SR2mux_out, ADDR1_out, ADDR2_out, MARMUX, ALU;
					 logic [2:0] DRmux_out, SR1mux_out;
					 assign MARMUX = ADDR1_out + ADDR2_out;
					 
					 reg_16 PC_Reg(.Clk, .Reset, .Load(LD_PC), .D(PCmux_out), .Data_Out(PC));
					 
					 
					 reg_16 MDR_Reg(.Clk, .Reset, .Load(LD_MDR), .D(MIOmux_out), .Data_Out(MDR));
					 
					 reg_16 MAR_Reg(.Clk, .Reset, .Load(LD_MAR), .D(BUS_out), .Data_Out(MAR));
					 
					 reg_16 IR_Reg(.Clk, .Reset, .Load(LD_IR), .D(BUS_out), .Data_Out(IR));
					 
					 
					 MIOmux miomux(.Select(MIO_EN), .In0(BUS_out), .In1(MDR_In), .mux_out(MIOmux_out));
					 
					 PCmux pcmux(.Select(PCMUX), .In0(PC+1), .In1(BUS_out), .In2(MARMUX), .mux_out(PCmux_out));
					 
					 ADDR1mux addr1(.Select(ADDR1MUX), .In0(SR1_out), .In1(PC), .mux_out(ADDR1_out));
					 
					 ADDR2mux addr2(.Select(ADDR2MUX), .In0(0), .In1({{10{IR[5]}},IR[5:0]}), .In2({{7{IR[8]}},IR[8:0]}), .In3({{5{IR[10]}},IR[10:0]}), .mux_out(ADDR2_out));
					 
					 SR1mux sr1(.Select(SR1MUX), .In0(IR[8:6]), .In1(IR[11:9]), .mux_out(SR1mux_out));
					 
					 DRmux dr(.Select(DRMUX), .In0(IR[11:9]), .In1(3'b111), .mux_out(DRmux_out));
					 
					 SR2mux sr2(.Select(SR2MUX), .In0(SR2_out), .In1({{11{IR[4]}}, IR[4:0]}), .mux_out(SR2mux_out));
					 
					 ALUmodule alu(.ALU_A(SR1_out), .ALU_B(SR2mux_out), .ALUK, .ALU);
					 
					 BEN_Reg ben(.Clk, .Reset, .Load(LD_BEN), .LD_CC, .IR_in(IR[11:9]), .BUS(BUS_out), .BEN);
					 
					 Reg_File reginald(.DRmux_out, .SR1mux_out, .SR2(IR[2:0]), .LD_REG, .Clk, .Reset, .BUS_out, .SR2_out, .SR1_out);
					 
					 BUS bussy(.*);
					 
					 always_ff @ (posedge Clk)
					 begin
						if (LD_LED)
							LED <= IR[9:0];
						else
							LED <= 0;
					 end
endmodule