// `timescale 1ns/1ps

module counter_ud#(
  parameter WIDTH = 4
)(
  input logic               i_clk,
  input logic               i_rstn,
  input logic [WIDTH-1:0]	  i_load,
  input logic               i_load_en,
  input logic               i_down,
  output logic              o_rollover,
  output logic [WIDTH-1:0]  o_count
);

  always @ (posedge i_clk or negedge i_rstn) begin
    if (!i_rstn) begin
       o_count <= 0;
    end else begin
      if (i_load_en) begin
        o_count <= i_load;
      end else begin
        if (i_down) begin
          o_count <= o_count - 1;
        end else begin
          o_count <= o_count + 1;
        end
      end
    end
  end

  assign o_rollover = &o_count;

endmodule
