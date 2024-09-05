module fsm_mealy (
    clk,
    head,
    left,
    front,
    rotate
);
    // Definição de entradas e saídas
    input clk, head, left;
    output reg front, rotate;

    // Definição e declaração de estados
    parameter searching_wall = 2'b00, following_wall = 2'b01, rotating = 2'b10;
    reg [1:0] current_state, future_state;

    // Atualização de estado
    always @(posedge clk) current_state <= future_state;

    // Decodificador de próximo estado e de saída
    always @(current_state or head or left) begin
        // Atribuições default
        case ({
            head, left
        })
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

        // Decodificador de próximo estado
        case (current_state)
            searching_wall:
            case ({
                head, left
            })
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
            case ({
                head, left
            })
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
            case ({
                head, left
            })
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
        endcase
    end
endmodule
