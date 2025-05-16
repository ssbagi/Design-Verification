/*
Generator Class : Type/Format 3
*/

`ifndef CFS_APB_SEQUENCE_RANDOM_SV
    `define CFS_APB_SEQUENCE_RANDOM_SV

    class cfs_apb_sequence_random extends cfs_apb_sequence_base;
        `uvm_object_utils(cfs_apb_sequence_random)

        //Transaction class handle
        rand cfs_apb_item_drv item;
        cfs_apb_sequence_simple seq;
        rand int unsigned num_items;

        //The soft is used to override the constraint from the agent. 
        constraint num_items_default {
            soft num_items inside {[1:10]};
        }

        function new(string inst = "")
            super.new(inst);
            //seq = cfs_apb_sequence_simple::type_id::create("seq");
        endfunction

        virtual task body();
            for(int i = 0; i < num_items; i++) begin
                /*
                void'(seq.randomize());
                seq.start(m_sequencer, this);
                */
                `uvm_do(seq);
            end     
        endtask
    endclass

`endif 





