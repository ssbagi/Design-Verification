`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "Simple_Processor_Top_Module.v"
`include "interface.sv"
module test();
 
transaction t;
generator gen;
driver drv;
mailbox mbx;

simple_processor_intf vif();
simple_processor_Top TOP (.Run(vif.Run), .Resetn(vif.Resetn), .Clock(vif.Clock),.DIN(vif.DIN),.Bus(vif.Bus),.Done(vif.Done));

initial 
begin
vif.Clock = 0;
vif.Resetn = 1'b0;
#10 vif.Resetn = 1'b1;
vif.Run = 1'b1;
end

always #5 vif.Clock = ~vif.Clock;
 
initial begin
mbx = new();
gen = new(mbx);
drv = new(vif,mbx);
drv.vif = vif; 
fork
gen.main();
drv.main();
join_any

wait(gen.done.triggered);
#10 $stop;
end
 
 
endmodule