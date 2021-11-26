module lut_mult_8bit #(parameter A_const = 2) (input [7:0]X, output [15:0]C); 
  
  // input coding unit 
  // verify input coding unit block
  wire [3:0] input_coding_o;
  // input_coding u_input_coding (.x(X[3:0]), .y(input_coding_o))
  // Xi' = (Xi XOR Ci) + (Ci-1 XOR Ci)
  // Ci-1 = 0, (Ci-1 XOR Ci) = (0 XOR Ci) = Ci 
  // Ci = X[3]
  //assign input_coding_o[0] = (X[0] ^ X[3]) | X[3]; 
  //assign input_coding_o[1] = (X[1] ^ X[3]) | X[3]; 
  //assign input_coding_o[2] = (X[2] ^ X[3]) | X[3]; 
  //assign input_coding_o[3] = (X[3] ^ X[3]) | X[3]; 
  // input_coding_o[3:0] = (X[3:0] ^ X[3]) | X[3]; 
   wire Ci, ri;
   wire [3:0] input_coding_temp;
   assign Ci = X[3];
   assign input_coding_temp[3] = X[3] ^ Ci;
   assign input_coding_temp[2] = X[2] ^ Ci; 
   assign input_coding_temp[1] = X[1] ^ Ci; 
   assign input_coding_temp[0] = X[0] ^ Ci; 
   assign ri = Ci ^ 1'b0; //Ci-1 = 0 so ri = Ci
   assign input_coding_o = input_coding_temp + ri;
  
  // 8 Word Direct LUT
  reg [10:0] direct_lut_o;
  always@(*)
    begin
      case(input_coding_o[2:0])
        3'b000: direct_lut_o = 11'd0 * A_const;
        3'b001: direct_lut_o = 11'd1 * A_const;
        3'b010: direct_lut_o = 11'd2 * A_const; 
        3'b011: direct_lut_o = 11'd3 * A_const;
        3'b100: direct_lut_o = 11'd4 * A_const;
        3'b101: direct_lut_o = 11'd5 * A_const; 
        3'b110: direct_lut_o = 11'd6 * A_const;
        3'b111: direct_lut_o = 11'd7 * A_const;
      endcase 
    end 
  
  // Sign Modification 
  wire [11:0] sign_mod_o;
  wire [10:0] inv_bits;
  reg [11:0] sign_mod_temp;
  assign inv_bits = ~direct_lut_o;
  assign sign_mod_o = (X[3] == 1) ? sign_mod_temp : direct_lut_o; 
  //assign sign_mod_o = {1'b0,direct_lut_o}; 
  //assign sign_mod_temp = ~(direct_lut_o) + 1'b1;
  always@(*)
    begin
    sign_mod_temp = inv_bits + 1'b1;
    end 
      
  // Increment Circuit 
  wire [4:0] incr_o;
  //reg [4:0] incr_temp;
  assign incr_o = X[7:4] + X[3];
  //always@(*)
  //  begin
  //    incr_temp = X[7:4] + X[3];
  //  end   
  
  // 9 Word OMS LUT, same as Table IV 
  reg [11:0] oms_lut_o;
  always@(*)
    begin
      case(incr_o)
        // reset case 
        5'b00000: oms_lut_o = 12'd0;
        // address 0000
        5'b00001: oms_lut_o = 12'd1  * A_const;
        5'b00010: oms_lut_o = 12'd1  * A_const;
        5'b00100: oms_lut_o = 12'd1  * A_const;
        5'b01000: oms_lut_o = 12'd1  * A_const;
        // address 0001
        5'b00011: oms_lut_o = 12'd3 * A_const;
        5'b00110: oms_lut_o = 12'd3 * A_const;
        5'b01100: oms_lut_o = 12'd3 * A_const;
        // address 0010
        5'b00101: oms_lut_o = 12'd5  * A_const;
        5'b01010: oms_lut_o = 12'd5  * A_const;
        // address 0011
        5'b00111: oms_lut_o = 12'd7  * A_const;
        5'b01110: oms_lut_o = 12'd7  * A_const;
        // address 0100
        5'b01001: oms_lut_o = 12'd9  * A_const;
        // address 0101
        5'b01011: oms_lut_o = 12'd11  * A_const;
        // address 0110
        5'b01101: oms_lut_o = 12'd13 * A_const;
        // address 0111
        5'b01111: oms_lut_o = 12'd15 * A_const;
        // adress 1000
        5'b10000: oms_lut_o = 12'd2 * A_const;
        default: oms_lut_o = 12'd0;
      endcase
    end 
        
  // Barrel Shifter 
  // add control bits, assume the same s0 and s1 equations as the paper
  // 12bit_barrel_shifter u_shift ( );
          
  wire s0; wire s1;
  wire n00, n01, n02, n03;
  wire n10; 
  // s0 
  not u00 (n00, incr_o[2]);
  or  u01 (n01, incr_o[1], n00);
  not u02 (n02, n01);
  or  u03 (n03, incr_o[0], n02);
  not u04 (s0, n03);
  
  // s1
  or s10  (n10, incr_o[0], incr_o[1]);
  not s11 (s1, n10);
  
  reg [11:0] temp_shift_out;
  wire [11:0] shift_out;
  assign shift_out = temp_shift_out;
  always@(*)
    begin
    case({s1,s0})
      2'b00: temp_shift_out = oms_lut_o;
      2'b01: temp_shift_out = oms_lut_o << 1;
      2'b10: temp_shift_out = oms_lut_o << 2;
      2'b11: temp_shift_out = oms_lut_o << 3;
    endcase 
    end
 
  
   // add partial products to get final product
  reg [15:0] C_temp; 
  assign C = C_temp;
  wire [15:0] A_temp;
  wire [15:0] B_temp; 
  assign A_temp = {shift_out[11:0],4'b0};
  assign B_temp = {sign_mod_o[11],sign_mod_o[11],sign_mod_o[11],sign_mod_o[11],sign_mod_o};
  always@(*)
    begin
      C_temp = (A_temp[15] == 1) ? (A_temp - B_temp) : (A_temp + B_temp) ; // a[15:0], b[15:0]
    end 
  // C = {8'b0,sign_mod_o} + {temp_shift_out[15:0],4'b0} ; // a[15:0], b[15:0
  // 16bit_adder u_adder (.A(), .B(), .S(C);
  
endmodule 
 
