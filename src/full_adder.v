// Full adder 
module full_adder(A,B,Ci,Co,S);
  input A,B,Ci;
  output Co,S;
  
  assign Co = (A & Ci) | (A & B) | (B & Ci);
  assign S = A ^ B ^ Ci;
  
endmodule 
