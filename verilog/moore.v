module moore_robot(clk, head, left, front, rotate);
	input clk, head, left;
	output front, rotate;

	reg [1:0] current_state, future_state;

	parameter searching_wall = 2'b00, following_wall = 2'b01, rotating = 2'b10, reset_route = 2'b11;

	assign front = ~current_state[0];
	assign rotate = current_state[0];

	always @(posedge clk) current_state <= future_state;

	always @(current_state or head or left) begin
		case (current_state)
			searching_wall:
				case ({head, left})
					2'b01: future_state = following_wall;
					2'b10: future_state = rotating;
					2'b11: future_state = rotating;
				endcase
			following_wall:
				case ({head, left})
					2'b00: future_state = reset_route;
					2'b01: future_state = following_wall;
					2'b10: future_state = reset_route;
					2'b11: future_state = rotating;
				endcase
			rotating:
				case ({head, left})
					2'b00: future_state = rotating;
					2'b01: future_state = following_wall;
					2'b10: future_state = rotating;
					2'b11: future_state = rotating;
				endcase
			default: future_state = searching_wall;
		endcase
	end
endmodule
