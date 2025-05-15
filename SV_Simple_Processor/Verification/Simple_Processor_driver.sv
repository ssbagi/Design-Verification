class transaction;
 //declaring the transaction items
  rand bit [8:0] DIN;
  rand bit       Run;
  rand bit       Resetn;
  rand bit       Clock;
  rand bit [8:0] Bus;
  rand bit       Done;
  constraint din {DIN[8:6]> 3'd0;DIN[8:6]< 3'd4;DIN[5:3]> 3'd0;DIN[5:3]< 3'd7;DIN[2:0]>3'd0;DIN[2:0]< 3'd7;}

endclass

class driver;
   
  //used to count the number of transactions
  int no_transactions;
   
  //creating virtual interface handle
  virtual intf_proc vif_proc;
   
  //creating mailbox handle
  mailbox gen2driv;
   
  //constructor
  function new(virtual intf_proc vif_proc, mailbox gen2driv);
  //getting the interface
  this.vif_proc = vif_proc;
  //getting the mailbox handle from  environment
  this.gen2driv = gen2driv;
  endfunction
   
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vif_proc.reset);
    $display("--------- [DRIVER] Reset Started ---------");
    vif_proc.DIN <= 0;
    vif_proc.RUN <= 0;
    wait(!vif_proc.reset);
    vif_proc.RUN <= 1'b1;
    $display("--------- [DRIVER] Reset Ended---------");
  endtask
   
  //drive the transaction items to interface signals
  task drive;
      forever begin
      transaction trans;
      vif_proc.DIN <= 0;
      vif_proc.RUN <= 0;
      gen2driv.get(trans);
      $display("--------- [DRIVER-TRANSFER: %0d] ---------", no_transactions);
      @(posedge  vif_proc.DRIVER.clk)
      begin
	if(trans.DIN[8:6] == 3'b011)
		repeat(8)
		begin
      		vif_proc.DIN <= trans.DIN;
       		$display("\t MVI Operation Instruction DIN = %b", trans.DIN);
      		@(posedge vif_proc.DRIVER.clk); // 1 clock pulse delay
		@(posedge vif_proc.DRIVER.clk)
		begin
		gen2driv.get(trans);
		vif_proc.DIN <= trans.DIN;
		$display("\t MVI Operation Instruction DIN = %b", trans.DIN);
		end

		@(negedge vif_proc.DRIVER.clk);
		$display("\t MOVI IMMEDIATE DATA DIN = %b", trans.DIN);
      		$display("-----------------------------------------");
		end
	else if (trans.DIN[8:6] == 3'b000)
		begin
		@(posedge vif_proc.DRIVER.clk);
     		@(posedge vif_proc.DRIVER.clk)
		begin
		gen2driv.get(trans);
      		vif_proc.DIN <= trans.DIN;
       		$display("\t MOVE INSTRUCTION DIN = %b", trans.DIN);
		end
      		@(posedge vif_proc.DRIVER.clk);
     		@(posedge vif_proc.DRIVER.clk);
		@(negedge vif_proc.DRIVER.clk)
		$display("\t MOVE OPERATION Completed DIN = %b", trans.DIN);
      		$display("-----------------------------------------");
		end
	end
	no_transactions++;
end
endtask 
endclass

