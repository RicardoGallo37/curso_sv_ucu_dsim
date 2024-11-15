`timescale 1ns/1ps

module counter_ud
  #(parameter WIDTH = 4)
  (
  input logic				clk,
  input logic				rstn,
  input logic [WIDTH-1:0]	load,
  input logic				load_en,
  input logic				down,
  output logic				rollover,
  output logic [WIDTH-1:0]	count
);

  always @ (posedge clk or negedge rstn) begin
    if (!rstn)
   		count <= 0;
    else
      if (load_en)
        count <= load;
      else begin
      	if (down)
        	count <= count - 1;
      	else
        	count <= count + 1;
      end
  end

  assign rollover = &count;
endmodule

