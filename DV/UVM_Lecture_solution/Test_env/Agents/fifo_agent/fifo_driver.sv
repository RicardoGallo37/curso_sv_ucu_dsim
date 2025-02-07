class fifo_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_driver)
    
    virtual fifo_if vif;
    fifo_agent_config cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(null, "uvm_test_top", "fifo_if", vif))
            `uvm_fatal("DRV", "No interface found")
        if (!uvm_config_db#(fifo_agent_config)::get(this, "", "cfg", cfg))
            `uvm_fatal("DRV", "No config found")
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            fifo_transaction txn;
            seq_item_port.get_next_item(txn);
            @(posedge vif.clk);
            if (!(cfg.stop_on_full && vif.full)) begin
                vif.wr_en = txn.wr_en;
                vif.data_in = txn.data;
            end
            seq_item_port.item_done();
        end
    endtask
endclass