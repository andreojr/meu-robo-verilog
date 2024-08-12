`include "modules/mealy.v"
`include "modules/counter.v"

module main #(parameter clk_frequency = 1) (initial_clk, clk, head, left, front, rotate);
    input initial_clk, clk, head, left;
    output front, rotate;

    counter #(clk_frequency) frequency(initial_clk, clk);
    mealy machine(clk, head, left, front, rotate);
endmodule