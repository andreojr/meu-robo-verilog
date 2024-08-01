`include "./verilog/mealy.v"
`include "./verilog/moore.v"

module testbench;
	reg clk, head, left;
  	wire front, rotate;
  
  	moore_robot MR(clk, head, left, front, rotate);
  	
  	initial
    	begin
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
        end
  	
  	task toggle_clock;
      	#1 clk = ~clk;
    	#2 clk = ~clk;
    endtask
 	
  task step(input h, l);
    	head = h;
    	left = l;
    	toggle_clock;
    	display;
    endtask
  	  
  task display;
    $display("head:%b,left:%b,front:%b,rotate: %b", head, left, front, rotate);
  endtask
endmodule
