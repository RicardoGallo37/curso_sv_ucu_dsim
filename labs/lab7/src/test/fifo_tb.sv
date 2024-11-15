`include "../rtl/ram_dp_ar_aw.sv"
`include "../rtl/syn_fifo.sv"
`include "./fifo_top.sv"

module fifo_tb();

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 3;

reg clk;
wire rst, wr_cs, rd_cs;
wire rd_en, wr_en;
wire [DATA_WIDTH-1:0] data_in ;
wire full, empty;
wire [DATA_WIDTH-1:0] data_out ;

fifo_ports ports (
  .i_clk           (clk     ),
  .o_rst           (rst     ),
  .o_wr_cs         (wr_cs   ),
  .o_rd_cs         (rd_cs   ),
  .o_rd_en         (rd_en   ),
  .o_wr_en         (wr_en   ),
  .o_data_in       (data_in ),
  .i_full          (full    ),
  .i_empty         (empty   ),
  .i_data_out      (data_out)
);

fifo_monitor_ports mports (
  .i_clk           (clk     ),
  .i_rst           (rst     ),
  .i_wr_cs         (wr_cs   ),
  .i_rd_cs         (rd_cs   ),
  .i_rd_en         (rd_en   ),
  .i_wr_en         (wr_en   ),
  .i_data_in       (data_in ),
  .i_full          (full    ),
  .i_empty         (empty   ),
  .i_data_out      (data_out)
);

//connect here the test fifo_top
???;

  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clk = 0;
end

always #1 clk  = ~clk;

syn_fifo #(DATA_WIDTH,ADDR_WIDTH) fifo(
.clk      (clk),     // Clock input
.rst      (rst),     // Active high reset
.wr_cs    (wr_cs),   // Write chip select
.rd_cs    (rd_cs),   // Read chipe select
.data_in  (data_in), // Data input
.rd_en    (rd_en),   // Read enable
.wr_en    (wr_en),   // Write Enable
.data_out (data_out),// Data Output
.empty    (empty),   // FIFO empty
.full     (full)     // FIFO full
);

endmodule
