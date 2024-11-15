// Synthezizable RegisterFile
// Start Date: Aug 24, 2021 (ACR)
// Revisions: 0.1 (ACR) Initial proposal based on Franzen/Smith. Spec #9.
//            Using traditional UP/DN counter. Will implement LFSR later
// Primitives are taken from RGR's library

   `include "bus_definitions.sv" //Compile the package
   `include "./RegFile.sv"
//We'll use the interface defined above to check
module fifosc( 
    input   logic clk,        //General clock
    input   logic reset_fifo, //Flush the whole FIFO, reset pointers
    input   logic push,       //Insert word into FIFO
    input   logic pop,        //Remove word off FIFO
    output  logic pndng,      //FIFO not empty yet
    output  logic full,       //FIFO's full

    input  logic [ws-1:0] DataIn, //FIFO's input data
    output logic [ws-1:0] DataOut //FIFO's registered output data

); 

logic [as-1:0] wp, wp_prev, wpo, wpo_prev; //Pipelined Write pointers
logic [as-1:0] rp, rp_prev, rpo, rpo_prev; //Pipelined Read pointers
logic          inc_wp, inc_rp, wr_RF, rd_RF; //Pointer and RF control
logic          pndng_prev, full_prev;       //Previous pndng and full flags
logic          data_out_en;       //If we enable pasing the data from the RF to the output


wire [ws-1:0] DataRd;  //RFs output to be registered

// This is the memory bank, register file style. Wire accordingly.
RegFile RF1(.DataIn(DataIn), .DataOut(DataRd), .clk(clk),
            .reset(reset_fifo), .wr(wr_RF), .rd(rd_RF), .AddrWr(wp), .AddrRd(rp));

//FSM state register
fifo_fsm_states_t state, next_state; // FSM's logic signals
fifo_state_bit_t state_bit;          //Active bit in the HotBit coding


//State and output registers

//Place here the State Register for the FSM
always_ff @( posedge clk, posedge reset_fifo ) begin : StateRegister
    if (reset_fifo)
        state <= idle;
    else 
        state <= next_state;
 end //State register
    

// This registers pndng, full
always_ff @( posedge clk, posedge reset_fifo ) begin : Pndng_full_Register
    if (reset_fifo) begin
        pndng <= 1'b0;
        full <= 1'b0;
    end
    else begin
        pndng <= pndng_prev;
        full <= full_prev;
    end
end 

//Output register
always_ff @( posedge clk, posedge reset_fifo ) begin : OutputRegister
    if (reset_fifo) begin
        DataOut <= '0;
    end
    else if (data_out_en)
        DataOut <= DataRd;
    
end 

//One can use a reverse case statement style (see p 212, Sutherland, System Verilog for Design)
//In order to use a more efficient One-Hot coding
// Still, here we use the traditional case style
//Check bus_definitions package for type definitions
// One can either, push, pop or push and pop concurrently
// idle_bit =  0, remove_bit = 1, insert_bit = 2, insert_remove_bit=3

always_comb begin : FSM_Next_State_logic
    next_state = state; //default state

    unique case ({pop, push}) //Normal case statement
        2'b00: next_state = idle;//We do nothing

        2'b01: next_state = remove;

        2'b10: next_state = insert;

        2'b11: next_state = insert_remove;
    endcase

end: FSM_Next_State_logic

always_comb begin : output_logic
    //first default outputs
    inc_wp = 1'b0;
    inc_rp = 1'b0;
    rd_RF  = 1'b0;
    wr_RF  = 1'b0;
    pndng_prev = pndng; // By default we keep the flags
    full_prev  = full;
    data_out_en = 1'b0;
    
    unique case ({pop, push})  //Normal caase
        2'b00: ;
                //We do nothing

        2'b01: if (~full) begin //We insert a word
                  wr_RF=1'b1;
                  inc_wp=1'b1; //and we increment the write pointer at next posedge clock
                  pndng_prev = 1'b1; //If we are inserting a word, then FIFO cannot be empty
                  //we have to check now whether FIFO is going to be full after this insertion
                  if (wp==rpo) //If our current Write Pointer is already one count behind the Read Pointer
                                //Then after this push, FIFO is going to be full
                    full_prev= 1'b1;
                  end


        2'b10: if (pndng) begin //We remove a word
                  rd_RF=1'b1;
                  inc_rp=1'b1; //and we increment the read pointer
                  full_prev=1'b0; //If we remove a word, the FIFO cannot be full
                  data_out_en = 1'b1; //If we have a valid pop, we let the RF[rp] word into the ouput register. 
                //we have to check now whether FIFO is going to be empty after this insertion
                  if (rp==wpo) //If our current Read Pointer is already one count behind the Write Pointer
                                //Then after this pop, FIFO is going to be empty
                    pndng_prev= 1'b0;
                end
                
        2'b11: if (~full && pndng) begin //We remove a word and insert a word concurrently
                 //Flags must remain in the state they were before
                  rd_RF=1'b1;           //We read and write concurrently
                  wr_RF=1'b1;
                  inc_rp=1'b1;          //and we increment the write and read pointers
                  data_out_en = 1'b1;  //If we have a valid pop, we let the RF[rp] word into the ouput register. 
                  inc_wp=1'b1;
                end
    endcase

end:output_logic

// Write and Read Pointers
always_ff @( posedge clk, posedge reset_fifo )  begin : WR_RD_Pointers
      if (reset_fifo) begin
        wp <= 0;
        rp <= 0;
        wpo <= -1; // Pipelined pointer sent one count behind
        rpo <= -1; //
    end
    else begin //We increment the counters depending on what the FSM says
        if (inc_wp) begin //increment WritePointer
           wpo <= wp;
           wp <= wp+1; 
        end
        if (inc_rp) begin //increment ReadPointer
        rpo <= rp;       
        rp <= rp+1; 
        end        
    end  
end

endmodule //fifosmodule
