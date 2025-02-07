`timescale 1ns/10ps
import uvm_pkg::*;
import tests_pkg::*;

//////////////////////////////////////////
// Top-Level Testbench
//////////////////////////////////////////
module fifo_top;
    logic clk, rst_n;
    fifo_if fifoif(clk, rst_n);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end
    
    fifo dut (
        .clk(fifoif.clk),
        .rst_n(fifoif.rst_n),
        .wr_en(fifoif.wr_en),
        .rd_en(fifoif.rd_en),
        .din(fifoif.data_in),
        .full(fifoif.full),
        .empty(fifoif.empty),
        .dout(fifoif.data_out)
    );
    
    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top", "fifo_if", fifoif);
        run_test("fifo_test");
    end
endmodule
