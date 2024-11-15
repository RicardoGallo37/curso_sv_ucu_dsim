// This exammple is mainly taken from ChipVerify
// https://www.chipverify.com/systemverilog/systemverilog-testbench-example-1
// June 7, 2023
// Please respect ownership of this code, as kindly provided by ChipVerify for educative purposes

// Design: A simple memory module

// Additonal notes and minor modifications: Alfonso Chacon Rodriguez, June 7, 2023

// Note that in this protocol, write data is provided
// in a single clock along with the address while read
// data is received on the next clock, and no transactions
// can be started during that time indicated by "o_ready"
// signal.

module reg_ctrl #(
  parameter ADDR_WIDTH 	= 8,
  parameter DATA_WIDTH 	= 16,
  parameter DEPTH 		    = 256,
  parameter RESET_VAL  	= 16'h1234
)( 
  input logic                     i_clk,
  input logic					            i_rstn,
  input logic [ ADDR_WIDTH-1:0] 	i_addr,
  input logic					            i_sel,
  input logic					            i_wr,
  input logic [DATA_WIDTH-1:0] 	  i_wdata,
  output logic [DATA_WIDTH-1:0] 	o_rdata,
  output logic        			      o_ready
);

  // Some memory element to store data for each i_addr
  logic [DATA_WIDTH-1:0] ctrl [DEPTH];

  logic  ready_dly;
  logic  ready_pe;

  // If reset is asserted, clear the memory element
  // Else store data to i_addr for valid writes
  // For reads, provide read data back
  always_ff @ (posedge i_clk) begin
    if (!i_rstn) begin
      for (int i = 0; i < DEPTH; i += 1) begin
        ctrl[i] <= RESET_VAL;
      end
    end else begin
      if (i_sel & o_ready & i_wr) begin
        ctrl[i_addr] <= i_wdata;
      end

      if (i_sel & o_ready & !i_wr) begin
        o_rdata <= ctrl[i_addr];
      end else begin
        o_rdata <= 0;
      end
    end
  end

  // Ready is driven using this always block
  // During reset, drive o_ready as 1
  // Else drive o_ready low for a clock low
  // for a read until the data is given back
  always_ff @ (posedge i_clk) begin
    if (!i_rstn) begin
      o_ready <= 1;
    end else begin
      if (i_sel & ready_pe) begin
        o_ready <= 1;
      end
      if (i_sel & o_ready & !i_wr) begin
        o_ready <= 0;
      end
    end
  end

  // Drive internal signal accordingly
  // This creates a one-clock delayed o_ready (pipeline)
  // in order to provide a one-clock window in which the register may not be writter
  // as a read is taking place
  
  always_ff @ (posedge i_clk) begin
    if (!i_rstn) begin
      ready_dly <= 1;
    end else begin
      ready_dly <= o_ready;
    end
  end

  assign ready_pe = ~o_ready & ready_dly;

endmodule
