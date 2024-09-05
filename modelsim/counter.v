module counter #(
    parameter clk_frequency = 1
) (
    initial_clk,
    clk
);
    input initial_clk;
    output reg clk;

    reg [2:0] counter = 3'b000;

    always @(posedge initial_clk) begin
        if (counter < clk_frequency - 1) begin
            counter <= counter + 1;
            clk <= 0;
        end else begin
            counter <= 0;
            clk <= ~clk;
        end
    end
endmodule
