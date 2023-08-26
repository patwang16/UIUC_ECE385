module ALUmodule (input logic [15:0] ALU_A, ALU_B,
				input logic [1:0] ALUK,
				output logic [15:0] ALU);
		always_comb
		begin
			unique case (ALUK)
				2'b00 : ALU = ALU_A + ALU_B;
				2'b01 : ALU = ALU_A & ALU_B;
				2'b10 : ALU = ~ALU_A;
				2'b11 : ALU = ALU_A;
			endcase
		end
endmodule