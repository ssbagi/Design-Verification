/*
We create a Passive and Active. 
Active means include Driver and Monitor instanstion in agent class. 
*/

`ifndef CFS_APB_AGENT_CONFIG_SV
    `define CFS_APB_AGENT_CONFIG_SV

    class cfs_apb_agent_config extends uvm_component;
        `uvm_component_utils(cfs_apb_agent_config)

        local cfs_apb_vif vif;
        
        //Active/Passive Control
        local uvm_active_passive_enum active_passive;

        //Switch to enable the checks
        local bit has_checks;

        //Stuck threshold
        local int unsigned stuck_threshold;

        //Switch for coverage
        local bit has_coverage;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
            active_passive = UVM_ACTIVE;
            has_checks = 1;
            stuck_threshold = 1000;
        endfunction

        // Getters and Setters for the variables.
        virtual function bit get_has_checks();
            return has_checks;
        endfunction

        virtual function void set_has_checks(bit value);
            has_checks = value;
            //If vif is not accessed. Drive the same value.
            if(vif != null) begin
                vif.has_checks = has_checks; 
            end
        endfunction

        virtual function void set_stuck_threshold(int unsigned value);
            if(value < 3) begin
                `uvm_error("ALGORITHM_ISSUE", "The Stuck Threshold value setting is less than 2 not acceptable");
            end
            stuck_threshold = value;
        endfunction

        virtual function int unsigned get_stuck_threshold();
            return stuck_threshold;
        endfunction

        virtual function bit get_has_coverage();
            return has_coverage;
        endfunction

        virtual function void set_has_coverage(bit value);
            has_coverage = value;
        endfunction

        virtual function uvm_active_passive_enum get_active_passive();
            return active_passive;
        endfunction

        virtual function void set_active_passive(uvm_active_passive_enum value);
            active_passive = value;
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(cfs_apb_vif)::get(this, "vif", vif)) begin
                `uvm_fatal("AGENT_CONFIG", "Unable to Access Interface")
            end
        endfunction

        virtual task run_phase (uvm_phase phase);
            super.new(phase);
            forever begin
                @(vif.has_checks);

                if(vif.has_checks != get_has_checks()) begin
                    `uvm_error("ALGORITHM ISSUE", $sformatf("Can not change APB Check issue :: %0s.set_has_checks()", get_full_name()))
                end
            end
        endtask

    endclass
`endif

