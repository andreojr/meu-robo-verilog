module mealy_robot(clk, head, left, front, rotate);
	input clk, head, left;
	output reg front, rotate;
  
	reg [1:0] current_state, future_state;
  
	parameter searching_wall = 2'b00, following_wall = 2'b01, rotating = 2'b10;
  
	always @(posedge clk) current_state <= future_state;
  
	always @(current_state or head or left) begin
      		case (current_state)
			searching_wall:
          			case ({head, left})
            				2'b00: begin
						future_state = searching_wall;
						front = 1'b1;
						rotate = 1'b0;
                        		end
            				2'b01: begin
                          			future_state = following_wall;
                  				front = 1'b1;
      						rotate = 1'b0;
                        		end
            				2'b10: begin
                          			future_state = rotating;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
            				2'b11: begin
                          			future_state = rotating;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
          			endcase
        		following_wall:
          			case ({head, left})
            				2'b00: begin
                         			future_state = searching_wall;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
            				2'b01: begin
                          			future_state = following_wall;
                  				front = 1'b1;
      						rotate = 1'b0;
                        		end
            				2'b10: begin
                          			future_state = searching_wall;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
            				2'b11: begin
                          			future_state = rotating;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
          			endcase
        		rotating:
          			case ({head, left})
            				2'b00: begin
                         			future_state = rotating;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
            				2'b01: begin
                          			future_state = following_wall;
                  				front = 1'b1;
      						rotate = 1'b0;
                        		end
            				2'b10: begin
                          			future_state = rotating;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
            				2'b11: begin
                          			future_state = rotating;
                  				front = 1'b0;
      						rotate = 1'b1;
                        		end
          			endcase
          		default: begin
        	      		future_state = searching_wall;
	        		front = 1'b1;
        			rotate = 1'b0;
            		end
     		endcase
    	end
endmodule
