// `timescale 1ns/1ps
module cnt_tb;

  logic clk;

  import definitions_pkg::*; // Defintions package imported

  // TB Clock Generator used to provide the design
  // with a clock -> here half_period = 10ns => 50 MHz
  always #10 clk = ~clk;

  // Instantiate the interface here
  ?? //Interface is instantiated

  // connect the counter here

 ??  counter_ud  c0 ( .i_clk      (??),
                      .i_rstn     (??),
                      .i_load     (??),
                      .i_load_en  (??),
                      .i_down     (??),
                      .o_rollover (??),
                      .o_count    (??));

  initial begin
    bit load_en, down;
    bit [3:0] load;

    $monitor("[%0t] down=%0b load_en=%0b load=0x%0h count=0x%0h rollover=%0b",
      $time, cnt_if0.down, cnt_if0.load_en, cnt_if0.load, cnt_if0.count, cnt_if0.rollover);

    // Initialize testbench variables
    clk = 0;
    ?? = 0;
    ?? = 0;
    ?? = 0;
    ?? = 0;

    // Drive design out of reset after 5 clocks
    repeat (5) @(posedge clk);
      ?? = 1; // Drive stimulus -> repeat 5 times
    for (int i = 0; i < 5; i++) begin

      // Drive inputs after some random delay
      static int delay = $urandom_range (1,30);
      #(delay);

      // Randomize input values to be driven
      std::randomize(load, load_en, down);

      // Assign tb values to interface signals
      ??   = load;
      ??  = load_en;
      ??    = down;
    end

    // Wait for 5 clocks and finish simulation
    repeat(5) @ (posedge clk);
    $finish;
  end

endmodule
