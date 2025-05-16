//Example 1

class packet;
	rand bit\[3:0] psel;
	rand bit\[3:0] penable;
endclass

module coverage;
	packet p = new();
	covergroup cg;
      C1	: coverpoint p.sel{ bins b1[] = {0,1,2,3,4,8,9,11};}
      C2	: coverpoint p.penable{bins b2 = {\[1:15]};}
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
	rand bit\[31:0] addr, data;
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
