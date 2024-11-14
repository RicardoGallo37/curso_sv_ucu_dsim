module param_decoder #(parameter DEPTH = 8) (
  input  logic [$clog2(DEPTH)-1:0]  i_deco_in,   // N-bit select input
  output logic [DEPTH-1:0]          o_deco_out,  // M-bit out 
  input  logic                      i_enable     // Enable for the decoder
);

//--------------Code Starts Here----------------------- 
  assign o_deco_out = (i_enable) ? ({{(DEPTH-1){1'b0}},1'b1}  << i_deco_in) : {DEPTH{1'b0}} ;
//assign o_deco_out = (i_enable) ? (1  << i_deco_in) : {DEPTH{1'b0}} ;

endmodule
