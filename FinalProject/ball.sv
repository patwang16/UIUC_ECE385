//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
               output [9:0]  BallX, BallY, BallS,  output [15:0] gameboard [23], output [3:0] BlockX, output [4:0] BlockY,
					output [1:0] orientation, output [2:0] blockType, output [23:0] score);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 logic [9:0] Block_X_Motion, Block_Y_Motion;
	 logic pressed;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 //logic [1:0] orientation;
	 //logic [2:0] blockType;
	 
	 int counter, counternext, speed;
	 logic move;
	 logic [6:0] sprite_addr1, sprite_addr2, sprite_addr3, sprite_addr4;
	 logic [3:0] row1, row2, row3, row4, testrow1, testrow2, testrow3, testrow4;
	 logic [3:0] xpos;
	 logic [4:0] ypos;
	 logic [1:0] neworientation, midorientation;
	 logic [2:0] newtype;
	 logic [3:0] testLeft, testRight, testDown, testRotate, testEnd;
	 
	 assign speed = 1 + score / 4096;
	 
	 always_comb
	 begin
		counternext = counter + speed;
		if(counter >= 6'b111111)
			move = 1'b1;
		else
			move = 1'b0;
		sprite_addr1 = {{blockType[2:0]},{orientation[1:0]}, {2'b00}};
		sprite_addr2 = {{blockType[2:0]},{orientation[1:0]}, {2'b01}};
		sprite_addr3 = {{blockType[2:0]},{orientation[1:0]}, {2'b10}};
		sprite_addr4 = {{blockType[2:0]},{orientation[1:0]}, {2'b11}};
		testLeft = (gameboard[ypos][(xpos - 1) +: 4] & row1) | (gameboard[ypos + 1][(xpos - 1) +: 4] & row2) | (gameboard[ypos + 2][(xpos - 1) +: 4] & row3) | (gameboard[ypos + 3][(xpos - 1) +: 4] & row4);
		testRight = (gameboard[ypos][(xpos + 1) +: 4] & row1) | (gameboard[ypos + 1][(xpos + 1) +: 4] & row2) | (gameboard[ypos + 2][(xpos + 1) +: 4] & row3) | (gameboard[ypos + 3][(xpos + 1) +: 4] & row4);
		testDown = (gameboard[ypos + 4][xpos +: 4] & row4) | (gameboard[ypos + 3][xpos +: 4] & row3) | (gameboard[ypos + 2][xpos +: 4] & row2) | (gameboard[ypos + 1][xpos +: 4] & row1);
		testRotate = (gameboard[ypos][xpos +: 4] & testrow1) | (gameboard[ypos + 1][xpos +: 4] & testrow2) | (gameboard[ypos + 2][xpos +: 4] & testrow3) | (gameboard[ypos + 3][xpos +: 4] & testrow4);
		testEnd = (gameboard[5'b00000][4'b0100 +: 4] & row1) | (gameboard[5'b00000 + 1][4'b0100 +: 4] & row2) | (gameboard[5'b00000 + 2][4'b0100 +: 4] & row3) | (gameboard[5'b00000 + 3][4'b0100 +: 4] & row4);
	 end
	 
	 tetromino_rom tetromino1(.addr(sprite_addr1), .data(row1));
	 tetromino_rom tetromino2(.addr(sprite_addr2), .data(row2));
	 tetromino_rom tetromino3(.addr(sprite_addr3), .data(row3));
	 tetromino_rom tetromino4(.addr(sprite_addr4), .data(row4));
	 
	 tetromino_rom test1(.addr({{blockType[2:0]},{midorientation[1:0]}, {2'b00}}), .data(testrow1));
	 tetromino_rom test2(.addr({{blockType[2:0]},{midorientation[1:0]}, {2'b01}}), .data(testrow2));
	 tetromino_rom test3(.addr({{blockType[2:0]},{midorientation[1:0]}, {2'b10}}), .data(testrow3));
	 tetromino_rom test4(.addr({{blockType[2:0]},{midorientation[1:0]}, {2'b11}}), .data(testrow4));
	
	 logic [7:0] randNum;
	 lsfr rando(.clk(frame_clk), .reset(Reset), .en(1'b1), .q(randNum));
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				pressed <= 1'b0;
				
				 gameboard[0] <= 16'b0010000000000100;
				 gameboard[1] <= 16'b0010000000000100;
				 gameboard[2] <= 16'b0010000000000100;
				 gameboard[3] <= 16'b0010000000000100;
				 gameboard[4] <= 16'b0010000000000100;
				 gameboard[5] <= 16'b0010000000000100;
				 gameboard[6] <= 16'b0010000000000100;
				 gameboard[7] <= 16'b0010000000000100;
				 gameboard[8] <= 16'b0010000000000100;
				 gameboard[9] <= 16'b0010000000000100;
				 gameboard[10] <= 16'b0010000000000100;
				 gameboard[11] <= 16'b0010000000000100;
				 gameboard[12] <= 16'b0010000000000100;
				 gameboard[13] <= 16'b0010000000000100;
				 gameboard[14] <= 16'b0010000000000100;
				 gameboard[15] <= 16'b0010000000000100;
				 gameboard[16] <= 16'b0010000000000100;
				 gameboard[17] <= 16'b0010000000000100;
				 gameboard[18] <= 16'b0010000000000100;
				 gameboard[19] <= 16'b0010000000000100;
					
				 gameboard[20] <= 16'b0011111111111100;
				 gameboard[21] <= 16'b0000000000000000;
				 gameboard[22] <= 16'b0000000000000000;
				 
				 blockType <= 3'b000;
				 orientation <= 2'b00;
				 xpos <= 4'b0100;
				 ypos <= 5'b0000;
				 counter <= 0;
				 score <= 0;
        end
           
        else 
        begin 	
				/*
				gameboard[ypos][xpos +: 4] <= {{row1[0]},{row1[1]}, {row1[2]},{row1[3]}};
				gameboard[ypos + 2'b01][xpos +: 4] <= {{row2[0]},{row2[1]}, {row2[2]},{row2[3]}};
				gameboard[ypos + 2'b10][xpos +: 4] <= {{row3[0]},{row3[1]}, {row3[2]},{row3[3]}};
				gameboard[ypos + 2'b11][xpos +: 4] <= {{row4[0]},{row4[1]}, {row4[2]},{row4[3]}};
				*/
				
				counter <= counternext;
				
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					begin
					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  Ball_X_Motion <= 0;
					end
					  
				 else if ( (Ball_Y_Pos - Ball_Size) + 5 <= Ball_Y_Min  + 5)  // Ball is at the top edge, BOUNCE!
					begin
					  Ball_Y_Motion <= Ball_Y_Step;
					  Ball_X_Motion <= 0;
					end
					  
				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
					begin
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  Ball_Y_Motion <= 0;
					end
					
				 else if ( (Ball_X_Pos - Ball_Size) + 5 <= Ball_X_Min + 5)  // Ball is at the Left edge, BOUNCE!
					begin
					  Ball_X_Motion <= Ball_X_Step;
					  Ball_Y_Motion <= 0;
					end
					  
				 else 
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 
				 case (keycode)
					8'h04 : begin

								if (testLeft != 4'b0000)  // Ball is at the Left edge, BOUNCE!
								begin
									Ball_X_Motion <= Ball_X_Step;
									Ball_Y_Motion <= 0;
									Block_X_Motion <= 0;
									Block_Y_Motion <= 0;
								end
								else
								begin
									Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);//A
									Ball_Y_Motion <= 0;
									Block_X_Motion <= (~ (Ball_X_Step) + 1'b1);//A
									Block_Y_Motion <= 0;
									pressed <= 1'b1;
								end
							  end
					        
					8'h07 : begin
								
								if (testRight != 4'b0000)  // Ball is at the Right edge, BOUNCE!
								begin
									Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
									Ball_Y_Motion <= 0;
									Block_X_Motion <= 0;
									Block_Y_Motion <= 0;
								end
								else
								begin
									Ball_X_Motion <= Ball_X_Step;//D
									Ball_Y_Motion <= 0;
									Block_X_Motion <= Ball_X_Step;//D
									Block_Y_Motion <= 0;
									pressed <= 1'b1;
								end
							  end

							  
					8'h16 : begin
								if ( testDown != 4'b0000 )  // Ball is at the bottom edge, BOUNCE!
								begin
									Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
									Ball_X_Motion <= 0;
									Block_X_Motion <= 0;
									Block_Y_Motion <= 0;
								end
								else
								begin
									Ball_Y_Motion <= Ball_Y_Step;//S
									Ball_X_Motion <= 0;
									Block_Y_Motion <= Ball_Y_Step;//S
									Block_X_Motion <= 0;
									pressed <= 1'b1;
								end
							  end
							  /*
					8'h1A : begin
								if ( (Ball_Y_Pos - Ball_Size) + 5 <= Ball_Y_Min + 5)  // Ball is at the top edge, BOUNCE!
								begin
									Ball_Y_Motion <= Ball_Y_Step;
									Ball_X_Motion <= 0;
								end
								else
								begin
									Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);//W
									Ball_X_Motion <= 0;
									Block_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);//W
									Block_X_Motion <= 0;
									pressed <= 1'b1;
								end
							 end	
							*/ 
					8'h52 : 	begin
									pressed <= 1'b1;
									midorientation <= orientation + 1;
									if(testRotate == 4'b0000)
										neworientation <= midorientation;
								end
					
					8'h51 : begin
									pressed <= 1'b1;
									midorientation <= orientation - 1;
									if(testRotate == 4'b0000)
										neworientation <= midorientation;

								end
								/*
					8'h4f : 	begin
									newtype <= blockType + 1;
									pressed <= 1'b1;
								end
					
					8'h50 : begin
									newtype <= blockType - 1;
									pressed <= 1'b1;
								end
								*/
					default: 
					begin
						pressed <= 1'b0;
					end
			   endcase
				
				 if (pressed == 1'b0)
				 begin
					 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
					 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					 Ball_Y_Motion <= 0;
					 Ball_X_Motion <= 0;
					 xpos <= xpos + Block_X_Motion;
					 ypos <= ypos + Block_Y_Motion;
					 Block_Y_Motion <= 0;
					 Block_X_Motion <= 0;
					 orientation <= neworientation;
					 blockType <= newtype;
				 end
				 if(move)
					begin
						if(testDown == 4'b0000)
						begin
							ypos <= ypos + Ball_Y_Step;
						end
						else
						begin
							
							gameboard[ypos][xpos +: 4] <= gameboard[ypos][xpos +: 4] + row1;
							gameboard[ypos + 1][xpos +: 4] <= gameboard[ypos + 1][xpos +: 4] + row2;
							gameboard[ypos + 2][xpos +: 4] <= gameboard[ypos + 2][xpos +: 4] + row3;
							gameboard[ypos + 3][xpos +: 4] <= gameboard[ypos + 3][xpos +: 4] + row4;
							score <= score + 64;
							if(testEnd == 4'b0000)
							begin
								xpos <= 4'b0100;
								ypos <= 5'b0000;
								newtype <= randNum[2:0];
							end
							else
							begin

								xpos <= 4'b1111;
								ypos <= 5'b11111;
								 gameboard[0] <=  16'b0000000000000000;
								 gameboard[1] <=  16'b0000111111110000;
								 gameboard[2] <=  16'b0000111111110000;
								 gameboard[3] <=  16'b0000000001110000;
								 gameboard[4] <=  16'b0000111111110000;
								 gameboard[5] <=  16'b0000000001110000;
								 gameboard[6] <=  16'b0000111111110000;
								 gameboard[7] <=  16'b0000111111110000;
								 gameboard[8] <=  16'b0000000000000000;
								 gameboard[9] <=  16'b0000110001110000;
								 gameboard[10] <= 16'b0000110011110000;
								 gameboard[11] <= 16'b0000110110110000;
								 gameboard[12] <= 16'b0000111100110000;
								 gameboard[13] <= 16'b0000111000110000;
								 gameboard[14] <= 16'b0000110000110000;
								 gameboard[15] <= 16'b0000000000000000;
								 gameboard[16] <= 16'b0000000111110000;
								 gameboard[17] <= 16'b0000011111110000;
								 gameboard[18] <= 16'b0000111000110000;
								 gameboard[19] <= 16'b0000110000110000;
									
								 gameboard[20] <= 16'b0000111000110000;
								 gameboard[21] <= 16'b0000011111110000;
								 gameboard[22] <= 16'b0000000111110000;
							end
							
						end
						counter <= 0;
						
					end
				   if(gameboard[0][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							score <= score + 512;
						end
					if(gameboard[1][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							score <= score + 512;
						end
						
					if(gameboard[2][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							score <= score + 512;
						end
						
					if(gameboard[3][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							score <= score + 512;
						end
						
					if(gameboard[4][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							score <= score + 512;
						end
						
					if(gameboard[5][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							score <= score + 512;
						end
						
					if(gameboard[6][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							score <= score + 512;
						end
						
					if(gameboard[7][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							score <= score + 512;
						end
						
					if(gameboard[8][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							score <= score + 512;
						end
						
					if(gameboard[9][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							score <= score + 512;
						end
						
					if(gameboard[10][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							score <= score + 512;
						end
						
					if(gameboard[11][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							score <= score + 512;
						end
						
					if(gameboard[12][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							score <= score + 512;
						end
						
					if(gameboard[13][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							gameboard[13][12:3] <= gameboard[12][12:3];
							score <= score + 512;
						end
						
					if(gameboard[14][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							gameboard[13][12:3] <= gameboard[12][12:3];
							gameboard[14][12:3] <= gameboard[13][12:3];
							score <= score + 512;
						end
						
					if(gameboard[15][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							gameboard[13][12:3] <= gameboard[12][12:3];
							gameboard[14][12:3] <= gameboard[13][12:3];
							gameboard[15][12:3] <= gameboard[14][12:3];
							score <= score + 512;
						end
						
					if(gameboard[16][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							gameboard[13][12:3] <= gameboard[12][12:3];
							gameboard[14][12:3] <= gameboard[13][12:3];
							gameboard[15][12:3] <= gameboard[14][12:3];
							gameboard[16][12:3] <= gameboard[15][12:3];
							score <= score + 512;
						end
						
					if(gameboard[17][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							gameboard[13][12:3] <= gameboard[12][12:3];
							gameboard[14][12:3] <= gameboard[13][12:3];
							gameboard[15][12:3] <= gameboard[14][12:3];
							gameboard[16][12:3] <= gameboard[15][12:3];
							gameboard[17][12:3] <= gameboard[16][12:3];
							score <= score + 512;
						end
						
					if(gameboard[18][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							gameboard[13][12:3] <= gameboard[12][12:3];
							gameboard[14][12:3] <= gameboard[13][12:3];
							gameboard[15][12:3] <= gameboard[14][12:3];
							gameboard[16][12:3] <= gameboard[15][12:3];
							gameboard[17][12:3] <= gameboard[16][12:3];
							gameboard[18][12:3] <= gameboard[17][12:3];
							score <= score + 512;
						end
						
					if(gameboard[19][12:3] == 10'b1111111111)
						begin
							gameboard[0][12:3] <= 10'b0000000000;
							gameboard[1][12:3] <= gameboard[0][12:3];
							gameboard[2][12:3] <= gameboard[1][12:3];
							gameboard[3][12:3] <= gameboard[2][12:3];
							gameboard[4][12:3] <= gameboard[3][12:3];
							gameboard[5][12:3] <= gameboard[4][12:3];
							gameboard[6][12:3] <= gameboard[5][12:3];
							gameboard[7][12:3] <= gameboard[6][12:3];
							gameboard[8][12:3] <= gameboard[7][12:3];
							gameboard[9][12:3] <= gameboard[8][12:3];
							gameboard[10][12:3] <= gameboard[9][12:3];
							gameboard[11][12:3] <= gameboard[10][12:3];
							gameboard[12][12:3] <= gameboard[11][12:3];
							gameboard[13][12:3] <= gameboard[12][12:3];
							gameboard[14][12:3] <= gameboard[13][12:3];
							gameboard[15][12:3] <= gameboard[14][12:3];
							gameboard[16][12:3] <= gameboard[15][12:3];
							gameboard[17][12:3] <= gameboard[16][12:3];
							gameboard[18][12:3] <= gameboard[17][12:3];
							gameboard[19][12:3] <= gameboard[18][12:3];
							score <= score + 512;
						end
					
				
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
		
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    
	 assign BlockX = xpos;
	 
	 assign BlockY = ypos;

endmodule
