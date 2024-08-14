`include "design.v"

module testbench;
	reg initial_clk, clk, head, left;
  wire front, rotate;

  parameter clk_frequency = 7; // Maior número da matrícula (223116037)

  main #(clk_frequency) main(initial_clk, clk, head, left, front, rotate);

  always #1 initial_clk <= ~initial_clk;
  
  initial begin
    initial_clk = 0;
    clk = 0;
    step(0,0);
    step(0,0);
    step(1,0);
    step(0,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,1);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(1,0);
    step(0,0);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,1);
    step(0,0);
    step(0,0);
    step(0,1);
    step(0,0);
    step(0,0);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,1);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,1);
    step(0,0);
    step(0,0);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,0);
    step(0,0);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,1);
    step(0,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,1);
    step(0,0);
    step(0,0);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    step(0,1);
    step(0,1);
    step(1,1);
    step(1,0);
    step(0,0);
    step(0,1);
    #1 $finish;
  end

  task step(input h, l); begin
    #(clk_frequency) begin
      head = h;
      left = l;
    end
    #(clk_frequency) display;
  end endtask
  	  
  task display;
    $display("head:%b,left:%b,front:%b,rotate:%b", head, left, front, rotate);
  endtask
endmodule
