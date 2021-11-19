// Increment Circuit, 4 bit carry ripple adder 
module ripple_carry(A,B,Ci,Co,S);
  input [3:0] A; input [3:0] B; input Ci;
  output [3:0] S; output Co;
                  
  wire [2:0] carry;
                  
  full_adder a0 (.A(A[0]), .B(B[0]), .Ci(Ci), .Co(carry[0]), .S(S[0]));
  full_adder a1 (.A(A[1]), .B(B[1]), .Ci(carry[0]), .Co(carry[1]), .S(S[1]));
  full_adder a2 (.A(A[2]), .B(B[2]), .Ci(carry[1]), .Co(carry[2]), .S(S[2]));
  full_adder a3 (.A(A[3]), .B(B[3]), .Ci(carry[2]), .Co(Co), .S(S[3]));

endmodule
