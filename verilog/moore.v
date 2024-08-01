module moore_robot(clk, head, left, front, rotate);
	input clk, head, left;
	output front, rotate;

	reg [1:0] current_state, future_state;

	parameter searching_wall = 2'b00,
			following_wall = 2'b01,
			rotating = 2'b10,
			reset_route = 2'b11;

	assign front = ~current_state[0];
	assign rotate = current_state[0];

	always @(posedge clk)
	begin
		current_state <= future_state;
		case (future_state)
			searching_wall:
				case (current_state)
				searching_wall: display("PROCURANDO", "PROCURANDO");
				following_wall: display("SEGUINDO", "PROCURANDO");
				rotating: display("ROTACIONANDO", "PROCURANDO");
				reset_route: display("REDEFININDO", "PROCURANDO");
				endcase
			following_wall:
				case (current_state)
				searching_wall: display("PROCURANDO", "SEGUINDO");
				following_wall: display("SEGUINDO", "SEGUINDO");
				rotating: display("ROTACIONANDO", "SEGUINDO");
				reset_route: display("REDEFININDO", "SEGUINDO");
				endcase
			rotating:
				case (current_state)
				searching_wall: display("PROCURANDO", "ROTACIONANDO");
				following_wall: display("SEGUINDO", "ROTACIONANDO");
				rotating: display("ROTACIONANDO", "ROTACIONANDO");
				reset_route: display("REDEFININDO", "ROTACIONANDO");
				endcase
			reset_route:
				case (current_state)
				searching_wall: display("PROCURANDO", "REDEFININDO");
				following_wall: display("SEGUINDO", "REDEFININDO");
				rotating: display("ROTACIONANDO", "REDEFININDO");
				reset_route: display("REDEFININDO", "REDEFININDO");
				endcase
		endcase
	end

	always @(current_state or head or left) begin
		case (current_state)
			searching_wall:
				case ({head, left})
					2'b00: future_state = searching_wall;
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