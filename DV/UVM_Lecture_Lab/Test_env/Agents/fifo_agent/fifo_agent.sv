class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)
    
    fifo_driver drv;
    fifo_monitor mon;
    fifo_sequencer seqr;
    fifo_agent_config cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = fifo_driver::type_id::create("drv", this);
        mon = fifo_monitor::type_id::create("mon", this);
        seqr = fifo_sequencer::type_id::create("seqr", this);
        if (!uvm_config_db#(fifo_agent_config)::get(null, "fifo_agent", "cfg", cfg))
            `uvm_fatal("AGT", "No config found")
        uvm_config_db#(fifo_agent_config)::set(this, "drv", "cfg", cfg);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
