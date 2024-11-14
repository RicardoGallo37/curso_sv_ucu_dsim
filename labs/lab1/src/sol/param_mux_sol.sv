/////////////////////////////////////////////////////////////////////////
// Parameterized Mux                                                   //
/////////////////////////////////////////////////////////////////////////
module param_mux_sol #(
  parameter DEPTH = 2,
  parameter WORD_SIZE = 4
)(
  input     logic   [$clog2(DEPTH)-1:0]  i_select,
  input     logic   [WORD_SIZE-1:0]      i_input_signal[(DEPTH)-1:0],
  output    logic   [WORD_SIZE-1:0]      o_out
);

///Create a signal for connecting the output of the deco
logic [(DEPTH)-1:0] hot_bit_slct;

//Connect the deco. 
  param_decoder #(.DEPTH(DEPTH)) deco_u0 (
    .i_deco_in(i_select),       //
    .o_deco_out(hot_bit_slct),  //  
    .i_enable(1'b1)             //  Deco always enabled
  );

  always_comb begin
    o_out = '0;
    for (int i = 0; i<(DEPTH); i++) begin
      //What would you place in this next if construct, for the o_out signal to be connected with the right input word?
      if (hot_bit_slct[i]) begin
        o_out = i_input_signal[i];
      end
    end
  end

endmodule
