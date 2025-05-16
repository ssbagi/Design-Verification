# Coverage

The Coverage consists of : 

## Code coverage :
- To identify what code has been (and more importantly not been) executed in the design under verification.
- The objective of code coverage is to determine if you have forgotten to exercise some code in the design.
- How much of the implementation has been exercised.
  - Statement coverage or Block coverage :
    - Statement, line or block coverage measures how much of the total lines of code were executed by the verification suite. 
  - Path coverage :
    - To measure all possible ways you can execute a sequence of statements.
    - There is more than one way to execute a sequence of statements.
  - Expression coverage :
    - To measure the various ways decisions through the code are made.
  - FSM coverage :
    - Each state in an FSM is usually explicitly coded using a choice in a case statement, any unvisited state will be clearly identifiable through uncovered statements.
  - Branch coverage :
    - The type of code coverage that ensures every possible branch in the control flow of a program is executed at least once during testing.
    - This includes all if-else conditions, loops, and switch statements, making sure that both the "true" and "false" paths are tested.
    - It helps identify untested paths that could lead to unexpected behavior or bugs. 
  - Toggle coverage
    - To measure the percentage of signal transitions observed during simulation.
    - It helps ensure that all bits in a design toggle at least once, which is crucial for detecting potential issues like uninitialized signals or redundant logic.

## Functional coverage :
- Functional coverage records relevant metrics (e.g., packet length, instruction opcode, buffer occupancy level) to ensure that the verification process has exercised the design through all of the interesting values.
- How much of the original design specification has been exercised.


## Examples
//Example 1
class packet;
	rand bit[3:0] psel;
	rand bit[3:0] penable;
endclass

module coverage;
	packet p = new();
	covergroup cg;
      C1	: coverpoint p.sel{ bins b1[] = {0,1,2,3,4,8,9,11};}
      C2	: coverpoint p.penable{bins b2 = {[1:15]};}
	  CROSS : cross C1, C2;
    endgroup
  
	initial begin
		cg cg_inst = new();
		repeat(10) begin
			assert(p.randomize()) else $error("Randomization Failed");
			cg_inst.sample();
		end
	end
	
endmodule

//Example 2
class packet;
	rand bit[31:0] addr, data;
endclass

module tb();
	packet p;
	
	covergroup cg;
	    /*
		Vector Bins
		1. Dynamic.
		2. Fixed.
		*/
		Dynamic_C1 : coverpoint p.addr{
						bins b1[] = {1,58,95,125};
					}
			 
		Dynamic_C2 : coverpoint p.data{
						bins b2[] = {4,8,63,50:140};
					}
		
		Dynamic_C3 : coverpoint p.addr{
						bins b3[20] = {[1:$];};
					}
			
		Dynamic_C4 : coverpoint p.data{
						bins b4[20] = {[1:$];};
					}
			
		//Static Bins
		Static_5 : coverpoint p.addr{
						bins b5 = {1,58,95,125};
						bins b6 = {[1:$];}
					}
					
		Static_6 : coverpoint p.data{
						bins b7 = {4,8,63,50:140};
						bins b8 = {[1:$];}
					}
		
	endgroup
	cg cg_inst;
	
	initial begin
		p = new();
		cg_inst = new();
		repeat(2) begin
			assert(p.randomize()) else $error("Randomization Failed");
			cg_inst.sample();
		end
	end
	
endmodule




