`ifndef CFS_APB_SEQUENCE_BASE_SV
    `define CFS_APB_SEQUENCE_BASE_SV

    class cfs_apb_sequence_base extends uvm_sequencer#(.REQ(cfs_apb_item_drv));
        `uvm_object_utils(cfs_apb_sequence_base)

        //P Sequencer macro
        `uvm_declare_p_sequencer(cfs_apb_sequencer)

        function new(string inst = "", uvm_component parent);
            super.new(inst, parent);
        endfunction

    endclass

`endif