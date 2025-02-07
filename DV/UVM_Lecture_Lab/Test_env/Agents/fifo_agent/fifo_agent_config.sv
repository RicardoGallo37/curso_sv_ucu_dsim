class fifo_agent_config extends uvm_object;
    `uvm_object_utils(fifo_agent_config)
    
    bit stop_on_full;

    //LAB: Add another config that can change the testbench
    
    function new(string name = "fifo_agent_config");
        super.new(name);
    endfunction
endclass