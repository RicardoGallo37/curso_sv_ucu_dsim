module counter_ud #(
  parameter N = 8
)(
  input  logic i_clk,
  input  logic i_reset,
  input  logic i_enable,
  output logic [N-1:0] o_q
); //You'd need a new input for controlling the counter direction

  always_ff @(posedge i_clk, posedge i_reset) begin
    if (i_reset) begin
        o_q <= '0;
    end else begin
      if (i_enable) begin//From here, add the necessary code to make this an up_down counter
        o_q <= o_q + 1'b1;
      end
    end
  end

endmodule 
