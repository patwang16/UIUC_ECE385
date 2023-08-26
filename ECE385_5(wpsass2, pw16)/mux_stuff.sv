module PCmux(input logic [1:0] Select,
				 input logic [15:0] In0, In1, In2,
				 output logic [15:0] mux_out);
				 
				 always_comb
				 begin
					unique case(Select)
						2'b00 : mux_out = In0;
						2'b01 : mux_out = In1;
						2'b10 : mux_out = In2;
						2'b11 : mux_out = 0;
					endcase
				 end
endmodule


module MIOmux(input logic Select,
				  input logic [15:0] In0, In1,
				  output logic [15:0] mux_out);
				  
				  always_comb
				  begin
					unique case(Select)
						1'b0 : mux_out = In0;
						1'b1 : mux_out = In1;
					endcase
				  end
endmodule

module ADDR1mux(input logic Select,
				 input logic [15:0] In0, In1,
				 output logic [15:0] mux_out);
				 
				 always_comb
				 begin
					unique case(Select)
						1'b0 : mux_out = In0;
						1'b1 : mux_out = In1;
					endcase
				 end
endmodule

module ADDR2mux(input logic [1:0] Select,
				 input logic [15:0] In0, In1, In2, In3,
				 output logic [15:0] mux_out);
				 
				 always_comb
				 begin
					unique case(Select)
						2'b00 : mux_out = In0;
						2'b01 : mux_out = In1;
						2'b10 : mux_out = In2;
						2'b11 : mux_out = In3;
					endcase
				 end
endmodule

module SR1mux(input logic Select,
				 input logic [2:0] In0, In1,
				 output logic [2:0] mux_out);
				 
				 always_comb
				 begin
					unique case(Select)
						1'b0 : mux_out = In0;
						1'b1 : mux_out = In1;
					endcase
				 end
endmodule

module DRmux(input logic Select,
				 input logic [2:0] In0, In1,
				 output logic [2:0] mux_out);
				 
				 always_comb
				 begin
					unique case(Select)
						1'b0 : mux_out = In0;
						1'b1 : mux_out = In1;
					endcase
				 end
endmodule

module SR2mux(input logic Select,
				 input logic [15:0] In0, In1,
				 output logic [15:0] mux_out);
				 
				 always_comb
				 begin
					unique case(Select)
						1'b0 : mux_out = In0;
						1'b1 : mux_out = In1;
					endcase
				 end
endmodule

module REGmux(input logic [2:0] Select,
				  input logic [15:0] In0, In1, In2, In3, In4, In5, In6, In7,
				  output logic [15:0] mux_out);
				  
				  always_comb
				 begin
					unique case(Select)
						3'b000 : mux_out = In0;
						3'b001 : mux_out = In1;
						3'b010 : mux_out = In2;
						3'b011 : mux_out = In3;
						3'b100 : mux_out = In4;
						3'b101 : mux_out = In5;
						3'b110 : mux_out = In6;
						3'b111 : mux_out = In7;
					endcase
				 end
endmodule