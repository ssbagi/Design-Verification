/*
Main file which will be used for the Testcases generation by extending this class.
Test class : w.r.t Kumar Course
    - Environment
        - Agent
        - Scoreboard
    - Sequencer
*/

`ifndef CFS_ALGN_TEST_BASE_SV
    `define CFS_ALGN_TEST_BASE_SV

    class cfs_algn_test_base extends uvm_test;
        `uvm_component_utils(cfs_algn_test_base)

        cfs_algn_env env;

        function new(string inst = "", uvm_component parent);
            super.new(inst, parfent);
        endfunction 

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = cfs_algn_env::type_id::create("env", this);
        endfunction
        
    endclass
`endif



