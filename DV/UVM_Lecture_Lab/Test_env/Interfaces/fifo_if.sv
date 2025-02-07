interface fifo_if(input logic clk, rst_n);
    logic wr_en, rd_en, full, empty;
    logic [7:0] data_in, data_out;
    
    modport DUT (input clk, rst_n, wr_en, rd_en, data_in, output full, empty, data_out);
    modport TB (input clk, rst_n, full, empty, output wr_en, rd_en, data_in, input data_out);
endinterface