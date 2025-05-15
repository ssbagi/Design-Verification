`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "Simple_Processor_Top_Module.v"
`include "interface.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"
`timescale 1ns/1ns
module test();

environment e;
mailbox gdmbx, msmbx; 
simple_processor_intf vif();
simple_processor_Top TOP (.Run(vif.Run), .Resetn(vif.Resetn), .Clock(vif.Clock),.DIN(vif.DIN),.Bus(vif.Bus),.Done(vif.Done));

/*
logic ENB;
logic [2:0] INSTR;

always_ff @(posedge vif.Clock) 
begin 
INSTR = vif.DIN[8:6];
ENB = (!(INSTR[2]&INSTR[1]&INSTR[0]))|((!(INSTR[2]))&INSTR[1]&(!(INSTR[0])))|((!(INSTR[2]))&(!(INSTR[1]))&INSTR[0])|((!(INSTR[2]))&INSTR[1]&INSTR[0]);
end

property INSTR_OP;
 @(posedge vif.Clock) ENB |-> ##[2:4] vif.Done;
endproperty:INSTR_OP 


INSTR_ASSERT : assert property (INSTR_OP)
		begin
		$display($time,"INSTRUCTION EXECUTED");
		case(INSTR)
		3'b000 : $display($time, "----MOVE INSTRUCTION EXECUTED----");
		3'b011 : $display($time, "----MOVE IMMEDIATE INSTRUCTION EXECUTED----");
		3'b001 : $display($time, "----ADDITION    INSTRUCTION EXECUTED----");
		3'b010 : $display($time, "----SUBTRACTION INSTRUCTION EXECUTED----");
		default : $display($time,"----DATA LOADED TO DIN----");
		endcase
		end
      	       else
		;

*/

logic ENB_MV,ENB_MVI,ENB_ADD,ENB_SUB;
logic [2:0] INSTR;

always @(posedge vif.Clock) 
begin 
INSTR  = vif.DIN[8:6];
ENB_MV  = (!(INSTR[2]     & INSTR[1]      & INSTR[0]));
ENB_MVI = ((!(INSTR[2]))  & (INSTR[1])    & INSTR[0]);
ENB_ADD = ((!(INSTR[2]))  & (!(INSTR[1])) & INSTR[0]);
ENB_SUB = ((!(INSTR[2]))  & INSTR[1]      & (!(INSTR[0])));
end

property INSTR_OP_MV;
 @(posedge vif.Clock) ENB_MV  |-> ##2 $rose(vif.Done);
endproperty:INSTR_OP_MV

property INSTR_OP_MVI; 
 @(posedge vif.Clock) ENB_MVI |-> ##2 $rose(vif.Done);
endproperty:INSTR_OP_MVI

property INSTR_OP_ADD;
 @(posedge vif.Clock) ENB_ADD |-> ##4 $rose(vif.Done);
endproperty:INSTR_OP_ADD

property INSTR_OP_SUB;
 @(posedge vif.Clock) ENB_SUB |-> ##4 $rose(vif.Done);
endproperty:INSTR_OP_SUB


INSTR_ASSERT_MV : assert property (INSTR_OP_MV)
		 begin
		 $display($time,"INSTRUCTION EXECUTED");
		 case(INSTR)
		 3'b000  : $display($time, "----MOVE INSTRUCTION EXECUTED----");
		 default : $display($time,"----DATA LOADED TO DIN----");
		 endcase
		 end
      	        else
		 ;

INSTR_ASSERT_MVI : assert property (INSTR_OP_MVI)
		 begin
		 $display($time,"INSTRUCTION EXECUTED");
		 case(INSTR)
		 3'b011  : $display($time, "----MOVE IMMEDIATE INSTRUCTION EXECUTED----");
		 default : $display($time,"----DATA LOADED TO DIN----");
		 endcase
		 end
      	        else
		 ;

INSTR_ASSERT_ADD : assert property (INSTR_OP_ADD)
		 begin
		 $display($time,"INSTRUCTION EXECUTED");
		 case(INSTR)
		 3'b001  : $display($time, "----ADD INSTRUCTION EXECUTED----");
		 default : $display($time,"----DATA LOADED TO DIN----");
		 endcase
		 end
      	        else
		 ;

INSTR_ASSERT_SUB : assert property (INSTR_OP_SUB)
		 begin
		 $display($time,"INSTRUCTION EXECUTED");
		 case(INSTR)
		 3'b010  : $display($time, "----SUB INSTRUCTION EXECUTED----");
		 default : $display($time,"----DATA LOADED TO DIN----");
		 endcase
		 end
      	        else
		 ;

initial 
begin
vif.Resetn = 1'b0;
vif.Clock = 0;
#10 vif.Resetn = 1'b1;
vif.Run = 1'b1;
end

always #5 vif.Clock = ~vif.Clock;
 
initial 
begin

vif.DIN = 9'b011000001; // mvi operation
#20 vif.DIN = 9'b111001111; // immediate data
//R0 is loaded with 111001111;
#5;

#20 vif.DIN = 9'b011010001; // mvi operation
#20 vif.DIN = 9'b111111111; // immediate data after 50ns from 1st instuction @t=10
// R2 is loaded with 111111111;

#30 vif.DIN = 9'b011001001; // mvi operation
#20 vif.DIN = 9'b101010101; // immediate data
//R1 is loaded with 101010101;
#5;

#30 vif.DIN = 9'b011011001; // mvi operation
#20 vif.DIN = 9'b101010111; // immediate data
//R3 is loaded with 101010101;
#5;

#30 vif.DIN = 9'b011100001; // mvi operation
#20 vif.DIN = 9'b111101111; // immediate data
//R4 is loaded with 101010101;
#5;

#30 vif.DIN = 9'b011101001; // mvi operation
#20 vif.DIN = 9'b110110110; // immediate data
//R5 is loaded with 101010101;
#5;

#30 vif.DIN = 9'b011110001; // mvi operation
#20 vif.DIN = 9'b111011011; // immediate data
//R6 is loaded with 101010101;
#5;

#30 vif.DIN = 9'b011111001; // mvi operation
#20 vif.DIN = 9'b111111111; // immediate data
//R7 is loaded with 101010101;

#30 vif.DIN = 9'b111111111;
#30 vif.DIN = 9'b111000000;
#30 vif.DIN = 9'b111011001;
$display("---- START RANDOMIZATION ---- START RANDOMIZATION ----  START RANDOMIZATION ---- START RANDOMIZATION ---- ");
vif.Run = 1'b1;
gdmbx = new();
msmbx = new();
e = new(gdmbx,msmbx,vif);
e.vif = vif;
e.main();
#50; 
$display("----STOP----STOP----STOP----STOP----STOP----STOP---");
$stop;
end
endmodule
