/*
    ENV
        - AGENT
        - SCOREBOARD
*/

`ifndef CFS_ALGN_ENV_SV
    `define CFS_ALGN_ENV_SV

    class cfs_algn_env extends uvm_env;
        `uvm_component_utils(cfs_algn_env);
        cfs_apb_agent agent;

        function new(string inst = "", uvm_component parent);
            super.new(inst, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = cfs_apb_agent::type_id::create("agent", this);
        endfunction

    endclass


`endif

