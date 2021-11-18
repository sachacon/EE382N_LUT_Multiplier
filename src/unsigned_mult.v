module unsigned_mult
  #(parameter BIT_WIDTH=8)
  (input [BIT_WIDTH-1:0] A, 
   input [BIT_WIDTH-1:0] X, 
   output reg [(2*BIT_WIDTH)-1:0] C);
  
  always @(*)
    begin
      C = A * X;
    end
  
endmodule 
