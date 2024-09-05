module fsm_moore (
    clk,
    head,
    left,
    front,
    rotate
);
    // Definição de entadas e saídas
    input clk, head, left;
    output front, rotate;

    // Declaração e definição de estados
    parameter searching_wall = 2'b00, following_wall = 2'b01, rotating = 2'b10, reset_route = 2'b11;
    reg [1:0] current_state, future_state;

    // Atualização de estado
    always @(posedge clk) current_state <= future_state;

    // Decodificador de saída
    assign front  = ~future_state[1];  // F = !Q0
    assign rotate = future_state[1];  // R = Q0

    // Decodificador de próximo estado
    always @(current_state or head or left) begin
        case (current_state)
            searching_wall:
            case ({
                head, left
            })
                2'b00: future_state = searching_wall;
                2'b01: future_state = following_wall;
                2'b10: future_state = rotating;
                2'b11: future_state = rotating;
            endcase
            following_wall:
            case ({
                head, left
            })
                2'b00: future_state = reset_route;
                2'b01: future_state = following_wall;
                2'b10: future_state = reset_route;
                2'b11: future_state = rotating;
            endcase
            rotating:
            case ({
                head, left
            })
                2'b00: future_state = rotating;
                2'b01: future_state = following_wall;
                2'b10: future_state = rotating;
                2'b11: future_state = rotating;
            endcase
            default:
            case ({
                head, left
            })
                2'b00: future_state = searching_wall;
                2'b01: future_state = following_wall;
                2'b10: future_state = rotating;
                2'b11: future_state = rotating;
            endcase
        endcase
    end
endmodule
