
module input_coding(
    input [3:0] x,
    output [3:0] y
    );
    
    wire Ci, ri;
    wire [3:0] X_1comp;
    assign Ci = x[3];
    assign X_1comp[3] = x[3] ^ Ci;
    assign X_1comp[2] = x[2] ^ Ci; 
    assign X_1comp[1] = x[1] ^ Ci; 
    assign X_1comp[0] = x[0] ^ Ci; 
    assign ri = Ci ^ 1'b0; //Ci-1 = 0 so ri = Ci
    assign y = X_1comp + ri;
    
endmodule

/*

module input_coding(input [3:0] x, output [3:0] y);
  
  // Still need to verify that the logic is correct 
  
  wire n00, n01, n02, n03, n04, n05;
  wire n10, n11, n12, n13, n14, n15;
  wire n20, n21, n22, n23, n24, n25;
  wire n30, n31, n32, n33, n34, n35;
  
  // y(0)
  xor u00 (y[0], x[0], 0);
  or  u01 (n00, x[0], 0);
  and u02 (n01, x[0], 0);
  
  // y(1)
  or  u10 (n10, x[1], n00);
  and u11 (n11, x[1], n01);
  
  and u12 (n12, x[3], n00);
  or  u13 (n13,  n12, n01);
  xor u14 (y[1], n13, x[1]); 
  
  // y(2)
  or  u20 (n20, x[2], n10);
  and u21 (n21, x[2], n11);
  
  and u22 (n22, x[3], n10);
  or  u23 (n23,  n22, n11);
  xor u24 (y[2], n23, n12); 
  
  // y(3)
  and u30 (n30, x[3], n20);
  or  u31 (n31, n30, n21);
  xor u32 (y[3], x[3], n31); 
  
endmodule 
*/
