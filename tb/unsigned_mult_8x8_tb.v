module unsigned_mult_8x8_tb;
  
  reg [7:0]A;
  reg [7:0]X;
  wire [15:0]C;
  
  unsigned_mult_8x8 uut (.A(A), .X(X), .C(C));
  
  initial begin
    // A is a constant, X is the input 
    A = 8'd2; X = 8'd0;
    #5 
    $display("time=%0t, A=%0d, X=%0d. C=%0d", $time, A, X, C);
    for(int i = 0; i < 256; i++)
      begin
        X = X + 8'd1;
        #5
        $display("time=%0t, A=%0d, X=%0d. C=%0d", $time, A, X, C);
      end
    $finish;
  end
  
endmodule 
