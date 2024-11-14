//THis code is adapted from ASIC-World's tutorial at
//https://www.asic-world.com/verilog/art_testbench_writing3.html#Test_Case_3_-_Assert/De-assert_enable_and_reset_randomly.

module counter_ud_tb; 

  parameter WIDTH = 5;

  logic clk, reset, enable; 
  logic [WIDTH-1:0] count; 
  logic [WIDTH-1:0] count_compare; 

  counter_ud #(
    .N(WIDTH)) DUT // Testing a 5-bits Up counter
  (
    .i_clk    (clk), 
    .i_reset  (reset),
    .i_enable (enable),
    .o_q      (count) 
  );

//Providing initial value to signals   
  initial begin
    clk   = 0; 
    reset = 0;
    enable= 0; 
  end 

//Clock generator
  always  
    #5 clk = !clk; 
    
  //initial  begin
  //  $dumpfile ("counter.vcd"); 
  //  $dumpvars; 
  //end 

// Monitor for signals 
  initial  begin
    $display("\t\ttime,\tclk,\treset,\tenable,\tcount,\tcount_compare"); 
    $monitor("%d,\t%b,\t%b,\t%b,\t%d,\t%d",$time, clk,reset,enable,count, count_compare); 
  end 

// Event used to terminate simulation
  event terminate_sim;  
  initial begin  
  @ (terminate_sim); 
    #5 $finish; 
  end 

// What do you think is this part of the code doing?


always @ (posedge clk, posedge reset) 
if (reset == 1'b1)
  count_compare <= 0; 
else if ( enable == 1'b1) begin
  count_compare <= count_compare + 1; 
end

always @ (posedge clk) 
  if (count_compare != count) begin 
    $display ("DUT Error at time %d", $time); 
    $display (" Expected value %d, Got Value %d", count_compare, count); 
    #5 -> terminate_sim; 
  end 

//  Event used to reset trigger
  event reset_trigger; 
  event  reset_done_trigger; 
    
    initial
        forever begin 
            @ (reset_trigger); 
            @ (negedge clk); 
            reset = 1; 
            @ (negedge clk); 
            reset = 0; 
            -> reset_done_trigger; 
        end 

// Main testing procedure (TEST_CASE)
initial  //A random test of enable and reset
  begin : TEST_CASE 
    #10 -> reset_trigger; 
    @ (reset_done_trigger); 
    fork  // A fork clause separates processes and makes then concurrent 
          // Caution: Fork is not a synthesizable construct
      repeat (10) begin 
         @ (negedge clk); 
        enable = $random; 
      end	
      //repeat (10) begin 
      //  @ (negedge clk); 
      //  reset = $random; 
      //end 
    join 
    #5  -> terminate_sim;
  end 

endmodule //Of the whole Testbench module
