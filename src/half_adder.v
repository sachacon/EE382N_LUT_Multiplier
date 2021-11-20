module half_adder(A,B,Co,S);
  input A,B;
  output Co,S;
  
  assign Co = A & B;
  assign S = A ^ B;
  
endmodule 
