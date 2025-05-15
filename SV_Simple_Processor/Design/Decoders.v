//`timescale 1ns/1ns
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
Y = W;

endmodule
