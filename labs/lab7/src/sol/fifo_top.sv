
module fifo_top (fifo_ports ports, fifo_monitor_ports mports);

  import fifo_driver_pkg::*;

  fifo_driver driver = new(ports, mports);

  initial begin
    driver.go();
  end

//endprogram
endmodule
