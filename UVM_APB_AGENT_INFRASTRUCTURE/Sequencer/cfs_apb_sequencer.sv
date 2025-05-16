`ifndef CFS_APB_SEQUENCER_SV
    `define CFS_APB_SEQUENCER_SV

    class cfs_apb_sequencer extends uvm_sequencer#(.REQ(cfs_apb_item_drv));
        `uvm_object_utils(cfs_apb_sequencer)

        function new(string inst = "", uvm_component parent);
            super.new(inst, parent);
        endfunction

    endclass

`endif





