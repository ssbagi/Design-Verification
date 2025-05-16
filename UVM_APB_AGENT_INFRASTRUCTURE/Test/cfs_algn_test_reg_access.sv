/*
TESTCASE 1 : This is like normal test class of Kumar course.

Kumar Course : 
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        gen.start(e.a.seq);
        #60;
        phase.drop_objection(this);
    endtask
*/

`ifndef CFS_ALGN_TEST_REG_ACCESS_SVH
    `define CFS_ALGN_TEST_REG_ACCESS_SVH
    `include "uvm_macros.svh"

    class cfs_algn_test_reg_access extends uvm_algn_test_base;
        `uvm_component_utils(cfs_algn_test_reg_access)
        /*
        Generator/Sequencers
        */
        cfs_apb_sequence_simple seq_simple;
        cfs_apb_sequence_rw seq_rw;
        cfs_apb_sequence_random seq_random;

        function new(string inst = "", uvm_component parent);
            super.new(inst, parent);
        endfunction

        virtual function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            seq_simple = cfs_apb_sequence_simple::type_id::create("seq_simple");
            seq_rw = cfs_apb_sequence_rw::type_id::create("seq_rw");
            seq_random = cfs_apb_sequence_random::type_id::create("seq_random");
        endfunction

        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this, "TEST STARTED");
            `uvm_info("TEST_REG_ACCESS", " TEST STARTED ", UVM_MEDIUM);
            #(100ns);

            /* To Checks for errors
            begin
                cfs_apb_vif vif = env.apb_agent.agent_config.get_vif();
                vif.has_checks = 0;
            end
            */

            fork
                /*
                There are three Generating sequences. They are parallel connection.
                Any Generator class format will be selected.
                */

                //Generator class 1
                begin
                    //Setting the Address to 'h0, write transaction and data = 4'h11 by default. 
                    void'(seq_simple.randomize() with {
                        //item : Transaction class handle is item. Already present in seq_simple. 
                        //Control Register location : 0x0000_0000; 
                        item.addr == 'h0;
                        item.dir == CFS_APB_WRITE;
                        item.data == 'h11;
                    });
                    /*
                    gen.start(e.a.seq);
                    */
                    seq_simple.start(env.cfs_apb_agent.sequencer);
                end

                //Generator class 2
                begin
                    //Driving different sequence of different generator type.
                    void'(seq_rw.randomize() with {
                        //item : Transaction class handle is item. Already present in seq_simple. 
                        //Status Register location : 0x0000_000C;
                        addr == 'hC;
                    });
                    seq_rw.start(env.cfs_apb_agent.sequencer);
                end

                //Generator class 3 : Making the num_items = 3. Only 3 transactions. 
                begin
                    void'(seq_random.randomize() with {
                        num_items == 3;
                    })
                    seq_random.start(env.cfs_apb_agent.sequencer);
                end
            join
            
            `uvm_info("TEST_REG_ACCESS", " TEST COMPLETED ", UVM_MEDIUM);
            phase.drop_objection(this, "TEST DONE");
        endtask

    endclass

`endif