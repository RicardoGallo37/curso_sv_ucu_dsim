
class reg_item;
  // This is the base transaction object that will be used
  // in the environment to initiate new transactions and
  // capture transactions at DUT interface
  rand 	bit [7:0] 	addr;
  rand 	bit [15:0] 	wdata;
  		  bit [15:0] 	rdata;
  rand 	bit 		wr;

  // This function allows us to print contents of the data packet
  // so that it is easier to track in a logfile
  function void print(string tag="");
    $display ("T=%0t [%s] addr=0x%0h wr=%0d wdata=0x%0h rdata=0x%0h",
              			$time, tag, addr, wr, wdata, rdata);
  endfunction
endclass

// The driver is responsible for driving transactions to the DUT
// All it does is to get a transaction from the mailbox if it is
// available and drive it out into the DUT interface.
class driver;
  virtual reg_if vif;
  event drv_done;
  mailbox drv_mbx;

  task run();
    $display ("T=%0t [Driver] starting ...", $time);
    @ (posedge vif.clk);

    // Try to get a new transaction every time and then assign
    // packet contents to the interface. But do this only if the
    // design is ready to accept new transactions
    forever begin
      reg_item item;

      $display ("T=%0t [Driver] waiting for item ...", $time);
      drv_mbx.get(item);
	  item.print("Driver");
      vif.sel <= 1;
      vif.addr 	<= item.addr;
      vif.wr 	<= item.wr;
      vif.wdata <= item.wdata;
      @ (posedge vif.clk);
      while (!vif.ready)  begin
        $display ("T=%0t [Driver] wait until ready is high", $time);
        @(posedge vif.clk);
      end

      // When transfer is over, raise the done event
      vif.sel <= 0; ->drv_done;
    end
  endtask
 
endclass

// The monitor has a virtual interface handle with which it can monitor
// the events happening on the interface. It sees new transactions and then
// captures information into a packet and sends it to the scoreboard
// using another mailbox.
class monitor;
  virtual reg_if vif;
  mailbox scb_mbx; 		// Mailbox connected to scoreboard

  task run();
    $display ("T=%0t [Monitor] starting ...", $time);

    // Check forever at every clock edge to see if there is a
    // valid transaction and if yes, capture info into a class
    // object and send it to the scoreboard when the transaction
    // is over.
    forever begin
      @ (posedge vif.clk);
      if (vif.sel) begin
        reg_item item = new;
        item.addr = vif.addr;
        item.wr = vif.wr;
        item.wdata = vif.wdata;

        if (!vif.wr) begin
          @(posedge vif.clk);
        	item.rdata = vif.rdata;
        end
        item.print("Monitor");
        scb_mbx.put(item);
      end
    end
  endtask
endclass

// The scoreboard is responsible to check data integrity. Since the design
// stores data it receives for each address, scoreboard helps to check if the
// same data is received when the same address is read at any later point
// in time. So the scoreboard has a "memory" element which updates it
// internally for every write operation.
class scoreboard;
  mailbox scb_mbx;

  reg_item refq[256];

  task run();
    forever begin
      reg_item item;
      scb_mbx.get(item);
      item.print("Scoreboard");

      if (item.wr) begin
        if (refq[item.addr] == null)
          refq[item.addr] = new;

        refq[item.addr] = item;
        $display ("T=%0t [Scoreboard] Store addr=0x%0h wr=0x%0h data=0x%0h", $time, item.addr, item.wr, item.wdata);
      end

        if (!item.wr) begin
          if (refq[item.addr] == null)
            if (item.rdata != 'h1234)
              	$display ("T=%0t [Scoreboard] ERROR! First time read, addr=0x%0h exp=1234 act=0x%0h",
                        											$time, item.addr, item.rdata);
          	else
          		$display ("T=%0t [Scoreboard] PASS! First time read, addr=0x%0h exp=1234 act=0x%0h",
                    												$time, item.addr, item.rdata);
          else
            if (item.rdata != refq[item.addr].wdata)
              $display ("T=%0t [Scoreboard] ERROR! addr=0x%0h exp=0x%0h act=0x%0h",
                        $time, item.addr, refq[item.addr].wdata, item.rdata);
           else
             $display ("T=%0t [Scoreboard] PASS! addr=0x%0h exp=0x%0h act=0x%0h",
                       $time, item.addr, refq[item.addr].wdata, item.rdata);
        end
    end
  endtask
endclass

// The environment is a container object simply to hold all verification
// components together. This environment can then be reused later and all
// components in it would be automatically connected and available for use
// This is an environment without a generator.
class env;
  driver 			  d0; 		// Driver to design
  monitor 			m0; 		// Monitor from design
  scoreboard 		s0; 		// Scoreboard connected to monitor
  mailbox 			scb_mbx; 	// Top level mailbox for SCB <-> MON
  virtual reg_if 	vif; 		// Virtual interface handle

  // Instantiate all testbench components here
  // 
  function new();
    d0 = ??; //driver here
    m0 = ??; //monitor here
    s0 = ??; //scoreboard here
    scb_mbx = new();  //generate the mailbox
  endfunction

  // Assign handles and start all components so that
  // they all become active and wait for transactions to be
  // available
  virtual task run();
    d0.?? = ??; //connect the driver and monitor interfaces
    m0.?? = ??;
    m0.?? = ??; //connect the mailboxes
    s0.?? = ??;

    fork //start the driver, the monitor, and the scoreboard, on separate threads
    	s0.??; //Call the required methods
		  d0.??;
    	m0.??;
    join_any
  endtask


endclass

// an environment without the generator and hence the stimulus should be
// written in the test.
class new_test;
  env e0;
  mailbox drv_mbx;

  function new();
    drv_mbx = new();
    e0 = new();
  endfunction

  virtual task run();
    e0.d0.drv_mbx = drv_mbx;

    fork
    	e0.run();
    join_none

    apply_stim();
  endtask

  virtual task apply_stim();
    reg_item item;

    $display ("T=%0t [Test] Starting stimulus ...", $time);
    item = new;
    //item.randomize() with { addr == 8'haa; wr == 1; };
    item.wr = 1;
    item.addr = 8'haa;
    item.wdata = $random;
    drv_mbx.put(item);

    item = new;
    //item.randomize() with { addr == 8'haa; wr == 0; };
    item.wr = 0;
    item.addr = 8'haa;
    item.wdata = $random;
    drv_mbx.put(item);
  endtask
endclass



//endpackage

//`endif
