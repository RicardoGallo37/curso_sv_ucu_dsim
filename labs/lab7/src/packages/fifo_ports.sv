`ifndef FIFO_PORTS_SV
`define FIFO_PORTS_SV

interface fifo_ports (
  input  logic        i_clk,
  output logic        o_rst,
  input  logic        i_full,
  input  logic        i_empty,
  output logic        o_wr_cs,
  output logic        o_rd_cs,
  output logic        o_rd_en,
  output logic        o_wr_en,
  output logic [7:0]  o_data_in,
  input  logic [7:0]  i_data_out
);
endinterface


interface fifo_monitor_ports (
  input logic         i_clk,
  input logic         i_rst,
  input logic         i_full,
  input logic         i_empty,
  input logic         i_wr_cs,
  input logic         i_rd_cs,
  input logic         i_rd_en,
  input logic         i_wr_en,
  input logic [7:0]   i_data_in,
  input logic [7:0]   i_data_out
);
endinterface


`endif
