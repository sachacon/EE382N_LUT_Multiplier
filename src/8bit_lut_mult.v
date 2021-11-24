module 8bit_lut_mult #(parameter A_const = 2) (input [7:0]X, output [15:0]C); 
  
  // input coding unit 
  // verify input coding unit block
  wire [2:0] input_coding_o;
  input_coding u_input_coding (.x(X[3:0]), .y(input_coding_o))
  
  
  // 8 word direct LUT
  reg [15:0] direct_lut_o;
  always@(*)
    begin
      case(input_coding_o)
        3'b000: direct_lut_o = 16'd0 * A_const;
        3'b001: direct_lut_o = 16'd1 * A_const;
        3'b010: direct_lut_o = 16'd2 * A_const; 
        3'b011: direct_lut_o = 16'd3 * A_const;
        3'b100: direct_lut_o = 16'd4 * A_const;
        3'b101: direct_lut_o = 16'd5 * A_const; 
        3'b110: direct_lut_o = 16'd6 * A_const;
        3'b111: direct_lut_o = 16'd7 * A_const;
      endcase 
    end 
  
  // sign modification 
  wire [11:0] sign_mod_o;
  sign_modification u_sign_mod (.x(direct_lut_o), .incr(X[3]), .y(sign_mod_o));
  
  
  // increment circuit 
  wire [4:0] incr_o
  increment_circuit u_incr2 (.A(X[7:4]), .incr(X[3]), .S(incr_o[3:0]), .Co(incr_o[4]));
  
  // 9 word oms LUT
  // same thing as Table IV 
  reg [15:0] oms_lut_o;
  always@(*)
    begin
      case(incr_o)
        5'b00000: oms_lut_o = 16'd0;
        5'b00001: oms_lut_o = 16'd1;
        5'b00011: oms_lut_o = 16'd2;
        5'b00001: oms_lut_o = 16'd3;
        5'b00001: oms_lut_o = 16'd4;
        5'b00001: oms_lut_o = 16'd5;
        5'b00001: oms_lut_o = 16'd6;
        5'b00001: oms_lut_o = 16'd7;
        5'b10000: oms_lut_o = 16'd8;
        default: oms_lut_o = 16'b0
      endcase
    end 
        
  // barrel shifter 
  // add control bits, assume the same s0 and s1 equations as the paper
  // 12bit_barrel_shifter u_shift ( );
          
  wire s0; wire s1;
  // s0 
  not u00 (n00, y[2]);
  or  u01 (n01, y[1], n00);
  not u02 (n02, n01);
  or  u03 (n03, y[0], n02);
  not u04 (s0, n03);
  
  // s1
  or s10  (n10, y[0], y[1]);
  not s11 (s1, n10);
  
  reg [15:0] temp_shift_out;
  wire [15:0] shift_out assign = temp_shift_out;
  always@(*)
    case({s1,s0})
      2'b00: temp_shift_out = shift_in;
      2'b01: temp_shift_out = shift_in << 1;
      2'b10: temp_shift_out = shift_in << 2;
      2'b11: temp_shift_out = shift_in << 3;
    endcase 
 
  
  // add partial products to get final product 
   C = {4'b0,sign_mod_o} + {temp_shift_out[11:0],4'b0} ; // a[15:0], b[15:0]
   // C = {8'b0,sign_mod_o} + {temp_shift_out[15:0],4'b0} ; // a[15:0], b[15:0
   // 16bit_adder u_adder (.A(), .B(), .S(C);
  
endmodule 
 
