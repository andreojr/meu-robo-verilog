module moore #(
    parameter clk_frequency = 1
) (
    initial_clk,
    clk,
    head,
    left,
    front,
    rotate
);
    input initial_clk, clk, head, left;
    output front, rotate;

    counter #(clk_frequency) frequency (
        initial_clk,
        clk
    );
    fsm_moore machine (
        clk,
        head,
        left,
        front,
        rotate
    );
endmodule

module mealy #(
    parameter clk_frequency = 1
) (
    initial_clk,
    clk,
    head,
    left,
    front,
    rotate
);
    input initial_clk, clk, head, left;
    output front, rotate;

    counter #(clk_frequency) frequency (
        initial_clk,
        clk
    );
    fsm_mealy machine (
        clk,
        head,
        left,
        front,
        rotate
    );
endmodule
