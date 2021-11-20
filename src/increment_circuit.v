// Increment Circuit, 4 bit half adder
module increment(A,inc,S,Co);
  input [3:0] A; input incr; 
  output [3:0] S; output Co;
                  
  wire [2:0] carry;
                  
  half_adder a0 (.A(A[0]), .B(incr),      .Co(carry[0]), .S(S[0]));
  half_adder a1 (.A(A[1]), .B(carry[0]), .Co(carry[1]), .S(S[1]));
  half_adder a2 (.A(A[2]), .B(carry[1]), .Co(carry[2]), .S(S[2]));
  half_adder a3 (.A(A[3]), .B(carry[2]), .Co(Co),       .S(S[3]));

endmodule
