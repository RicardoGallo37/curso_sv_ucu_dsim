// Synthezizable RegisterFile
// Start Date: Aug 16, 2021 (ACR)
// Revisions
//
// Primitives are taken from RGR's library

module RegFile (
   input logic [WS-1:0] i_DataIn,
   input logic i_clk,
   input logic i_reset,
   input logic i_wr,
   input logic i_rd,
   input logic [AS-1:0] i_AddrRd,
   input logic [AS-1:0] i_AddrWr,
   inout logic [WS-1:0] o_DataOut
);

   //parameter WS = 4, DEPTH=8, AS=$clog2(DEPTH); 
   //WS = wordsize in bits, DEPTH= FIFO's DEPTH (number of words in FIFO)
   //Come from the package definitions in bus_definitions.pkg

   // Internal signals
   // For input/output decos
   // Determine the right indexing

    logic [???] InEn; // Wiring for selection of InData
    logic [???] OutEn; // Wiring for selection of OutData

   // Wiring for the RF's outputs
   // Determine the right indexing

   logic [???] RF_Q [???]; // Wiring for data coming out of the RF

   // First we need the decos for input/output
   // These decos get the address for reading and writing and generate the decoded
   // control that enables the input register in the RF to be written or the
   // output register to be read from the RF accordingly. 

   //Input Deco
   // Wire the correct control signals

   generic_deco_N_M  #($clog2(DEPTH),DEPTH) deco_In(.En(i_wr), .N(i_AddrWr), .M(InEn));

   //Output Deco
   // Wire the correct control signals
   generic_deco_N_M #($clog2(DEPTH),DEPTH) deco_Out(.En(??),.N(??),.M(??));

   //
   // RF instantiation (DEPTH is the number of WS-bit sized FFs )
   //
   // InEn[DEPTH-1:0] are the Enables for the FFs
   // RF_Q[i] es la salida de cada FF individual del RF
   // OutEn[DEPTH-1:0] are the Enables for the buffers

   genvar i,j;
   generate
      for (???) begin: FFx_
         assign enable_in_ =???;
         prll_d_en_reg #(WS) rf_ff_bank_(.i_clk(i_clk), .i_reset(i_reset),.wr_en(??),.D_in(??), .D_out(???));
      end
   endgenerate

   //We generate the Ouput Mux (3-state WS-sized buffers actually)
   // OutEn[DEPTH-1:0] are the Enables for the buffers
   // o_DataOut[i] is the WS-bit sized individual output of each buffer that generates o_DataOut[DEPTH-1:0] 
    // We need to generate the WS-sized buffers in another module: tri_buf_N
   // Careful here: tri_buf_N uses the same convention AS the bufif primitive, i.e. (output, input, control)
   //               We'd better use explicit assignment
   genvar k;
   generate
      for (k=0; k< DEPTH; k=k+1)
      begin:buffer_x1
         assign enable_out =(OutEn[k]);
         tri_buf_N #(WS) tri_buf_ws_(.Y(o_DataOut), .X(RF_Q[k]), .enable(enable_out));
      end
   endgenerate

endmodule
