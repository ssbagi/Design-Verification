/*
File_Name : Data_path_work
revision: 2
Last_ Modified : 12/03/2021

*/
//`timescale 1ns/1ns

module datapath (R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, 
Clock,rst,R0in, R1in,R2in,R3in,R4in,R5in,R6in,R7in,Ain,Bus,DIN,AddSub,Gin);

input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, Clock,R0in, R1in,R2in,R3in,R4in,R5in,R6in,R7in,Ain,rst,AddSub,Gin;
input [8:0] DIN;
output [8:0] Bus;
wire [8:0] R0_data_out, R1_data_out, R2_data_out, R3_data_out, R4_data_out;
wire [8:0] R5_data_out, R6_data_out, R7_data_out, A_data_out, Sum,G;

mux_10to1 m1 (.R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out), .Gout(Gout), .DINout(DINout),.DIN(DIN), .R0(R0_data_out),.R1(R1_data_out), .R2(R2_data_out), .R3(R3_data_out), .R4(R4_data_out), .R5(R5_data_out),.R6(R6_data_out), .R7(R7_data_out), .G(G), .Bus(Bus)); //Priority Multiplexer

Add_Sub add_top (.A(A_data_out), .Bus(Bus), .AddSub(AddSub),.ALU_out(Sum)); //Add_Sub (Aout, Bus, AddSub,ALU_out);
reg_G g2 (.Sum(Sum),.Gin(Gin), .Clock(Clock), .rst(rst), .Z(G));

Register Reg0 (Clock, R0_data_out, Bus, R0in,rst);
Register Reg1 (Clock, R1_data_out, Bus, R1in,rst);
Register Reg2 (Clock, R2_data_out, Bus, R2in,rst);
Register Reg3 (Clock, R3_data_out, Bus, R3in,rst);
Register Reg4 (Clock, R4_data_out, Bus, R4in,rst);
Register Reg5 (Clock, R5_data_out, Bus, R5in,rst);
Register Reg6 (Clock, R6_data_out, Bus, R6in,rst);
Register Reg7 (Clock, R7_data_out, Bus, R7in,rst);
Register A5   (Clock, A_data_out,   Bus, Ain,rst);
endmodule


module mux_10to1 (R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, 
DIN, R0,R1, R2, R3, R4, R5,R6, R7, G, Bus);

input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout;
input [8:0] DIN, R0,R1, R2, R3, R4, R5,R6, R7, G;
output reg [8:0] Bus;
wire [9:0] sel; //selection line of mux_10to1

