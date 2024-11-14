module deco_tb;

  parameter DEPTH = 8; 
  bit [$clog2(DEPTH)-1:0] deco_in;
  bit [DEPTH-1:0]        deco_out;
  bit                    enable;

  param_decoder #(
    .DEPTH(DEPTH)
  ) deco_u1 (
    .i_deco_in(deco_in),    //  N-bit select input
    .o_deco_out(deco_out),  //  M-bit out 
    .i_enable(enable)       //  Enable for the decoder
  );

  initial begin
    $monitor("[%0t]\t enable=%b\t deco_in=%d\t deco_out=%b",
    $time, enable, deco_in, deco_out);
    deco_in = 0;
    enable=0;
    #1 enable  = 1;
    #3 deco_in = 1;
    #3 deco_in = 7;
    #3 deco_in = 4;
    #3 deco_in = 6;
    #2 enable  = 0;
    #2 $finish;
  end

endmodule
