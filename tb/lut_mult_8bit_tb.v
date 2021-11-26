`timescale 1ns / 1ps

module unsigned_mult_tb
  #(parameter BIT_WIDTH=8);
  
  localparam [7:0] A_const = 2; 
  reg [BIT_WIDTH-1:0]X;
  wire [(2*BIT_WIDTH)-1:0]C;
  integer i;
  reg [15:0] soln; 
  
  lut_mult_8bit#(.A_const(A_const)) uut (.X(X), .C(C));
  
  // Testcase correct if soln == 1 
  initial begin
    // A is a constant, X is the input 
    X = 8'd0;
    #5 
    if(C == X*A_const)soln = 1;
    else soln = 0; 
    $display("time=%0t, A=%0d, X=%0d. C=%0d, Correct=%0d", $time, A_const, X, C, soln);
    for(i = 0; i < (1 << BIT_WIDTH); i=i+1)
      begin
        X = X + 8'd1;
        #5
        if(C == X*A_const)soln = 1;
        else soln = 0; 
        $display("time=%0t, A=%0d, X=%0d. C=%0d, Correct=%0d", $time, A_const, X, C, soln);
      end
    $finish;
  end
  
endmodule 
