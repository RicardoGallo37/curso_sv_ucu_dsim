class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)
    
    fifo_env env;
    fifo_agent_config agt_cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
        agt_cfg = fifo_agent_config::type_id::create("agt_cfg",this);
        agt_cfg.stop_on_full = 1'b1;
        uvm_config_db#(fifo_agent_config)::set(null, "fifo_agent", "cfg", agt_cfg);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        fifo_sequence seq;
        seq = fifo_sequence::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agent.seqr);
        phase.drop_objection(this);
    endtask
endclass