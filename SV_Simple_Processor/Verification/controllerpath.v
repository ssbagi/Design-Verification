//`timescale 1ns/1ns
//`include "Decoders.v"
module controller (DIN, Run, Resetn, Clock, Done, R0out, R1out, R2out, R3out, R4out, R5out, 
R6out, R7out, Gout, DINout, LdR0, LdR1, LdR2, LdR3, LdR4, LdR5, LdR6, LdR7, LdA, LdG, Add_sub);
input Run, Resetn, Clock;
input [8:0] DIN;
output reg LdR0, LdR1, LdR2, LdR3, LdR4, LdR5, LdR6, LdR7, LdA, LdG, Add_sub; 
output reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, Done, DINout;
wire [9:0] Xreg, Yreg;
reg [9:0] Sel; //output DINout
reg [3:0] PS,NS;
reg [8:0] IR; // Instruction Register
// One - hot Encoding
localparam T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0100, T3 = 4'b1000; //One hot Encoding
localparam mv = 3'b000, add = 3'b001, sub = 3'b010, mvi = 3'b011;
reg IRin;
// T0 is for loading state
// If mv instruction then go T1 and RYout and LdRx enabled Control signals go high
// [8:0] IR
// [8,7,6] IR ------> Opcode
// [5,4,3] IR ------> RX 
// [2,1,0] IR ------> RY

wire [2:0] opcode_decoded;
reg [2:0] opcode;


// add R1,R2
//001 001 010 ----> Din at Time t=0
// State is in T0
//opcode = Data_reg [8:6];

dec3to8 Z1 (IR[5:3],Xreg); // RX register -----> Xreg is Destination Register 
dec3to8 Z2 (IR[2:0],Yreg); // RY register -----> Yreg is Source Register
dec3to8_3bit Z3 (IR[8:6], opcode_decoded); // Opcode decoding


// Current State Logic Generation 
always @(posedge Clock)
begin
if(Resetn)
PS <= NS;
else
PS <= T0;
end


always @(posedge Clock)
begin
if(IRin)
opcode <= opcode_decoded;
else
opcode <= opcode;
end

// Next State Generation Logic
always @(PS,Run,Done) // removed Run or Done signal in senstivity list.
begin
case(PS) // Use only Blocking statements.
T0: NS = Run? T1:T0;  

T1: begin   // Destination Register Load Signal.
	case(opcode)
		mv   : NS =T0; // Change go back to stage T0 not to be in T1.
 		add  : NS =T2;
		sub  : NS =T2;
   		mvi  : NS = T2;
		default :NS = T0;
    	 endcase
       end
	
T2:begin  // Source Register Load Signal.
	case(opcode)
 		add  :  NS=T3;
		sub  :  NS=T3;
   		mvi  :  NS = T0;
		default : NS = T0;
    	endcase
       end
     
 T3:begin  // Source Register Load Signal.
	case(opcode)
 		add  : NS=T0;
		sub  :  NS=T0;
		default : NS = T0;
    	endcase
       end
default : NS = T0;
endcase
end


// Output Generation always block that is Control Signal Generation Logic
always @(PS)
begin
case(PS) // USe only Blocking statements.
T0: begin 
       // Initial Reset all the Load Signals
       LdR0 = 0; LdR1 = 0; LdR2 = 0; LdR3 = 0; LdR4 =0;  LdR5 = 0;  LdR6 = 0;  LdR7 = 0;LdA = 0; LdG =0;
       IRin = 1;    
       if(!Run)
	      begin
	        Done = 0;
	     end
            else
      		begin
      		IR   = DIN;
		Done = 0;
		end
      end	  
