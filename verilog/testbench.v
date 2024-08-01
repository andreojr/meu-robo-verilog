`include "./verilog/design.v"

module testbench;
	reg clk, head, left;
  	wire front, rotate;
  
  	mealy_robot MR(clk, head, left, front, rotate);
  	
  	initial begin
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
        begin
            #1 clk = ~clk;
            #2 clk = ~clk;
        end
    endtask
 	
    task step (input h, l);
        begin
            head = h;
            left = l;
            toggle_clock;
        end  	
    endtask
  	  
    task display (string cs, fs);
        begin
            string out;
            case ({front, rotate})
                2'b10: out = "frente";
                2'b01: out = "rotaciona";
            endcase
            $display("%s | head: %b left: %b | %s | %s", cs, head, left, out, fs);
        end
    endtask
endmodule