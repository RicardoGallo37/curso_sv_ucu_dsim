//-----------------------------------------------------
// Design Name : ram_dp_ar_aw
// File Name   : ram_dp_ar_aw.v
// Function    : Asynchronous read write RAM
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module ram_dp_ar_aw (
  i_address_0,  // i_address_0 Input
  i_o_data_0,   // i_o_data_0 bi-directional
  i_cs_0,       // Chip Select
  i_we_0,       // Write Enable/Read Enable
  o_oe_0,       // Output Enable
  i_address_1,  // i_address_1 Input
  i_o_data_1,   // i_o_data_1 bi-directional
  i_cs_1,       // Chip Select
  i_we_1,       // Write Enable/Read Enable
  i_oe_1        // Output Enable
); 

  parameter DATA_WIDTH = 8 ;
  parameter ADDR_WIDTH = 8 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;

  //--------------Input Ports----------------------- 
  input [ADDR_WIDTH-1:0] i_address_0 ;
  input i_cs_0 ;
  input i_we_0 ;
  input o_oe_0 ; 
  input [ADDR_WIDTH-1:0] i_address_1 ;
  input i_cs_1 ;
  input i_we_1 ;
  input i_oe_1 ; 

  //--------------Inout Ports----------------------- 
  inout [DATA_WIDTH-1:0] i_o_data_0 ; 
  inout [DATA_WIDTH-1:0] i_o_data_1 ;

  //--------------Internal variables---------------- 
  logic [DATA_WIDTH-1:0] data_0_out ; 
  logic [DATA_WIDTH-1:0] data_1_out ;
  logic [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

  //--------------Code Starts Here------------------ 
  // Memory Write Block 
  // Write Operation : When i_we_0 = 1, i_cs_0 = 1
  always @ (i_address_0 or i_cs_0 or i_we_0 or i_o_data_0
  or i_address_1 or i_cs_1 or i_we_1 or i_o_data_1) begin : MEM_WRITE
    if ( i_cs_0 && i_we_0 ) begin
       mem[i_address_0] <= i_o_data_0;
    end else begin 
      if (i_cs_1 && i_we_1) begin
        mem[i_address_1] <= i_o_data_1;
      end
    end
  end

  // Tri-State Buffer control 
  // output : When i_we_0 = 0, o_oe_0 = 1, i_cs_0 = 1
  assign i_o_data_0 = (i_cs_0 && o_oe_0 && !i_we_0) ? data_0_out : 8'bz; 

  // Memory Read Block 
  // Read Operation : When i_we_0 = 0, o_oe_0 = 1, i_cs_0 = 1
  always @ (i_address_0 or i_cs_0 or i_we_1 or o_oe_0) begin : MEM_READ_0
    if (i_cs_0 && !i_we_0 && o_oe_0) begin
      data_0_out <= mem[i_address_0]; 
    end else begin
      data_0_out <= 0; 
    end
  end

  //Second Port of RAM
  // Tri-State Buffer control 
  // output : When i_we_0 = 0, o_oe_0 = 1, i_cs_0 = 1
  assign i_o_data_1 = (i_cs_1 && i_oe_1 && !i_we_1) ? data_1_out : 8'bz; 
  // Memory Read Block 1 
  // Read Operation : When i_we_1 = 0, i_oe_1 = 1, i_cs_1 = 1
  always @ (i_address_1 or i_cs_1 or i_we_1 or i_oe_1) begin : MEM_READ_1
    if (i_cs_1 && !i_we_1 && i_oe_1) begin
      data_1_out <= mem[i_address_1];
    end else begin
      data_1_out <= 0; 
    end
  end

endmodule // End of Module ram_dp_ar_aw
