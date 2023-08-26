/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

//logic [31:0] LOCAL_REG       [`NUM_REGS]; // Registers
//put other local variables here
logic pixel_clk, blank, sync;
logic [9:0] DrawX, DrawY;
logic [10:0] sprite_addr;
logic [7:0] sprite_data;
logic [11:0] mid;
logic [31:0] AVL_WRITEDATA_local, AVL_READDATA_local, pixeldata;

//Declare submodules..e.g. VGA controller, ROMS, etc

vga_controller vgactrl(.Clk(CLK), .Reset(RESET), .*);

font_rom rom(.addr(sprite_addr), .data(sprite_data));
	
ocm ocm0(.address_a(AVL_ADDR), .address_b(mid), .byteena_a(AVL_BYTE_EN), .byteena_b(4'b1111), .clock(CLK), .data_a(AVL_WRITEDATA_local), .data_b(0), .rden_a(AVL_READ), .rden_b(1'b1), .wren_a(AVL_WRITE), .wren_b(1'b0), .q_a(AVL_READDATA_local), .q_b(pixeldata));

always_comb begin
	if (AVL_CS) begin
		AVL_WRITEDATA_local = AVL_WRITEDATA;
		AVL_READDATA = AVL_READDATA_local;
	end
	else begin
		AVL_WRITEDATA_local = 0;
		AVL_READDATA = 0;
	end
end

logic [31:0] palette [8];

always_ff @(posedge CLK) begin
	if(AVL_CS && AVL_WRITE && AVL_ADDR[11]) begin
		palette[AVL_ADDR[2:0]] <= AVL_WRITEDATA;
	end
	else if (RESET)
		palette[AVL_ADDR[2:0]] <= 0;

end


//handle drawing (may either be combinational or sequential - or both).
logic [9:0] col, row;
logic [12:0] curr;
logic [7:0] char;
logic [15:0] cashmoney;  // data for current glyph from RAM

always_comb
begin
	col = DrawX[9:3];
	row = DrawY[9:4];
	
	curr = row * 80 + col;
	mid = curr/2;
	
	case (curr[0])
		1'b0:	cashmoney = pixeldata[15:0];
		1'b1:	cashmoney = pixeldata[31:16];
		
		default:;
	endcase
	
	char[7:0] = cashmoney[15:8];
	
	sprite_addr = {{char[6:0]},{DrawY[3:0]}};
end



always_ff @(posedge pixel_clk)
begin
	if (blank)
		begin
			if((sprite_data[~(DrawX[2:0])]) ^ char[7] == 1) // foreground
				begin
					if(cashmoney[4]) begin
						red <= palette[cashmoney[7:5]][24:21];
						green <= palette[cashmoney[7:5]][20:17];
						blue <= palette[cashmoney[7:5]][16:13];
					end
					else begin
						red <= palette[cashmoney[7:5]][12:9];
						green <= palette[cashmoney[7:5]][8:5];
						blue <= palette[cashmoney[7:5]][4:1];
					end
				end
			else															// background
				begin
					if(cashmoney[0]) begin
						red <= palette[cashmoney[3:1]][24:21];
						green <= palette[cashmoney[3:1]][20:17];
						blue <= palette[cashmoney[3:1]][16:13];
					end
					else begin
						red <= palette[cashmoney[3:1]][12:9];
						green <= palette[cashmoney[3:1]][8:5];
						blue <= palette[cashmoney[3:1]][4:1];
					end
				end
		end
	else
		begin
			red <= 0;
			green <= 0;
			blue <= 0;
		end
end
endmodule
