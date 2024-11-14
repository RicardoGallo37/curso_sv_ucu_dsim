module mux_tb;

  parameter DEPTH = 8; 
  parameter WORD_SIZE = 8; 

  logic [$clog2(DEPTH)-1:0] select_in; //This variable is going to be random, to start using SV particular capabilities
  logic [WORD_SIZE-1:0]     mux_in[(DEPTH)-1:0]; //Input vector
  logic [DEPTH-1:0]         mux_out;
  logic [WORD_SIZE-1:0]     mux_in_sel; //A temporal variable to store the word we want to sent thought the mux
  int errors;


  param_mux #(
    .DEPTH(DEPTH),
    .WORD_SIZE(WORD_SIZE)
  ) deco_u1 (
    .i_select(select_in),    //  N-bit select input
    .i_input_signal(mux_in),  //  M-bit out 
    .o_out(mux_out)       //  Enable for the decoder
  );

  initial begin
    $monitor("[%0t]\t select_in=%d\t mux_in_sel=%d\t mux_out=%d",
    $time, select_in, mux_in_sel, mux_out);
    // First, let's ramdomnly populate the input array
    // We'll do it first using the typical Verilog way
    
    for (int i = 0; i < DEPTH; i++) begin
      mux_in[i]= $random;
    end 
    select_in = 0;
    // --- > How could you replace the former lines for a more compact ramdomization? 
    // Check the following code to give you and idea and test your idea after succesfully running the simulation
    // at least a couple of times
  
    // Now, let's ramdomly chose some 5 selections to see what comes out
    // If the mux doesn't ouput what is expected, simulation is terminated with an error
    repeat (6) begin
      // Drive inputs after some random delay
      static int delay = $urandom_range (1,30);
      #(delay);
      //randomize the selection
      randomize(select_in); //
      #1 mux_in_sel = mux_in[select_in];
       if (mux_in[select_in] !== mux_out) begin  // check result
        $display("  Error: select = %d", select_in);
        $display("  Output = %d (%d expected)",mux_out, mux_in[select_in]);
        errors = errors + 1;
      end
    end
    #2 $display("6 tests completed with %d errors", 
             errors); 
    #5 $finish;
  end

endmodule
