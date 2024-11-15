
module mult_with_no_fsm#(
  parameter N = 8
)(
  input   logic                           i_clk,
  input   logic                           i_rst,
  input   logic [N-1:0]                   i_A,
  input   logic [N-1:0]                   i_B,
  input   definitions_pkg::mult_control_t i_mult_control,
  output  logic [2]                       o_Q_LSB,
  output  logic [2*N-1:0]                 o_Y
);

  import definitions_pkg::*;

  logic [N-1:0] M;
  logic [N-1:0] adder_sub_out ;
  logic [2*N: 0 ] shift ;
  logic [N-1:0] HQ;
  logic [N-1:0] LQ;
  logic Q_1;

  //reg_M
  always_ff@ (posedge i_clk , i_rst ) begin
    if ( i_rst ) begin
      M <= 'b0 ;
    end else begin
        M <= (i_mult_control.load_A) ? i_A : M;
    end
  end

  // adder / sub
  always_comb begin
    if (i_mult_control.add_sub ) begin
      adder_sub_out = M + HQ;
    end else begin
      adder_sub_out = M - HQ;
    end
  end

  // shift registers
  always_comb begin
    o_Y     = {HQ,LQ} ;
    HQ      = shift[2*N:N+1];
    LQ      = shift[N:1];
    Q_1     = shift[0];
    o_Q_LSB = {LQ[0] ,Q_1};
  end

  always_ff@ (posedge i_clk , i_rst ) begin
    if ( i_rst ) begin
      shift <= 'b0 ;
    end else begin
      if (i_mult_control.shift_HQ_LQ_Q_1) begin
        // arithmetic shift
        shift <= $signed (shift)>>>1;
      end else begin
        if ( i_mult_control.load_B ) begin
            shift [N:1] <= i_B;
        end
        if ( i_mult_control.load_add ) begin
            shift [2*N:N+1] <= adder_sub_out;
        end
      end
    end
  end

endmodule
