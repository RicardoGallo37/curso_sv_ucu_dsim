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
            //LAB: Here goes getting the transaction and sending it to the DUT
        end
    endtask
endclass