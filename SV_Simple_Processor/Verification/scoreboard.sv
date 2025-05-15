class scoreboard;
mailbox mon2sco;
transaction t;
virtual simple_processor_intf vif;
event done;
bit [2:0] opcode;

 
function new(virtual simple_processor_intf vif,mailbox mon2sco);
this.mon2sco = mon2sco;
this.vif = vif;
endfunction
 

task run();



forever 
begin
t = new();
mon2sco.get(t);
opcode = t.DIN[8:6];

if (opcode == 3'b011) 
begin
#10;
if(t.Done == 1'b1)
begin
$display("Time=%0t [SCOREBOARD] -------------------------------------MOVE IMMEDIATE DATA DONE",$time);
t.print(t.DIN);
$display("Time=%0t [SCOREBOARD] BUS CONTENTS = %b",$time,t.Bus);
MVI_DONE : assert (t.Bus == t.temp_mvi)
		begin
		$display("Time=%0t [SCOREBOARD]---------------------------------MOVE IMMEDIATE DATA DONE",$time);
		$display("Time=%0t [SCOREBOARD] MOVE IMMEDIATE DATA DONE PASS---MOVE IMMEDIATE DATA DONE PASS---",$time);
		end
end
end

else if (opcode == 3'b000)
begin
//@(negedge vif.Clock);
if(t.Done == 1'b1)
begin
$display("Time=%0t  [SCOREBOARD] -----------------------------------MOVE OPERATION DONE",$time);
t.print(t.DIN);
$display("Time=%0t [SCOREBOARD] BUS CONTENTS = %b",$time,t.Bus);
MV_DONE :assert (t.Bus == t.temp_mv)
		begin 
		$display("Time=%0t [SCOREBOARD]---------------------------------MOVE OPERATION DATA DONE",$time);
		$display("Time=%0t [SCOREBOARD] MOVE OPERATION DONE PASS --- MOVE OPERATION  DONE PASS---",$time);
		end
end
end

else if (opcode == 3'b001)
begin
if(t.Done == 1'b1)
begin
$display("Time=%0t  [SCOREBOARD] -----------------------------------ADDITION OPERATION DONE",$time);
t.print(t.DIN);
$display("Time=%0t [SCOREBOARD] BUS CONTENTS = %b",$time,t.Bus);
ADD_DONE :assert (t.Bus == t.temp_add_res) 
		begin
		$display("Time=%0t [SCOREBOARD]---------------------------------ADDITION OPERATION DONE",$time);
		$display("Time=%0t [SCOREBOARD] ADDITION OPERATION DONE PASS --- ADDITION OPERATION DONE PASS ---",$time);
		end
end
end

else if (opcode == 3'b010)
begin

if(t.Done == 1'b1)
begin
$display("Time=%0t  [SCOREBOARD] ----------------------------------SUBTRACTION OPERATION DONE",$time);
t.print(t.DIN);
$display("Time=%0t [SCOREBOARD] BUS CONTENTS = %b",$time,t.Bus);
SUB_DONE :assert (t.Bus == t.temp_sub_res) 
		begin
		$display("Time=%0t [SCOREBOARD]---------------------------------SUBTRACTION OPERATION DONE",$time);
		$display("Time=%0t [SCOREBOARD] SUBTRACTION OPERATION DONE PASS---SUBTRACTION OPERATION DONE PASS---",$time);
		end
end
end

else
begin 
$display("Time=%0t OPCODE OPERATION NOT ENCODED FROM 100 to 111",$time);
end

/*

if (opcode == 3'b011) 
begin
#10;
if(t.Done == 1'b1)
begin
$display($time,"--------------------------------------------MOVE IMMEDIATE DATA DONE");
t.print(t.DIN);
$display($time,"---- BUS CONTENTS = %b",t.Bus);
end
end

else if (opcode == 3'b000)
begin
if(t.Done == 1'b1)
begin
$display($time,"--------------------------------------------MOVE OPERATION DONE");
t.print(t.DIN);
$display($time,"---- BUS CONTENTS = %b",t.Bus);
end
end

else if (opcode == 3'b001)
begin
if(t.Done == 1'b1)
begin
$display($time,"--------------------------------------------ADD OPERATION DONE");
t.print(t.DIN);
$display($time,"---- BUS CONTENTS = %b",t.Bus);
end
end

else if (opcode == 3'b010)
begin
if(t.Done == 1'b1)
begin
$display($time,"--------------------------------------------SUB OPERATION DONE");
t.print(t.DIN);
$display($time,"---- BUS CONTENTS = %b",t.Bus);
end
end

else
begin 
$display($time,"OPCODE OPERATION NOT ENCODED FROM 100 to 111");
end
*/
@(done);
end
endtask
endclass









/*
task run();

forever 
begin
mon2sco.get(t);
 
if(t.wr == 1'b1) begin
  if(tarr[t.addr] == null) begin
     tarr[t.addr] = new();
     tarr[t.addr] = t;
     $display("[SCO] : Data stored");
     end
    end
 else begin
   if(tarr[t.addr] == null) begin
     if(t.dout == 0) 
       $display("[SCO] : Data read Test Passed");
     else
       $display("[SCO] : Data read Test Failed"); 
    end
    else begin
      if(t.dout == tarr[t.addr].din)
       $display("[SCO] : Data read Test Passed");
       else
       $display("[SCO] : Data read Test Failed"); 
    end
    end
end
endtask
endclass


class scoreboard;
mailbox mbx;
transaction t;
bit [8:0] temp;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task main();
t = new();
forever begin
mbx.get(t);
temp = t.a + t.b;
if(t.sum == temp)
begin
$display("[SCO] :Test Passed");
end
else
begin
$display("[SCO] :Test Failed");
end
#10;
end
endtask
endclass

*/