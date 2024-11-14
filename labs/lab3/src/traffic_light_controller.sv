module traffic_light_controller (
  input logic  i_clk,
  input logic  i_reset,
  input logic  i_car,

  output logic o_red, 
  output logic o_yellow, 
  output logic o_green
);

  typedef enum logic [1:0] {S0 = 2'b00,
                            S1 = 2'b01,
                            S2 = 2'b10,
                            S3 = 2'b11} state_vector;

  //state_vector current_state
  state_vector  current_state, next_state;

//logic o_red, o_yellow, o_green;

  /*------- Sequential Logic ----*/
  always_ff@(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      current_state <= S0;
    end else begin
      current_state <= next_state;
    end

  // next state logic
  always_comb begin
    //What would you need to add in order to check for a emergency input signal?
    unique case (current_state) // Ensure a paralell case (no priority)
      S0: begin 
      //Stay in SO while there is no i_car
              if (i_car) 
                  next_state = S1;
              else 
                  next_state = S0;
          end
      S1: begin
              next_state = S2; //Stay on S1 for one i_clk
          end
      S2 : begin
              next_state = S0; // Stay on S2 for one i_clk
          end
      default : next_state = S0;
    endcase
  end

  // output state logic
  always_comb begin
    o_red    = 0; 
    o_yellow = 0; 
    o_green  = 0;  // defaults to prevent latches
    unique case (current_state) // Ensure a paralell case (no priority)
      S0: begin
        o_red = 1; //o_Red light at first, while there is no i_car
      end
      S1: begin
        o_yellow     = 1;
      end
      S2 : begin
        o_green      = 1;
      end
      default : o_red = 1;
    endcase
  end

//What would you add in order to make the lights stay for several i_clk, with a higher speed i_clk?

endmodule
