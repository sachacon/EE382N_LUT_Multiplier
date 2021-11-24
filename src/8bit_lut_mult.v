module 8bit_lut_mult #(parameter A_const = 2) (input [7:0]X, output [15:0]C); 
  
  // input coding unit 
  wire [2:0] input_coding_o;
  input_coding u_input_coding (.x(X[3:0]), .y(input_coding_o))
  
  
  // 8 word direct LUT
  reg [10:0] direct_lut_o;
  always@(*)
    begin
      case(input_coding_o)
        3'b000: direct_lut_o = 11'd0 * A_const;
        3'b001: direct_lut_o = 11'd1 * A_const;
        3'b010: direct_lut_o = 11'd2 * A_const; 
        3'b011: direct_lut_o = 11'd3 * A_const;
        3'b100: direct_lut_o = 11'd4 * A_const;
        3'b101: direct_lut_o = 11'd5 = A_const; 
        3'b110: direct_lut_o = 11'd6 * A_const;
        3'b111: direct_lut_o = 11'd7 * A_const;
      endcase 
    end 
  
  // sign modification 
  wire [11:0] sign_mod_o;
  sign_modification u_sign_mod (.x(direct_lut_o), .incr(X[3]), .y(sign_mod_o));
  
  
  // increment circuit 
  wire [4:0] incr_o
  increment_circuit u_incr2 (.A(X[7:4]), .incr(X[3]), .S(incr_o[3:0]), .Co(incr_o[4]));
  
  // 9 word oms LUT
  reg [11:0] oms_lut_o;
  always@(*)
    begin
      case(incr_o)
        5'b00000: oms_lut_o = 12'd0;
        5'b00001: oms_lut_o = 12'd1;
        5'b00001: oms_lut_o = 12'd2;
        5'b00001: oms_lut_o = 12'd3;
        5'b00001: oms_lut_o = 12'd4;
        5'b00001: oms_lut_o = 12'd5;
        5'b00001: oms_lut_o = 12'd6;
        5'b00001: oms_lut_o = 12'd7;
        5'b10000: oms_lut_o = 12'd8;
        default: oms_lut_o = 12'b0
      endcase
    end 
        
  // barrel shifter 
  // 12bit_barrel_shifter u_shift ( ); 
  
  // add partial products to get final product 
  // 16bit_adder u_adder (.A(), .B(), .S(C);
  
endmodule 
 
