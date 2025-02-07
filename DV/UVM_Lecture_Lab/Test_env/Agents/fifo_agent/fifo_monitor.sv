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
            //LAB: Here goes receiving the transaction and sending it to the AP
        end
    endtask
endclass