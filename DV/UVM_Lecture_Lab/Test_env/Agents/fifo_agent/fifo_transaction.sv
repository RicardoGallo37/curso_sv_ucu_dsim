class fifo_transaction extends uvm_sequence_item;
    rand bit [7:0] data;
    rand bit wr_en;
    rand bit rd_en;
    
    `uvm_object_utils(fifo_transaction)
    
    function new(string name = "fifo_transaction");
        super.new(name);
    endfunction

    //LAB: Add better constraints to this transactions

endclass