assign sel = {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout};
always @ (*)
 begin
   if (sel == 10'b0000000001)  
         Bus = DIN;  
    else if (sel == 10'b0000000010)  
         Bus = G;  
    else if (sel == 10'b0000000100)  
         Bus = R7;  
	else if (sel == 10'b0000001000)  
         Bus = R6; 
	else if (sel == 10'b0000010000)  
         Bus = R5; 
	else if (sel == 10'b0000100000)  
         Bus = R4; 
	else if (sel == 10'b0001000000)  
         Bus = R3; 
	else if (sel == 10'b0010000000)  
         Bus = R2; 
	else if (sel == 10'b0100000000)  
         Bus = R1; 
	else if (sel == 10'b1000000000)  
         Bus = R0; 
    else  
         Bus = Bus;
 end 
endmodule

//For register
module Register (Clock,dout,din,EN,rst);
input Clock;
input EN,rst;
input [8:0] din;
output reg [8:0] dout;

always @(posedge Clock)
begin
if(EN)
	dout <= din;
else if(~rst)
	dout <= 9'b0;
end
endmodule

//ADD_SUB
module Add_Sub (A, Bus, AddSub,ALU_out);
input [8:0] A, Bus;
input AddSub;
output [8:0] ALU_out;
wire [8:0] xrout;
wire Cout;

xor (xrout[0],Bus[0],AddSub), (xrout[1],Bus[1],AddSub), (xrout[2],Bus[2],AddSub), (xrout[3],Bus[3],AddSub),
      (xrout[4],Bus[4],AddSub), (xrout[5],Bus[5],AddSub), (xrout[6],Bus[6],AddSub), (xrout[7],Bus[7],AddSub),
      (xrout[8],Bus[8],AddSub);
csa_9bit add1 (.a(A), .b(xrout),.cin(AddSub) , .sum(ALU_out), .cout(Cout));

endmodule

module reg_G(Sum,Gin, Clock,rst, Z);
input Gin;
input [8:0] Sum;
input Clock, rst;
output reg [8:0] Z;
always @ (posedge Clock)
begin
if (~rst)
begin
Z <= 9'b0;
end

else
begin
if(Gin == 1)
Z <= Sum;
else
Z <= Z;
end
end
endmodule


module csa_9bit(a, b,cin, sum, cout); 
//In main module a= A, b= Bus , c= AddSub 
//module carry_select_adder_16bit(a, b, cin, sum, cout);
input [8:0] a,b;
input cin;
output [8:0] sum;
output cout;
 
wire [1:0] c;
 
//full adder
full_adder fa0(.a(a[0]),.b(b[0]),.cin(cin),.sum(sum[0]),.cout(c[0]));

carry_select_adder_4bit_slice csa_slice1(.a(a[4:1]),.b(b[4:1]),.cin(c[0]),.sum(sum[4:1]),.cout(c[1]));
carry_select_adder_4bit_slice csa_slice2(.a(a[8:5]),.b(b[8:5]),.cin(c[1]),.sum(sum[8:5]), .cout(cout));
 
endmodule
 
//////////////////////////////////////
//4-bit Carry Select Adder Slice
//////////////////////////////////////
 
module carry_select_adder_4bit_slice(a, b, cin, sum, cout);
input [3:0] a,b;
input cin;
output [3:0] sum;
output cout;
 
wire [3:0] s0,s1;
wire c0,c1;
 
ripple_carry_4_bit rca1(.a(a[3:0]),.b(b[3:0]),.cin(1'b0),.sum(s0[3:0]),.cout(c0));
ripple_carry_4_bit rca2(.a(a[3:0]),.b(b[3:0]),.cin(1'b1),.sum(s1[3:0]),.cout(c1));
 
mux2X1 ms0(.in0(s0[3:0]),.in1(s1[3:0]),.sel(cin),.out(sum[3:0]));
mux2X1_1 mc0(.in0(c0),.in1(c1),.sel(cin),.out(cout));
endmodule
 
/////////////////////
//2X1 Mux
/////////////////////
 
module mux2X1( in0,in1,sel,out);
//parameter width=16; 
input [3:0] in0,in1;
input sel;
output [3:0] out;
assign out=(sel)?in1:in0;
endmodule
 
 module mux2X1_1( in0,in1,sel,out);
//parameter width=16; 
input  in0,in1;
input sel;
output  out;
assign out=(sel)?in1:in0;
endmodule
/////////////////////////////////
//4-bit Ripple Carry Adder
/////////////////////////////////
module ripple_carry_4_bit(a, b, cin, sum, cout);
input [3:0] a,b;
input cin;
output [3:0] sum;
output cout;
 wire c1,c2,c3;
 full_adder fa0(.a(a[0]),.b(b[0]),.cin(cin),.sum(sum[0]),.cout(c1));
full_adder fa1(.a(a[1]),.b(b[1]),.cin(c1),.sum(sum[1]),.cout(c2));
full_adder fa2(.a(a[2]),.b(b[2]),.cin(c2),.sum(sum[2]),.cout(c3));
full_adder fa3(.a(a[3]),.b(b[3]),.cin(c3),.sum(sum[3]),.cout(cout));
endmodule
 
/////////////////////
//1bit Full Adder
/////////////////////
 
module full_adder(a,b,cin,sum,cout);
input a,b,cin;
output sum, cout;
wire x,y,z;
half_adder h1(.a(a), .b(b), .sum(x), .cout(y));
half_adder h2(.a(x), .b(cin), .sum(sum), .cout(z));
or or_1(cout,z,y);
endmodule
 
//////////////////////
// 1 bit Half Adder
//////////////////////`timescale 1ns / 1ns
module half_adder( a,b, sum, cout );
input a,b;
output sum, cout;
xor xor_1 (sum,a,b);
and and_1 (cout,a,b);
endmodule

/*
module datapath_tb;
reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, clk,R0in, R1in,R2in,R3in,R4in,R5in,R6in,R7in,Ain,rst,AddSub,Gin;
reg [8:0] DIN;
//reg clk, rst;
wire [8:0] Bus;
 
datapath_register_array GA1 (R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, Gout, DINout, clk,rst,R0in, R1in,R2in,R3in,R4in,R5in,R6in,R7in,Ain,Bus,DIN,AddSub,Gin);
 
initial 
begin
  clk=1'd1;
end
  always #5 clk=~clk;
 
initial
begin

// First Case
#10 DIN = 9'b110100101; 
// Select lines for Multiplexer
R0out = 1'b0; R1out = 1'b0;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b0; Gout= 1'b0; DINout= 1'b1;
// Load signals for Registers
R0in= 1'b1; R1in= 1'b0;R2in= 1'b0;R3in= 1'b0;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b0;Ain= 1'b0;rst= 1'b1; AddSub = 1'b0; Gin= 1'b0;

// Second Case
#11 DIN = 9'b111110000; 
// Select lines for Multiplexer
R0out = 1'b0; R1out = 1'b0;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b0; Gout= 1'b0; DINout= 1'b1;
// Load signals for Registers
R0in= 1'b0; R1in= 1'b1;R2in= 1'b0;R3in= 1'b0;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b0;Ain= 1'b0;rst= 1'b1; AddSub = 1'b0; Gin= 1'b0;

// Third Case
#10 DIN = 9'b100001111; 
// Select lines for Multiplexer
R0out = 1'b0; R1out = 1'b0;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b0; Gout= 1'b0; DINout= 1'b1;
// Load signals for Registers
R0in= 1'b0; R1in= 1'b0;R2in= 1'b1;R3in= 1'b0;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b0;Ain= 1'b0;rst= 1'b1; AddSub = 1'b0; Gin= 1'b0;

// Fourth Case
#10 DIN = 9'b101101100; 
// Select lines for Multiplexer
R0out = 1'b0; R1out = 1'b0;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b0; Gout= 1'b0; DINout= 1'b0;
// Load signals for Registers
R0in= 1'b0; R1in= 1'b0;R2in= 1'b0;R3in= 1'b1;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b0;Ain= 1'b0;rst= 1'b1; AddSub = 1'b0; Gin= 1'b0;


// fifth Case
#10 DIN = 9'b101101100; 
// Select lines for Multiplexer
R0out = 1'b0; R1out = 1'b1;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b0; Gout= 1'b0; DINout= 1'b0;
// Load signals for Registers
R0in= 1'b0; R1in= 1'b0;R2in= 1'b0;R3in= 1'b0;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b1;Ain= 1'b0;rst= 1'b1; AddSub = 1'b0; Gin= 1'b0;

// sixth Case
#10 DIN = 9'b101101100; 
// Select lines for Multiplexer
R0out = 1'b1; R1out = 1'b0;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b0; Gout= 1'b0; DINout= 1'b0;
// Load signals for Registers
R0in= 1'b0; R1in= 1'b0;R2in= 1'b0;R3in= 1'b0;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b0;Ain= 1'b1;rst= 1'b1; AddSub = 1'b0; Gin= 1'b0;

#10 DIN = 9'b101101100; 
// Select lines for Multiplexer
R0out = 1'b0; R1out = 1'b0;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b1; Gout= 1'b0; DINout= 1'b0;
// Load signals for Registers
R0in= 1'b0; R1in= 1'b0;R2in= 1'b0;R3in= 1'b0;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b0;Ain= 1'b0;rst= 1'b1; AddSub = 1'b0; Gin= 1'b1;

#10 DIN = 9'b101101100; 
// Select lines for Multiplexer
R0out = 1'b0; R1out = 1'b0;  R2out = 1'b0;  R3out= 1'b0; R4out= 1'b0; 
R5out= 1'b0; R6out= 1'b0; R7out= 1'b0; Gout= 1'b1; DINout= 1'b0;
// Load signals for Registers
R0in= 1'b1; R1in= 1'b0;R2in= 1'b0;R3in= 1'b0;R4in= 1'b0;R5in= 1'b0;
R6in= 1'b0;R7in= 1'b0;Ain= 1'b0;rst= 1'b1; AddSub = 1'b0; Gin= 1'b0;



end
endmodule

*/
