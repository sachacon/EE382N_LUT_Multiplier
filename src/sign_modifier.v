
module sign_mod(input [10:0] x, input incr, output [11:0] y)
  wire [10:0] inv_bits;
  wire [9:0] carry;
 
  assign inv_bits = ~x;
  assign y = y_temp;
  reg y_temp; 
  always@(*)
    y_temp = inv_bits + 1;
  
endmodule 
