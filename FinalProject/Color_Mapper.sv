//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
							  input [3:0] BlockX, input [4:0] BlockY,
							  input [1:0] orientation, input [2:0] blockType,
							  input [15:0] gameboard [23],
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 logic [6:0] sprite_addr1, sprite_addr2, sprite_addr3, sprite_addr4;
	 logic [3:0] row1, row2, row3, row4;
	 logic [15:0] tempboard [23];
	 always_comb
	 begin
		sprite_addr1 = {{blockType[2:0]},{orientation[1:0]}, {2'b00}};
		sprite_addr2 = {{blockType[2:0]},{orientation[1:0]}, {2'b01}};
		sprite_addr3 = {{blockType[2:0]},{orientation[1:0]}, {2'b10}};
		sprite_addr4 = {{blockType[2:0]},{orientation[1:0]}, {2'b11}};
		tempboard[0] = gameboard[0];
		tempboard[1] = gameboard[1];
		tempboard[2] = gameboard[2];
		tempboard[3] = gameboard[3];
		tempboard[4] = gameboard[4];
		tempboard[5] = gameboard[5];
		tempboard[6] = gameboard[6];
		tempboard[7] = gameboard[7];
		tempboard[8] = gameboard[8];
		tempboard[9] = gameboard[9];
		tempboard[10] = gameboard[10];
		tempboard[11] = gameboard[11];
		tempboard[12] = gameboard[12];
		tempboard[13] = gameboard[13];
		tempboard[14] = gameboard[14];
		tempboard[15] = gameboard[15];
		tempboard[16] = gameboard[16];
		tempboard[17] = gameboard[17];
		tempboard[18] = gameboard[18];
		tempboard[19] = gameboard[19];
		tempboard[20] = gameboard[20];
		tempboard[21] = gameboard[21];
		tempboard[22] = gameboard[22];
		tempboard[BlockY][BlockX +: 4] =row1;
		tempboard[BlockY + 1][BlockX +: 4] = row2;
		tempboard[BlockY + 2][BlockX +: 4] = row3;
		tempboard[BlockY + 3][BlockX +: 4] = row4;
	 end
	 
	 tetromino_rom tetromino1(.addr(sprite_addr1), .data(row1));
	 tetromino_rom tetromino2(.addr(sprite_addr2), .data(row2));
	 tetromino_rom tetromino3(.addr(sprite_addr3), .data(row3));
	 tetromino_rom tetromino4(.addr(sprite_addr4), .data(row4));
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	  
	  logic block_on;
	  int row, col;
	  assign row = (DrawY - 150) / 8;
	  assign col = (DrawX - 300) /8;
    always_comb
    begin:Ball_on_proc
        if ((DrawX >= 300) && (DrawX <= 427) && (DrawY >= 150) && (DrawY <= 335) && ((  gameboard[row][col] == 1 )))
		   begin
            ball_on = 1'b1;
				block_on = 1'b0;
			end
			else if ((DrawX >= 300) && (DrawX <= 427) && (DrawY >= 150) && (DrawY <= 335) && ((tempboard[row][col] == 1)))
			begin
				block_on = 1'b1;
				ball_on = 1'b0;
			end
        else 
		  begin
            ball_on = 1'b0;
				block_on = 1'b0;
		  end
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end       
        else if (block_on == 1'b1)
		  begin
		  
			  case(blockType)
			  
			  3'b000 : begin
							Red = 8'h00;
							Green = 8'hff;
							Blue = 8'hff;
						  end
			  3'b001 : begin
							Red = 8'h00;
							Green = 8'h00;
							Blue = 8'hff;
						  end
			  3'b010 : begin
							Red = 8'hff;
							Green = 8'h80;
							Blue = 8'h00;
						  end
			  3'b011 : begin
							Red = 8'hff;
							Green = 8'hff;
							Blue = 8'h00;
						  end
			  3'b100 : begin
							Red = 8'h00;
							Green = 8'hff;
							Blue = 8'h00;
						  end
			  3'b101 : begin
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
						  end
			  3'b110 : begin
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'h00;
						  end
			  3'b111 : begin
							Red = 8'h00;
							Green = 8'hff;
							Blue = 8'hff;
						  end
				default:
				begin
					Red = 8'hff; 
					Green = 8'hff;
					Blue = 8'hff;
				end
			  endcase
		  end
		  else
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
        end      
    end 
    
endmodule
