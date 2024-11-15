package bus_definitions;

  parameter VERSION = "Rydev DSim System Verilog Course";
  //General sizing parameters for the FIFOs dimensions and the bus width
  //WS = wordsize in bits, DEPTH= FIFO's DEPTH (number of words in FIFO),
  //AS = $clog2(DEPTH) Address size for the FIFO
  //the are given AS package parameter definitions in bus_definitions.sv
  parameter WS = 4, DEPTH=8, AS=$clog2(DEPTH);
  //Type definitions for the FIFO State Machines
  //One can also use a reverse case statement style (see p 212, Sutherland, System Verilog for Design)
  //In order to use a more efficient One-Hot coding
  typedef enum {idle_bit         = 0,
                remove_bit        = 1,
                insert_bit        = 2,
                insert_remove_bit = 3} fifo_state_bit_t;

  //Shift a 1 to the bit representing each state
  typedef enum logic [3:0] {idle   = 4'b0001 << idle_bit, 
                            remove = 4'b0001 << remove_bit,
                            insert = 4'b0001 << insert_bit,
                            insert_remove = 4'b0001 << insert_remove_bit } fifo_fsm_states_t; 
                            //FSM states to determine whether to pop and/or push from the Register File

endpackage
