//`timescale 1ns/1ns
module simple_processor_testbench_add_op();
reg Run, Resetn, Clock;
reg [8:0] DIN;
wire [8:0] Bus;
wire Done;
simple_processor_Top T1 (Run,Resetn,Clock,DIN,Bus,Done);

initial
Clock = 1'b1;

always #5 Clock = ~Clock;

initial 
begin
$set_toggle_region(simple_processor_testbench_add_op.T1);
$toggle_start();
// ...

Resetn = 1'b0;
#10 Resetn = 1'b1;
Run = 1'b1;

DIN = 9'b011_000_001; // mvi operation
#20 DIN = 9'b100_001_111; // immediate data
//R0 is loaded with 111001111;
#5;


#20 DIN = 9'b011_010_001; // mvi operation
#20 DIN = 9'b111_110_000; // immediate data after 50ns from 1st instuction @t=10
// R2 is loaded with 111111111;


/*
#30 DIN = 9'b011_001_001; // mvi operation
#20 DIN = 9'b101_010_101; // immediate data
//R1 is loaded with 101010101;
*/

#40 DIN = 9'b001_000_010; // add R0+R2
#20 Run =0;

// ...
$toggle_stop();
$toggle_report("Simple_Processor_SAIF_ADD_Operation.saif", 1.0e-12, "simple_processor_testbench_add_op");

#0 $stop;
end
endmodule

