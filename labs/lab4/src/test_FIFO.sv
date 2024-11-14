`timescale 1ns/100ps
// We're going to use some basic SV features, but not UVM still

module test_FIFO;
  import bus_definitions::*; //Import Bus Definitions package into $unit

  parameter CLK_PER = 10 ;
  integer i;

  logic clk;                    //master clock
  logic push, pop, reset_fifo; //push, pop, reset_fifo signals
  logic pndng, full;          //Status variables from FIFO

  // Input and output data from FIFO                  
  logic [WS-1:0] DataIn;
  logic [WS-1:0] DataOut;

  //We're using the default definitions. modify for larger FIFOs
  //parameter WS = 4, DEPTH=8, AS=$clog2(DEPTH);

  // This is the FIFO
  fifosc FIFO1(.i_DataIn(DataIn), .o_DataOut(DataOut), .i_clk(clk),
              .i_reset_fifo(reset_fifo), .i_push(push), .pop(pop), .pndng(pndng), .full(full));


initial 
  begin
    //$dumpfile("./test_FIFO.vcd"); //In order to get the VCD dump from Icarus
    //$dumpvars(0,test_FIFO);
    push=0;
    pop=0;
    reset_fifo=0;
    DataIn=0;
    @(negedge clk) reset_fifo =1;
    //We flush the FIFO
    wait_task(2); //wait_task is a task that waits for the indicated clock cycles
    @(negedge clk) reset_fifo =0;
    //attempt concurrent push-pop when FIFO empty. nothing shoud happen
    push=1'b1;
    pop =1'b1; 
    @(negedge clk) DataIn=DataIn + 1; 

    //Attempt to push 10 words
    push=1'b1;
    pop=1'b0;
    for (i=0; i<=9; i=i+1) 
     @(negedge clk) DataIn=DataIn + 1; //-test for full at 8th word, error on 9 and 10

    //attempt concurrent push-pop when FIFO full
    push=1'b1; //
    pop =1'b1; //
    @(negedge clk) DataIn=DataIn + 1;

    //attempt to pop 10 words
    push=1'b0; 
    pop =1'b1; //- test for empty at 8th, error on 9 and 10
    for (i=0; i<=9; i=i+1) 
      @(negedge clk);

    //Push 3 words
    push=1'b1; 
    pop=1'b0;
    for (i=0; i<=2; i=i+1) //
     @(negedge clk) DataIn=DataIn + 1; //-test all words are in

    //Concurrent Push-Pop 4
    push=1'b1; 
    pop=1'b1;
    for (i=0; i<=3; i=i+1) //
     @(negedge clk) DataIn=DataIn + 1; //-test 7 and 8, inserted in error, missing

    //Attempt to pop 4 words
    push=1'b0; 
    pop=1'b1;
    for (i=0; i<=3; i=i+1) //
     @(negedge clk); //-test on empty on 3rd     

    $finish;
  end



// Clock generator
initial   
      begin
			clk=0;
			#1 forever #(CLK_PER/2) clk=~clk;

      end 
    
//Task for reading the memory. Performs in a clock cycle
/*task readRF (input [AS-1:0] addr);
    //We use some delay in order to simulate the RF setup/hold time
    @(negedge clk) AddrRd=addr;
    #1 rd=1;
    @(negedge clk) rd=0; //We have to first remove the rd signal
    #1 AddrRd=0;
 
endtask*/

//Task for writing the memory. Performs in a clock cycle
/*task writeRF (
    input [AS-1:0] addr,
    input [WS-1:0] data_in);
    //We use some delay in order to simulate the RF setup time
    @(negedge clk) AddrWr=addr;
    DataWr=data_in;
    #1 wr=1;
    @(negedge clk) wr=0;
    #1 AddrWr=0;
endtask */


//Procedure that waits <index> clock cycles 
task wait_task (input integer index);
	//Index is the clock cycles to wait
   integer	j; //for counting variable
            //$display("Call to wait for T=\t\index,\tclk");
            //$display("\t%d, \t%b", index, clk);
            for (j=1; j<=index; j=j+1) //
              @(posedge clk);
              //#10;

endtask	


  initial begin

      $monitor("At time %t, clk= %b   reset_fifo= %b push = %b DataIn = %h pop = %b DataOut = %h full = %b pndng = %b ",
              $time, clk, reset_fifo, push, DataIn, pop, DataOut, full, pndng);
  end
     

endmodule
