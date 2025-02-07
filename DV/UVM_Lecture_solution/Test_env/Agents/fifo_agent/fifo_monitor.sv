class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)
    
    virtual fifo_if vif;
    uvm_analysis_port#(fifo_transaction) mon_ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
        if (!uvm_config_db#(virtual fifo_if)::get(null, "uvm_test_top", "fifo_if", vif))
            `uvm_fatal("MON", "No interface found")
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            fifo_transaction txn = fifo_transaction::type_id::create("txn");
            @(posedge vif.clk);
            txn.wr_en = vif.wr_en;
            txn.rd_en = vif.rd_en;
            txn.data = vif.data_out;
            mon_ap.write(txn);
        end
    endtask
endclass