T1: begin   // Destination Register Load Signal.
	IRin = 0;
      if (opcode == mv)
      begin
      // Ryout corresponding Reg should be high
      // Rx in corresponding Reg should be high
      // Done 1
      // mv R1,R2   R1<----- R2
      Sel = Yreg;
     {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel; 
     {LdR0,LdR1,LdR2,LdR3,LdR4,LdR5,LdR6,LdR7} = Xreg[9:2];
	// changed to reg from sel
       Done = 1;
      end
 
     else if(opcode == add)
      begin
      // Ryout corresponding Reg should be high
      // Rx in corresponding Reg should be high
      // Done 1
      // add R1,R2   R1<----R1+R2
      Sel = Xreg;
      {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
      LdA = 1;
      LdG = 0;
     // A = BusWires;
      Add_sub = 0; // 0 for add
      end
      
     else if(opcode == sub)
     begin
      Sel = Xreg;
      {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
      LdA = 1;
      LdG = 0;
      //A <= BusWires;
      Add_sub = 1; // 1 for sub
     end
     
     else if(opcode == mvi)
     begin
     Sel = 10'b0000000001; // Sel = Din out
    {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
    {LdR0,LdR1,LdR2,LdR3,LdR4,LdR5,LdR6,LdR7} = Xreg[9:2];
    
    end
    end
	
T2:begin  // Source Register Load Signal.
	//IRin = 0;
	  if(opcode == add)
      begin
      Sel = Yreg;
      {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
      LdA = 0;
      LdG = 1;
      //G = Z; // Z is result of addition from the adder block;
      end

      else if(opcode == mvi)
      begin
      Sel = 10'b0000000001; // Sel = Din out
      {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
      {LdR0,LdR1,LdR2,LdR3,LdR4,LdR5,LdR6,LdR7} = Xreg[9:2];
      Done = 1;
      end

     else if(opcode == sub)
     begin
      Sel = Yreg;
      {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
      LdA = 0;
      LdG = 1;
     end
	 end

T3: begin
	//IRin = 0;
      if(opcode == add)
      begin
      Done = 1;
      Sel=10'b0000000010; // Data from G Register to Destination Register. Gout=1
      {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
	  {LdR0,LdR1,LdR2,LdR3,LdR4,LdR5,LdR6,LdR7} = Xreg[9:2];

      end

     else if(opcode == sub)
     begin
     Done = 1;
     Sel=10'b0000000010; // Data from G Register to Destination Register.
     {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout} = Sel;
	 {LdR0,LdR1,LdR2,LdR3,LdR4,LdR5,LdR6,LdR7} = Xreg[9:2];

     end
     end
default : begin //IRin = 0; 
	  end
endcase
end

endmodule

/*
module dec3to8 (W, Y);
input [2:0] W;
output reg [9:0] Y;

always @(W)
begin
case (W)
3'b000: Y = 10'b1000000000;
3'b001: Y = 10'b0100000000;
3'b010: Y = 10'b0010000000;
3'b011: Y = 10'b0001000000;
3'b100: Y = 10'b0000100000;
3'b101: Y = 10'b0000010000;
3'b110: Y = 10'b0000001000;
3'b111: Y = 10'b0000000100;
//3'b1000: Y = 10'b0000000010;
endcase
end
endmodule


module dec3to8_3bit (W, Y);
input [2:0] W;
output reg [2:0] Y;

always @(W)
begin
case (W)
3'b000: Y = 3'b000;
3'b001: Y = 3'b001;
3'b010: Y = 3'b010;
3'b011: Y = 3'b011;
3'b100: Y = 3'b100;
3'b101: Y = 3'b101;
3'b110: Y = 3'b110;
3'b111: Y = 3'b111;
default: Y = 3'b000;
endcase
end
endmodule
*/

//*****************************************************************************************//
// ******************************************************************************************/


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////  TESTBENCH /////////////////////////// TESTBENCH /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
module testbench_control_copy_new ();

reg Run, Resetn, Clock;
reg [8:0] DIN;
wire LdR0, LdR1, LdR2, LdR3, LdR4, LdR5, LdR6, LdR7, LdA, LdG, Add_Sub;
wire IRin, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, Done;

controller_new G1 (DIN, Run, Resetn,  Clock, Done, IRin, R0out, R1out, R2out, R3out, R4out, R5out, R6out, 
R7out, Gout, DINout, LdR0, LdR1, LdR2, LdR3, LdR4, LdR5, LdR6, LdR7, LdA, LdG, Add_Sub);

initial
 begin
 Clock  = 1'b0;
 Resetn = 1'b1;
 Run = 0;
#1 Run = 1;
 end
 
always #5  Clock = ~ Clock;

initial
 begin

// mv R1,R2
 //#1 DIN = 9'b000001010; 

//add R3,R4
#1 DIN = 9'b001011100; 

// sub R6,R7
//#1 DIN = 9'b010110111;

// mvi R5,XXX
// 0X010100101
//#1 DIN = 9'b011101111;
//#14 DIN = 9'b0_1010_0101;
#50 Run = 0;
end
endmodule

*/


