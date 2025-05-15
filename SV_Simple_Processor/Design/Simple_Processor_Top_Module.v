`timescale 1ns/1ns
`include "controllerpath.v"
`include "Datapath.v"
`include "Decoders.v"
module simple_processor_Top(Run, Resetn, Clock,DIN,Bus,Done);
input Run, Resetn, Clock;
input [8:0] DIN;
output [8:0] Bus;
output Done;

wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, LdR0, LdR1, LdR2, LdR3, LdR4, LdR5, LdR6, LdR7, LdA, LdG, Add_sub;

controller G1_Controller (DIN, Run, Resetn, Clock, Done, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, LdR0, LdR1, LdR2, LdR3, LdR4, LdR5, LdR6, LdR7, LdA, LdG, Add_sub);

datapath G2_Datapath (R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, Clock, Resetn, LdR0, LdR1, LdR2, LdR3, LdR4, LdR5, LdR6, LdR7, LdA, Bus, DIN, Add_sub, LdG);

endmodule
