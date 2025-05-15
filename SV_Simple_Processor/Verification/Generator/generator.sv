class generator;
transaction t;
mailbox mbx;
virtual simple_processor_intf vif;
event done;
integer i;
bit[8:0] temp;
bit[2:0] opcode;
 
function new(virtual simple_processor_intf vif,mailbox mbx);
this.mbx = mbx;
this.vif = vif;
endfunction
 
task main();

for(i = 0; i <4; i++)
begin
t = new();
t.randomize();
mbx.put(t);
$display("*******************************************************************************************************************************");
$display("Generating Sequence %04d",i+3);
$display("Time=%0t [GEN] :  Send Data to Driver",$time);
t.print(t.DIN);
temp = t.DIN;
opcode = temp[8:6];

if (opcode == 3'b011)
begin
$display("[GEN] MOVE IMMEDIATE OPCODE GENERATED");
$display("Time=%0t--------------------------------------------[GEN] MOVE IMMEDIATE OPCODE GENERATED",$time);
@(negedge vif.Clock);
@(negedge vif.Clock);
t.randomize();
mbx.put(t);
$display("[GEN] MOVE IMMEDIATE DATA GENERATED");
$display("Time=%0t--------------------------------------------[GEN] MOVE IMMEDIATE DATA GENERATED",$time);
t.print(t.DIN);
continue;
end

else if (opcode == 3'b000)
begin
$display("MOVE OPERATION GENERATED");
$display("Time=%0t--------------------------------------------MOVE OPERATION GENERATED",$time);
@(negedge vif.Clock);
@(negedge vif.Clock);
end

else if (opcode == 3'b001)
begin
$display("ADD OPERATION GENERATED");
$display("Time=%0t--------------------------------------------ADD OPERATION GENERATED",$time);
@(negedge vif.Clock);
@(negedge vif.Clock);
@(negedge vif.Clock);
@(negedge vif.Clock);
end

else if (opcode == 3'b010)
begin
$display("SUBTRACTION OPERATION GENERATED");
$display("Time=%0t--------------------------------------------SUBTRACTION OPERATION GENERATED",$time);
@(negedge vif.Clock);
@(negedge vif.Clock);
@(negedge vif.Clock);
@(negedge vif.Clock);
end

else
begin 
$display(" OPCODE OPERATION NOT ENCODED FROM 100 to 111");
@(negedge vif.Clock);
end
->done;
end

endtask
endclass