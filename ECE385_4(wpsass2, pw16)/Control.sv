//Two-always example for state machine

module control (input  logic Clk, Cloare, Run, M,
                output logic Add, Shift, Clear_A, Sub, Load_B);

    // Declare signals curr_state, next_state of type enum
    enum logic [4:0] {Initial, Wait, Start, End, Subtract, add1, shift1, add2, shift2, add3, shift3, add4, shift4, add5, shift5, add6, shift6, add7, shift7, shift8}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Cloare)
            curr_state <= Initial;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 

            Initial :    if (~Cloare)
								next_state = Wait;
            Wait :    	if (Run)
								next_state = Start;
				Start:		next_state = add1;
            add1 :    	next_state = shift1;
            shift1 :    next_state = add2;
            add2 :    	next_state = shift2;
				shift2 :    next_state = add3;
				add3 :    	next_state = shift3;
				shift3 :    next_state = add4;
				add4 :    	next_state = shift4;
				shift4 :		next_state = add5;
				add5 :		next_state = shift5;
				shift5 : 	next_state = add6;
				add6 : 		next_state = shift6;
				shift6 :		next_state = add7;
				add7 :		next_state = shift7;
				shift7:		next_state = Subtract;
				Subtract:	next_state = shift8;
				shift8 :		next_state = End;
				End :			if (~Run)
								next_state = Wait;
							  
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   Initial: 
	         begin
					 Clear_A = 1'b1;
					 Sub = 1'b0;
					 Add = 1'b0;
					 Shift = 1'b0;
					 Load_B = 1'b1;
		      end
				Wait:
				begin
					Clear_A = 1'b0;
					Sub = 1'b0;
					Add = 1'b0;
					Shift = 1'b0;
					Load_B = 1'b0;
				end
	   	   Start: 
		      begin
                Clear_A = 1'b1;
					 Sub = 1'b0;
					 Add = 1'b0;
					 Shift = 1'b0;
					 Load_B = 1'b0;
		      end
				add1, add2, add3, add4, add5, add6, add7:
				begin
					Clear_A = 1'b0;
					Sub = 1'b0;
					Add = M;
					Shift = 1'b0;
					Load_B = 1'b0;
				end
				shift1, shift2, shift3, shift4, shift5, shift6, shift7, shift8:
				begin
					Clear_A = 1'b0;
					Sub = 1'b0;
					Add = 1'b0;
					Shift = 1'b1;
					Load_B = 1'b0;
				end
				Subtract:
				begin
					Clear_A = 1'b0;
					Sub = M;
					Add = M;
					Shift = 1'b0;
					Load_B = 1'b0;
				end
				End:
				begin
					Clear_A = 1'b0;
					Sub = 1'b0;
					Add = 1'b0;
					Shift = 1'b0;
					Load_B = 1'b0;
				end
        endcase
    end

endmodule
