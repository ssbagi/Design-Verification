`include "Simple_Processor_Top_Module.v"
module test_intf_DUT();

// Interface declaration
simple_processor_intf vif();

// DUT calling
simple_processor_Top TOP (.Run(vif.Run), .Resetn(vif.Resetn), .Clock(vif.Clock),.DIN(vif.DIN),.Bus(vif.Bus),.Done(vif.Done));

initial
begin
vif.Clock = 0;
vif.Resetn = 1'b0;
#10 vif.Resetn = 1'b1;
vif.Run = 1'b1;
#20 $stop;
end


initial
begin
vif.Resetn = 1'b0;
#10 vif.Resetn = 1'b1;
vif.Run = 1'b1;

vif.DIN = 9'b011_000_001; // mvi operation
#20 vif.DIN = 9'b111_001_111; // immediate data
//R0 is loaded with 111001111;
#5;

#20 vif.DIN = 9'b011_010_001; // mvi operation
#20 vif.DIN = 9'b111_111_111; // immediate data after 50ns from 1st instuction @t=10
// R2 is loaded with 111111111;

#30 vif.DIN = 9'b011_001_001; // mvi operation
#20 vif.DIN = 9'b101_010_101; // immediate data
//R1 is loaded with 101010101;
#5;

#30 vif.DIN = 9'b000_101_010;

#30 vif.DIN = 9'b011_111_001; // mvi operation
#20 vif.DIN = 9'b111_000_111; // immediate data
//R1 is loaded with 101010101;
#10 vif.DIN = 9'b000_001_111;

#20 $stop;
end


always #5  vif.Clock = ~vif.Clock;

endmodule