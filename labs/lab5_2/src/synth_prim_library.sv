// Synthezizable RegisterFile
// Start Date: Aug 16, 2021 (ACR)
// Revisions: 0.1 Library is created from RGR's library. Syntax updated to SV
//         
//
// Primitives are based on RGR's library
// RGR's  library was created by Ronny Garcia-Ramirez. Is an RTL (structured) synthesizable primitives library (2021)
//

////////////////////////////////////////////////////////////////////////
// Definition of an in order counter from 0 to a parametrized number //
////////////////////////////////////////////////////////////////////////
  

module Counter#(parameter mx_cnt = 32) (
  output logic [$clog2(mx_cnt)-1:0] count,
  input  logic i_clk,
  input  logic rst);
 
     

  always_ff @(posedge i_clk, posedge rst)
       if (rst)
           count <= 0;
       else
         count <= count +1;
endmodule


//////////////////////////////////////////////////////////
// Definition of a third state buffer  //
/////////////////////////////////////////////////////////

module tri_buf (
    input  logic a,
    output logic cb,
    input  logic en);
 
    
   assign b = (en) ? a : 1'bz;
     	  	 
endmodule


//////////////////////////////////////////////////////////////////////
// Definition of a D flip flop with asyncronous i_reset, writing enable  //
/////////////////////////////////////////////////////////////////////

module dff_async_rst_en (
  input  logic data,
  input  logic i_clk,
  input  logic i_reset,
  input  logic i_wr_en,
  output logic q);

  always_ff @ ( posedge i_clk, posedge i_reset)    
    if (i_reset) begin
      q <= 1'b0;
    end  
      else if (i_wr_en) begin
            q <= data;
            end

endmodule

//////////////////////////////////////////////////////////
// Definition of a D flip flop with asyncronous i_reset  //
/////////////////////////////////////////////////////////

module dff_async_rst (
  input  logic data,
  input  logic i_clk,
  input  logic i_reset,
  output reg q);

  always_ff @ ( posedge i_clk, posedge i_reset)    
    if (i_reset) begin
      q <= 1'b0;
    end  else begin
      q <= data;
    end

endmodule

//////////////////////////////////////////////////////////
// Definition of a D Latch  with asyncronous i_reset  //
/////////////////////////////////////////////////////////

module dltch_async_rst (
  input  logic data,
  input  logic i_clk,
  input  logic i_reset,
  output logic q);

  always_latch   
    if (i_reset) begin
      q <= 1'b0;
    end  else if (i_clk) begin
      q <= data;
    end

endmodule

//////////////////////////////////////////////////////////
// Definition of a D Latch  without  i_reset  //
/////////////////////////////////////////////////////////

module dltch (
  input data,
  input i_clk,
  output reg q);

  always_latch    
    if (i_clk) begin
      q <= data;
    end

endmodule

///////////////////////////////////////////////////////////////////////
// Definition of the prll D register with flops
///////////////////////////////////////////////////////////////////////

module prll_d_reg #(parameter BITS = 32)(
  input  logic i_clk,
  input  logic i_reset,
  input  logic [BITS-1:0] i_D_in,
  output logic [BITS-1:0] o_D_out
);
  genvar i;
  generate
    for(i = 0; i < BITS; i=i+1) begin:bit_
      dff_async_rst prll_regstr_(.data(i_D_in[i]),.i_clk(i_clk),.i_reset(i_reset),.q(o_D_out[i]));
    end
  endgenerate

endmodule

///////////////////////////////////////////////////////////////////////
// Definition of the prll D register with flops (enabled writing)
///////////////////////////////////////////////////////////////////////

module prll_d_en_reg #(parameter BITS = 32)(
  input  logic i_clk,
  input  logic i_reset,
  input  logic i_wr_en,
  input  logic [BITS-1:0] i_D_in,
  output logic [BITS-1:0] o_D_out
);
  genvar i;
  generate
    for(i = 0; i < BITS; i=i+1) begin:bit_
      dff_async_rst_en prll_regstr_en_(.data(i_D_in[i]),.i_clk(i_clk),.i_reset(i_reset),.q(o_D_out[i]),.i_wr_en(i_wr_en));
    end
  endgenerate

endmodule

///////////////////////////////////////////////////////////////////////
// Definition of the prll D register with latches 
///////////////////////////////////////////////////////////////////////

module prll_d_ltch_no_rst #(parameter BITS = 32)(
  input  logic i_clk,
  input  logic [BITS-1:0] i_D_in,
  output logic [BITS-1:0] o_D_out
);
  genvar i;
  generate
    for(i = 0; i < BITS; i=i+1) begin:bit_
      dltch prll_regstr_(.data(i_D_in[i]),.i_clk(i_clk),.q(o_D_out[i]));
    end
  endgenerate

endmodule

///////////////////////////////////////////////////////////////////////
// Definition of the prll D register with latches 
///////////////////////////////////////////////////////////////////////

module prll_d_ltch #(parameter BITS = 32)(
  input  logic i_clk,
  input  logic i_reset,
  input  logic [BITS-1:0] i_D_in,
  output logic [BITS-1:0] o_D_out
);
  genvar i;
  generate
    for(i = 0; i < BITS; i=i+1) begin:bit_
      dltch_async_rst prll_regstr_(.data(i_D_in[i]),.i_clk(i_clk),.i_reset(i_reset),.q(o_D_out[i]));
    end
  endgenerate

endmodule

// Synthesizable ws-bit sized 3-buf
// Start Date: Aug 17, 2021 (ACR)
// Revisions
//  0.1 - Initial code (ACR)
//
// Comments
// We generate a ws-bit sized tri-state buffer out of individual 3-buffers
// Careful here: we use the same convention as the bufif primitive (output, input, control)
module tri_buf_N (Y, X, enable);

parameter ws = 4;

input [ws-1:0] X ;
input enable ;

output [ws-1:0] Y;
wire   [ws-1:0] Y;

// We generate a ws-bit sized 3-state buffer out of individual 3-state buffers
genvar i;
generate
	for (i=0; i< ws; i=i+1)
	begin:buffer_x_
	   bufif1  buf_(Y[i],X[i], enable);
    end

endgenerate

endmodule

// Description:	Generic N to M deco, Size_input and Size_output define size
//						If not, a 3 to 8 deco is generated by default
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.1 - ACR. Updated after a very long time. Aug 16, 2021
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module generic_deco_N_M(En,N,M);
parameter Size_input=3,
		      Size_output=8; //N is the input size, M is the outputs
			 				//We could have used log2M to define N, check later (ACR)

	input   En; //Deco Enable
	input   [Size_input-1:0] N;
	output  [Size_output-1:0] M;
    reg     [Size_output-1:0] M;

	integer i;
	
	always@* //Check later if better to use always_comb, upgrade to SV

		if (!En) //If deco not enabled, all outputs to zero
		  M=0;
		else
		  if (N > Size_output-1)																  
		     for (i=0; i<= Size_output-1; i=i+1)
		        M[i]= 1'bx;
        else
			  for (i=0; i<= Size_output-1; i=i+1)
			     if  (N==i)//If index equal to value to decode
			 	     M[i]= 1'b1;
				  else
				     M[i]= 1'b0;
   
	//always

endmodule
