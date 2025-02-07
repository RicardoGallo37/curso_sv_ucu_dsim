class fifo_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_sequence)
    
    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        fifo_transaction txn;
        repeat (50) begin
            txn = fifo_transaction::type_id::create("txn");
            start_item(txn);
            assert (txn.randomize());
            finish_item(txn);
        end
    endtask
endclass