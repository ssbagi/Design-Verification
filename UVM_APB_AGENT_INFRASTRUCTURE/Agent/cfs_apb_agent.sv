/*
    AGENT
        - Driver
        - Monitor
        - Sequencer
*/

`ifndef CFS_APB_AGENT_SV
    `define CFS_APB_AGENT_SV

    class cfs_apb_agent extends uvm_agent;
        `uvm_component_utils(cfs_apb_agent)
        cfs_apb_agent_config agent_config;
        cfs_apb_vif vif;

        //Driver handler
        cfs_apb_driver drv;

        //Sequencer handler
        cfs_apb_sequencer seq;

        //Monitor handler
        cfs_apb_monitor mon;

        //Coverage handler
        cfs_apb_coverage coverage;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //Object Creation
            agent_config = cfs_apb_agent_config::type_id::create("agent_config", this);
            if (agent_config.get_active_passive() == UVM_ACTIVE) begin
                drv = cfs_apb_driver::type_id::create("drv", this);
                seq = cfs_apb_sequencer::type_id::create("seq", this);
            end
            
            mon = cfs_apb_monitor::type_id::create("mon", this);
            if(agent_config.get_has_coverage()) begin
                coverage = cfs_apb_coverage::type_id::create("cov", this);
            end
        endfunction   

        virtual function void connect_phase(uvm_phase phase);
            super.connect(phase);
            if(!uvm_config_db#(cfs_apb_vif)::get(this, "", "vif", vif)) begin
                `uvm_fatal("AGENT_CONFIG", "Unable to Access Interface")
            end else begin
                agent_config.vif = vif;
            end

            monitor.agent_config = agent_config;

            //TLM Port connection b/w SEQUENCER to DRIVER.
            if (agent_config.get_active_passive() == UVM_ACTIVE) begin
                drv.agent_config = agent_config;
                drv.seq_item_port.connect(seq.seq_item_export);
            end

        endfunction

    endclass
`endif

