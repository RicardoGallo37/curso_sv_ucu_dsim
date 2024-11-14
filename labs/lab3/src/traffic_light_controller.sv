module traffic_light_controller (
  input logic i_clk,
  input logic i_reset,
  input logic i_car,

  output logic o_red, 
  output logic o_yellow, 
  output logic o_green
);

  typedef enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10,
    S3 = 2'b11 // This state is defined but not used in the current FSM
  } state_vector;

  // Current state and next state variables
  state_vector current_state, next_state;

  // Sequential logic for state transitions
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      current_state <= S0; // Reset to initial state
    end else begin
      current_state <= next_state; // Transition to next state
    end
  end

  // Combinational logic for next state transitions
  always_comb begin
    unique case (current_state) // Ensure a parallel case (no priority)
      S0: begin 
        if (i_car) 
          next_state = S1; // Move to S1 if car is detected
        else 
          next_state = S0; // Stay in S0 if no car
      end
      S1: next_state = S2; // Stay in S1 for one clock cycle
      S2: next_state = S0; // Stay in S2 for one clock cycle
      default: next_state = S0; // Default to S0
    endcase
  end

  // Combinational logic for output signals based on current state
  always_comb begin
    o_red = 0; 
    o_yellow = 0; 
    o_green = 0; // Defaults to prevent latches

    unique case (current_state) // Ensure a parallel case (no priority)
      S0: o_red = 1; // Red light in state S0
      S1: o_yellow = 1; // Yellow light in state S1
      S2: o_green = 1; // Green light in state S2
      default: o_red = 1; // Default to red light
    endcase
  end

  // Additional logic to extend the duration of the states
  // Add software timers using counters if necessary

endmodule
