// `timescale 1ns/1ps

// This module accepts an interface object as the port list
module counter_ud #(
  parameter WIDTH = 4
)(
  cnt_if _if
);

  always @ (posedge _if.clk or negedge _if.rstn) begin
    if (!_if.rstn) begin
   		_if.count <= 0;
    end else begin
      if (_if.load_en) begin
        _if.count <= _if.load;
      end else begin
        if (_if.down) begin
        	_if.count <= _if.count - 1;
        end else begin
        	_if.count <= _if.count + 1;
        end
      end
    end
  end

  assign _if.rollover = &_if.count;

endmodule
