package fifo_driver_pkg;

  import fifo_sb_pkg::*;

  class fifo_driver;

    fifo_sb sb;
    virtual fifo_ports ports;
    virtual fifo_monitor_ports mports;

    bit rdDone;
    bit wrDone;
  
    integer wr_cmds;
    integer rd_cmds;

    function new (virtual fifo_ports ports, virtual fifo_monitor_ports mports);
    begin
      this.ports = ports;
      this.mports = mports;
      sb = new();
      wr_cmds = 5;
      rd_cmds = 5;
      rdDone = 0;
      wrDone = 0;
      ports.o_wr_cs  = 0;
      ports.o_rd_cs  = 0;
      ports.o_wr_en  = 0;
      ports.o_rd_en  = 0;
      ports.o_data_in  = 0;
    end
    endfunction

    task monitorPush();
    begin
      bit [7:0] data = 0;
      while (1) begin
        @ (posedge mports.i_clk);
        if (mports.i_wr_cs== 1 &&  mports.i_wr_en== 1) begin
          data = mports.i_data_in;
          sb.addItem(data);
          $write("%dns : Write posting to scoreboard data = %x\n",$time, data);
        end
      end
    end
    endtask

    task monitorPop();
    begin
      bit [7:0] data = 0;
      while (1) begin
        @ (posedge mports.i_clk);
        if (mports.i_rd_cs== 1 &&  mports.i_rd_en== 1) begin
          data = mports.i_data_out;
          $write("%dns : Read posting to scoreboard data = %x\n",$time, data);
          sb.compareItem(data);
        end
      end
    end
    endtask

    task go();
    begin
      // Assert reset first
      reset();
      // Start the monitors
      repeat (5) @ (posedge ports.i_clk);
      $write("%dns : Starting Pop and Push monitors\n",$time);
      fork
        monitorPop();
        monitorPush();
      join_none
      $write("%dns : Starting Pop and Push generators\n",$time);
      fork
        genPush();
        genPop(); 
      join_none

      while (!rdDone && !wrDone) begin
        @ (posedge ports.i_clk);
      end
      repeat (10) @ (posedge ports.i_clk);
      $write("%dns : Terminating simulations\n",$time);
      $finish;
    end
    endtask

    task reset();
    begin
      repeat (5) @ (posedge ports.i_clk);
      $write("%dns : Asserting reset\n",$time);
      ports.o_rst= 1'b1;
      // Init all variables
      rdDone = 0;
      wrDone = 0;
      repeat (5) @ (posedge ports.i_clk);
      ports.o_rst= 1'b0;
      $write("%dns : Done asserting reset\n",$time);
    end
    endtask

    task genPush();
    begin
      bit [7:0] data = 0;
      integer i = 0;
      for ( i  = 0; i < wr_cmds; i++)  begin
         data = $random();
         @ (posedge ports.i_clk);
         while (ports.i_full== 1'b1) begin
          ports.o_wr_cs  = 1'b0;
          ports.o_wr_en  = 1'b0;
          ports.o_data_in= 8'b0;
          @ (posedge ports.i_clk); 
         end
         ports.o_wr_cs  = 1'b1;
         ports.o_wr_en  = 1'b1;
         ports.o_data_in= data;
      end
      @ (posedge ports.i_clk);
      ports.o_wr_cs  = 1'b0;
      ports.o_wr_en  = 1'b0;
      ports.o_data_in= 8'b0;
      repeat (10) @ (posedge ports.i_clk);
      wrDone = 1;
    end
    endtask

    task genPop();
    begin
      integer i = 0;
      for ( i  = 0; i < rd_cmds; i++)  begin
         @ (posedge ports.i_clk);
         while (ports.i_empty== 1'b1) begin
           ports.o_rd_cs  = 1'b0;
           ports.o_rd_en  = 1'b0;
           @ (posedge ports.i_clk); 
         end
         ports.o_rd_cs  = 1'b1;
         ports.o_rd_en  = 1'b1;
      end
      @ (posedge ports.i_clk);
      ports.o_rd_cs   = 1'b0;
      ports.o_rd_en   = 1'b0;
      repeat (10) @ (posedge ports.i_clk);
      rdDone = 1;
    end
    endtask

  endclass

endpackage
