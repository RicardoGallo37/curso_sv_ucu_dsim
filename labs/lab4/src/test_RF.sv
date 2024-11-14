`timescale 1ns/100ps

module test_RF;

    import bus_definitions::*; //Import Bus Definitions package into $unit

    parameter WS = 4, DEPTH=8, AS=$clog2(DEPTH);
    parameter clk_per = 20 ;
    integer i;
    reg  signed [AS-1:0] RndAddr;

    reg clk; //master clock
    reg wr, rd, reset;
    //reg push, pop;
    reg [AS-1:0] AddrWr, AddrRd;
    reg [WS-1 :0] DataWr;
    tri [WS-1 :0] DataRd;


// This is the memory bank, register file style
RegFile RF1(.DataIn(DataWr), .DataOut(DataRd), .clk(clk),
            .reset(reset), .wr(wr), .rd(rd), .AddrWr(AddrWr), .AddrRd(AddrRd));


initial begin
    //$dumpfile("./test_RF.vcd"); //In order to get the VCD dump from Icarus
    //$dumpvars(0,test_RF);
    wr=0;
    rd=0;
    AddrWr=0;
    AddrRd=0;
    reset=0;
    DataWr=0;
    
    @(negedge clk) reset =1;
    //We keep the reset for two cycles
    wait_task(2); //wait_task is a task tha waits for the indicated clock cycles
    @(negedge clk) reset =0;
    //First two writes at random followed by a read on the last position
    @(negedge clk);
    RndAddr=$random%AS; //AS-bit Random Address 
    wait_task(1); 
    writeRF(RndAddr,4'hA);
    //We wait 2 clocks
    wait_task(2);
    RndAddr=$random%AS; //AS-bit Random Address 
    writeRF(RndAddr, 4'h5);
    wait_task(2);
    readRF(RndAddr);
    wait_task(2);

    $finish;
end


// Clock generator
    initial   
      begin
			clk=0;
			#1 forever #(clk_per/2) clk=~clk;

      end 
    
//Task for reading the memory. Performs in a clock cycle
task readRF (input [AS-1:0] addr);
    //We use some delay in order to simulate the RF setup/hold time
    @(negedge clk) AddrRd=addr;
    #1 rd=1;
    @(negedge clk) rd=0; //We have to first remove the rd signal
    #1 AddrRd=0;
 
endtask

//Task for writing the memory. Performs in a clock cycle
task writeRF (
    input [AS-1:0] addr,
    input [WS-1 :0] data_in);
    //We use some delay in order to simulate the RF setup time
    @(negedge clk) AddrWr=addr;
    DataWr=data_in;
    #1 wr=1;
    @(negedge clk) wr=0;
    #1 AddrWr=0;
endtask


//Procedure that waits <index> clock cycles 
task wait_task ( input integer index);
	//Index is the clock cycles to wait
   integer	j; //for counting variable

   begin
            //$display("Call to wait for T=\t\index,\tclk");
            //$display("\t%d, \t%b", index, clk);
           
            	for (j=1; j<=index; j=j+1) //
             begin 
              @(posedge clk);
              //#10;
             end
	end
endtask	


  initial begin

      $monitor("At time %t, AddrWr = %h DataWR = %h wr = %b AddrRd = %h DataRD = %h rd = %b ",
              $time, AddrWr, DataWr, wr, AddrRd, DataRd, rd);
  end
     


endmodule
