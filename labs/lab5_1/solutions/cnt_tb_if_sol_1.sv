// Testbench solution for using interfaces in the tb
`timescale 1ns/1ps
module cnt_tb;
   logic clk;

   import definitions_pkg::*; // Defintions package imported

  // TB Clock Generator used to provide the design
  // with a clock -> here half_period = 10ns => 50 MHz
  always #10 clk = ~clk;

  cnt_if 	  cnt_if0 (clk); //Interface is instantiated

  counter_ud  c0 ( 	.clk 		(cnt_if0.clk),
                  	.rstn 		(cnt_if0.rstn),
                  	.load 		(cnt_if0.load),
                  	.load_en 	(cnt_if0.load_en),
                  	.down 		(cnt_if0.down),
                  	.rollover 	(cnt_if0.rollover),
                  	.count 		(cnt_if0.count));

  initial begin
    bit load_en, down;
    bit [3:0] load;

    $monitor("[%0t] down=%0b load_en=%0b load=0x%0h count=0x%0h rollover=%0b",
    	$time, cnt_if0.down, cnt_if0.load_en, cnt_if0.load, cnt_if0.count, cnt_if0.rollover);

    // Initialize testbench variables
    clk = 0;
    cnt_if0.rstn = 0;
    cnt_if0.load_en = 0;
    cnt_if0.load = 0;
    cnt_if0.down = 0;

    // Drive design out of reset after 5 clocks
    repeat (5) @(posedge clk);
    cnt_if0.rstn = 1; // Drive stimulus -> repeat 5 times
    for (int i = 0; i < 5; i++) begin

      // Drive inputs after some random delay
      static int delay = $urandom_range (1,30);
      #(delay);

      // Randomize input values to be driven
      std::randomize(load, load_en, down);

      // Assign tb values to interface signals
      cnt_if0.load    = load;
      cnt_if0.load_en = load_en;
      cnt_if0.down    = down;
    end

    // Wait for 5 clocks and finish simulation
    repeat(5) @ (posedge clk);
    $finish;
  end
endmodule