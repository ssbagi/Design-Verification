//`timescale 1ns/1ns
module simple_processor_testbench_mvi ();
reg Run, Resetn, Clock;
reg [8:0] DIN;
wire [8:0] Bus;
wire Done;

simple_processor_Top T2 (Run,Resetn,Clock,DIN,Bus,Done);

initial
Clock = 1'b1;

always #5 Clock = ~Clock;

initial 
begin

$set_toggle_region(simple_processor_testbench_mvi.T2);
$toggle_start();
// ...

Resetn = 1'b0;
#10 Resetn = 1'b1;
Run = 1'b1;

DIN = 9'b011000001; // mvi operation
#20 DIN = 9'b111001111; // immediate data
//R0 is loaded with 111001111;
#5;

#20 DIN = 9'b011010001; // mvi operation
#20 DIN = 9'b111111111; // immediate data after 50ns from 1st instuction @t=10
// R2 is loaded with 111111111;

#30 DIN = 9'b011001001; // mvi operation
#20 DIN = 9'b101010101; // immediate data
//R1 is loaded with 101010101;
#5;

#30 DIN = 9'b011011001; // mvi operation
#20 DIN = 9'b101010111; // immediate data
//R3 is loaded with 101010101;
#5;

#30 DIN = 9'b011100001; // mvi operation
#20 DIN = 9'b111101111; // immediate data
//R4 is loaded with 101010101;
#5;

#30 DIN = 9'b011101001; // mvi operation
#20 DIN = 9'b110110110; // immediate data
//R5 is loaded with 101010101;
#5;

#30 DIN = 9'b011110001; // mvi operation
#20 DIN = 9'b111011011; // immediate data
//R6 is loaded with 101010101;
#5;

#30 DIN = 9'b011111001; // mvi operation
#20 DIN = 9'b111111111; // immediate data
//R7 is loaded with 101010101;

// ...
$toggle_stop();
$toggle_report("Simple_Processor_SAIF_Move_Immediate_Operation.saif", 1.0e-12, "simple_processor_testbench_mvi");
#5; $stop;

Run = 1'b0;
end

initial
 begin

/*
// mvi R1,R5
#2 DIN = 9'b011001010; // mvi operation
#30 DIN = 9'b111001111; // immediate data
Run = 0;
#10 Run = 1;
DIN = 9'b000001010;
#1000 $stop;
*/

end 	
endmodule



