/////////////////////////////////////////////////////////////////////////
// Parameterized Mux                                                   //
/////////////////////////////////////////////////////////////////////////
module param_mux #(
  parameter NUM_SLCT_LNS = 2,
  parameter PCK_SZ = 4
)(
  input     logic   [NUM_SLCT_LNS-1:0]  i_select,
  input     logic   [PCK_SZ-1:0]        i_input_signal[(2**NUM_SLCT_LNS)-1:0],
  output    logic   [PCK_SZ-1:0]        o_out
);

  logic [(2**NUM_SLCT_LNS)-1:0] hot_bit_slct;

  genvar j;
  generate
    for(j=0; j<(2**NUM_SLCT_LNS); j++) begin:_nu_
      always_comb begin
        hot_bit_slct[j] = (j == i_select)?{1'b1}:{1'b0};
      end
    end
  endgenerate

  always_comb begin
      o_out = '0;
      for (int i = 0; i<(2**NUM_SLCT_LNS); i++) begin
          if (hot_bit_slct[i]) begin
              o_out = i_input_signal[i];
          end
      end
  end

endmodule
