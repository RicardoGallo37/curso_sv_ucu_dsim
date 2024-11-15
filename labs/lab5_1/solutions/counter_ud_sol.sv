`timescale 1ns/1ps

// This module accepts an interface object as the port list
module counter_ud  #(parameter WIDTH = 4) (cnt_if _if);
  always @ (posedge _if.clk or negedge _if.rstn) begin
    if (!_if.rstn)
   		_if.count <= 0;
    else
      if (_if.load_en)
        _if.count <= _if.load;
      else begin
        if (_if.down)
        	_if.count <= _if.count - 1;
      	else
        	_if.count <= _if.count + 1;
      end
  end

  assign _if.rollover = &_if.count;
endmodule

