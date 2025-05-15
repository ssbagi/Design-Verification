interface simple_processor_intf();

logic Run, Resetn, Clock;
logic [8:0] DIN;
logic [8:0] Bus;
logic Done;

/*
//simple_processor_Top(Run, Resetn, Clock,DIN,Bus,Done);

input Run, Resetn, Clock;
input [8:0] DIN;
output [8:0] Bus;
output Done;
*/


endinterface

/*
module test_interface();
simple_processor_intf vif();
initial
begin
repeat(5)
begin
vif.DIN = $urandom;
vif.Run = $urandom;
$display($time," DIN=%b_%b_%b, Run = %b", vif.DIN[8:6],vif.DIN[5:3],vif.DIN[2:0],vif.Run);
#1;	
end
end
endmodule
*/