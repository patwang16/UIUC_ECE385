module BUS(input logic [15:0] PC, MDR, MARMUX, ALU,
			  input logic GatePC, GateMDR, GateALU, GateMARMUX,
			  output logic [15:0] BUS_out);
			  
			  always_comb
			  begin
					if(GatePC)
						BUS_out = PC;
					else if(GateMDR)
						BUS_out = MDR;
					else if(GateALU)
						BUS_out = ALU;
					else if(GateMARMUX)
						BUS_out = MARMUX;
					else
						BUS_out = 16'bxxxxxxxxxxxxxxxx;
			  end
endmodule