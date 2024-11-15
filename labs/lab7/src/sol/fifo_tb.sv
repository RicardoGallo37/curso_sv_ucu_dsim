
module fifo_tb();

  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 3;

  logic clk;
  logic rst, wr_cs, rd_cs;
  logic rd_en, wr_en;
  logic [DATA_WIDTH-1:0] data_in ;
  logic full, empty;
  logic [DATA_WIDTH-1:0] data_out ;

  fifo_ports ports (
    .i_clk      (clk     ),
    .o_rst      (rst     ),
    .o_wr_cs    (wr_cs   ),
    .o_rd_cs    (rd_cs   ),
    .o_rd_en    (rd_en   ),
    .o_wr_en    (wr_en   ),
    .o_data_in  (data_in ),
    .i_full     (full    ),
    .i_empty    (empty   ),
    .i_data_out (data_out)
  );

  fifo_monitor_ports mports (
    .i_clk      (clk     ),
    .i_rst      (rst     ),
    .i_wr_cs    (wr_cs   ),
    .i_rd_cs    (rd_cs   ),
    .i_rd_en    (rd_en   ),
    .i_wr_en    (wr_en   ),
    .i_data_in  (data_in ),
    .i_full     (full    ),
    .i_empty    (empty   ),
    .i_data_out (data_out)
  );


  fifo_top top(ports,mports);

  initial begin
    //$dumpfile("fifo.vcd");
    //$dumpvars();
    clk = 0;
  end

  always #1 clk  = ~clk;

  syn_fifo #(DATA_WIDTH,ADDR_WIDTH) fifo(
    .i_clk      (clk),     // Clock input
    .i_rst      (rst),     // Active high reset
    .i_wr_cs    (wr_cs),   // Write chip select
    .i_rd_cs    (rd_cs),   // Read chipe select
    .i_data_in  (data_in), // Data input
    .i_rd_en    (rd_en),   // Read enable
    .i_wr_en    (wr_en),   // Write Enable
    .o_data_out (data_out),// Data Output
    .o_empty    (empty),   // FIFO empty
    .o_full     (full)     // FIFO full
  );

endmodule
