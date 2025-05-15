//`timescale 1ns/1ns
module simple_processor_testbench_mv_op ();
reg Run, Resetn, Clock;
reg [8:0] DIN;
wire [8:0] Bus;
wire Done;

simple_processor_Top T3 (Run,Resetn,Clock,DIN,Bus,Done);

initial
Clock = 1'b1;

always #5 Clock = ~Clock;

initial 
begin

$set_toggle_region(simple_processor_testbench_mv_op.T3);
$toggle_start();
// ...

Resetn = 1'b0;
#10 Resetn = 1'b1;
Run = 1'b1;

DIN = 9'b011_000_001; // mvi operation
#20 DIN = 9'b111_001_111; // immediate data
//R0 is loaded with 111001111;
#5;

#20 DIN = 9'b011_010_001; // mvi operation
#20 DIN = 9'b111_111_111; // immediate data after 50ns from 1st instuction @t=10
// R2 is loaded with 111111111;

#30 DIN = 9'b011_001_001; // mvi operation
#20 DIN = 9'b101_010_101; // immediate data
//R1 is loaded with 101010101;
#5;

#30 DIN = 9'b000_101_010;

#30 DIN = 9'b011_111_001; // mvi operation
#20 DIN = 9'b111_000_111; // immediate data
//R1 is loaded with 101010101;
#10 DIN = 9'b000_001_111;

// ...
$toggle_stop();
$toggle_report("Simple_Processor_SAIF_Move_Operation.saif", 1.0e-12, "simple_processor_testbench_mv_op");

#200 $stop;
end

endmodule


