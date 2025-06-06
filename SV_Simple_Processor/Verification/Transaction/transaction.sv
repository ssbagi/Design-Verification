//module trans_check();

class transaction;
 
  //declaring the transaction items
  randc bit [8:0] DIN;
  bit [8:0] Bus;
  bit Done;
  bit [8:0] temp_add_res,temp_sub_res,temp_mvi,temp_mv;
  
  /*
  The Below constraints used to generate a specific Condition.
  DIN[8:0] : 9-bit Instruction Input for the Simple Processor.
  IIIXXXYYY
  8|7|6		: Instruction Opcode Generation. [mv|mvi|add|sub]
  5|4|3		: 8 Registers. Namely from R0 to R7.
  2|1|0		: 8 Registers. Namely from R0 to R7.
  */
	
  constraint din {DIN[8:6] >= 3'd0;DIN[8:6] < 3'd1;DIN[5:3]>= 3'd0;DIN[5:3]<= 3'd7;DIN[2:0]>= 3'd0;DIN[2:0]<= 3'd7;}
  //constraint run {Run > 1'd0;Run<2'd2;}

  function automatic new();
	this.DIN <= DIN;
 endfunction

  function automatic void print (bit [8:0] DIN);
  	this.DIN <= DIN;
  	$display("Time=%0t --  DIN=%b_%b_%b  --",$time,DIN[8:6],DIN[5:3],DIN[2:0]);
  endfunction
  
endclass


/*
initial
	begin
		transaction trans;
		trans = new();
		
		for (int i =0; i <8; i++)
		begin
		#5 if(trans.randomize())
			trans.print (trans.DIN);
		
		end
	end
endmodule
*/






