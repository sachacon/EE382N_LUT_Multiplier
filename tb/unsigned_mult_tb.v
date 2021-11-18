module unsigned_mult_tb
  #(parameter BIT_WIDTH=8);
  
  reg [BIT_WIDTH-1:0]A;
  reg [BIT_WIDTH-1:0]X;
  wire [(2*BIT_WIDTH)-1:0]C;
  
  unsigned_mult uut (.A(A), .X(X), .C(C));
  
  initial begin
    // A is a constant, X is the input 
    A = 8'd3; X = 8'd0;
    #5 
    $display("time=%0t, A=%0d, X=%0d. C=%0d", $time, A, X, C);
    for(int i = 0; i < (1 << BIT_WIDTH); i++)
      begin
        X = X + 8'd1;
        #5
        $display("time=%0t, A=%0d, X=%0d. C=%0d", $time, A, X, C);
      end
    $finish;
  end
  
endmodule 
