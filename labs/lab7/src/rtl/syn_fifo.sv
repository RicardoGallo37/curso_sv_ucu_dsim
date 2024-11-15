//-----------------------------------------------------
// Design Name : syn_fifo
// File Name   : syn_fifo.v
// Function    : Synchronous (single clock) FIFO
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module syn_fifo (
  i_clk      , // Clock input
  i_rst      , // Active high reset
  i_wr_cs    , // Write chip select
  i_rd_cs    , // Read chipe select
  i_data_in  , // Data input
  i_rd_en    , // Read enable
  i_wr_en    , // Write Enable
  o_data_out , // Data Output
  o_empty    , // FIFO empty
  o_full       // FIFO full
);

  // FIFO constants
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 8;
  parameter RAM_DEPTH = (1 << ADDR_WIDTH);

  // Port Declarations
  input i_clk ;
  input i_rst ;
  input i_wr_cs ;
  input i_rd_cs ;
  input i_rd_en ;
  input i_wr_en ;
  input [DATA_WIDTH-1:0] i_data_in ;
  output o_full ;
  output o_empty ;
  output [DATA_WIDTH-1:0] o_data_out ;

  //-----------Internal variables-------------------
  logic [ADDR_WIDTH-1:0] wr_pointer;
  logic [ADDR_WIDTH-1:0] rd_pointer;
  logic [ADDR_WIDTH :0] status_cnt;
  logic [DATA_WIDTH-1:0] o_data_out ;
  wire  [DATA_WIDTH-1:0] data_ram ;

  //-----------Variable assignments---------------
  assign o_full = (status_cnt == (RAM_DEPTH-1));
  assign o_empty = (status_cnt == 0);

  //-----------Code Start---------------------------
  always @(posedge i_clk or posedge i_rst) begin : WRITE_POINTER
    if (i_rst) begin
      wr_pointer <= 0;
    end else begin
      if (i_wr_cs && i_wr_en ) begin
        wr_pointer <= wr_pointer + 1;
      end
    end
  end

  always @(posedge i_clk or posedge i_rst) begin : READ_POINTER
    if (i_rst) begin
      rd_pointer <= 0;
    end else begin 
      if (i_rd_cs && i_rd_en ) begin
        rd_pointer <= rd_pointer + 1;
      end
    end
  end

  always @(posedge i_clk or posedge i_rst) begin : READ_DATA
    if (i_rst) begin
      o_data_out <= 0;
    end else begin 
      if (i_rd_cs && i_rd_en ) begin
        o_data_out <= data_ram;
      end
    end
  end

  always @ (posedge i_clk or posedge i_rst) begin : STATUS_COUNTER
    if (i_rst) begin
      status_cnt <= 0;
    // Read but no write.
    end else if ((i_rd_cs && i_rd_en) && !(i_wr_cs && i_wr_en) 
                  && (status_cnt != 0)) begin
      status_cnt <= status_cnt - 1;
    // Write but no read.
    end else if ((i_wr_cs && i_wr_en) && !(i_rd_cs && i_rd_en) 
                 && (status_cnt != RAM_DEPTH)) begin
      status_cnt <= status_cnt + 1;
    end
  end

  ram_dp_ar_aw #(DATA_WIDTH,ADDR_WIDTH) DP_RAM (
    .i_address_0 (wr_pointer),  // address_0 input 
    .i_o_data_0  (i_data_in),   // data_0 bi-directional
    .i_cs_0      (i_wr_cs),     // chip select
    .i_we_0      (i_wr_en),     // write enable
    .o_oe_0      (1'b0),        // output enable
    .i_address_1 (rd_pointer),  // address_q input
    .i_o_data_1  (data_ram),    // data_1 bi-directional
    .i_cs_1      (i_rd_cs),     // chip select
    .i_we_1      (1'b0),        // Read enable
    .i_oe_1      (i_rd_en)      // output enable
  );

endmodule
