class transaction;
 //declaring the transaction items
  randc bit [8:0] DIN;
  randc bit       Run;
  bit [8:0] Bus;
  bit       Done;
endclass
  
class generator;
transaction t;
mailbox mbx;
event done;
integer i;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task main();
for(i = 0; i <10; i++)begin
t = new();
t.randomize();
mbx.put(t);
$display("[GEN] :  Send Data to Driver");
$display("DIN = %b_%b_%b",t.DIN[8:6],t.DIN[5:3],t.DIN[2:0]);
#1;
end
->done;
endtask
endclass
 
 
class driver;
mailbox mbx;
transaction t;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task main();
forever begin
t = new();
mbx.get(t);
$display("[DRV] : Rcvd Data from Generator");
$display("DIN = %b_%b_%b",t.DIN[8:6],t.DIN[5:3],t.DIN[2:0]);
#1;
end
endtask
 
 
endclass
 
 
 
 
 
module tb();
 
transaction t;
generator gen;
driver drv;
mailbox mbx;
 
initial begin
mbx = new();
gen = new(mbx);
drv = new(mbx);
 
fork
gen.main();
drv.main();
join_any
wait(gen.done.triggered);
end
 
 
endmodule