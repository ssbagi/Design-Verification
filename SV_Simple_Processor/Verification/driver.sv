class driver;
mailbox mbx;
transaction t;
virtual simple_processor_intf vif;
event done;
bit[8:0] temp;
bit[2:0] opcode;

covergroup CovPort;
 coverpoint t.DIN;
 //coverpoint t.Bus;
endgroup

function new (virtual simple_processor_intf vif, mailbox mbx);
this.mbx = mbx;
this.vif = vif;
CovPort = new();
endfunction
 
task main();

forever begin
t = new();

//@(posedge vif.clk);
mbx.get(t);
$display("Time=%0t,[DRV] : Rcvd Data from Generator",$time);
t.print(t.DIN);
$display("[DRV] :--------------- INTERFACE TRIGGER ----------------------");
vif.DIN = t.DIN;
temp = t.DIN;
opcode = temp[8:6];
CovPort.sample();
->done;	
end
endtask
endclass