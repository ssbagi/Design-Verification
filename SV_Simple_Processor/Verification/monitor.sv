//`include "transaction.sv"
class monitor;
mailbox mon2sco;
virtual simple_processor_intf vif;
transaction t;
logic Done;
bit [2:0] opcode;
event done; 


function new (virtual simple_processor_intf vif, mailbox mon2sco);
this.mon2sco = mon2sco;
this.vif = vif;
endfunction
 
task run();
t = new();
forever 
begin
t.DIN = vif.DIN;
t.Bus = vif.Bus;
t.Done = vif.Done;
opcode = vif.DIN[8:6];
#5;
mon2sco.put(t);
$display("Time=%0t [MON] :  data send to Scoreboard",$time);

if (opcode == 3'b011)
begin
$display("Time=%0t [DUT---MON] BUS LOADED WITH DIN :%b",$time,test.TOP.G2_Datapath.Bus);
#20;
t.temp_mvi = test.TOP.G2_Datapath.Bus;
$display("Time=%0t [DUT---MON] BUS LOADED WITH MOVE IMMEDIATE DATA :%b",$time,test.TOP.G2_Datapath.Bus);
end

else if (opcode == 3'b000)
begin
$display("Time=%0t [DUT---MON] BUS LOADED WITH DIN :%b",$time,test.TOP.G2_Datapath.Bus);
#15;
t.temp_mv = test.TOP.G2_Datapath.Bus;
$display("Time=%0t [DUT---MON] BUS LOADED WITH MOVE DATA :%b",$time,test.TOP.G2_Datapath.Bus);
end

else if (opcode == 3'b001)
begin
$display("Time=%0t [DUT---MON] BUS LOADED WITH DIN :%b",$time,test.TOP.G2_Datapath.Bus);
#35;
t.temp_add_res = test.TOP.G2_Datapath.Bus;
$display("Time=%0t [DUT---MON] BUS LOADED ADD RESULT DATA :%b",$time,test.TOP.G2_Datapath.Bus);
t.temp_add_res = test.TOP.G2_Datapath.Bus;
end

else if (opcode == 3'b010)
begin
$display("Time=%0t [DUT---MON] BUS LOADED WITH DIN :%b",$time,test.TOP.G2_Datapath.Bus);
#35;
t.temp_sub_res = test.TOP.G2_Datapath.Bus;
$display("Time=%0t [DUT---MON] BUS LOADED WITH SUB RESULT :%b",$time,test.TOP.G2_Datapath.Bus);
end

else
begin 
#40;
end
-> done;
end
endtask
endclass




