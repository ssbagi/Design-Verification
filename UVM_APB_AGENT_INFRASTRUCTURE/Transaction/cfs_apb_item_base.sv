`ifndef CFS_APB_ITEM_BASE_SV
    `define CFS_APB_ITEM_BASE_SV

    //Dynamic Object Class
    class cfs_apb_item_base extends uvm_sequence_item;
        `uvm_object_utils(cfs_apb_item_base)

        rand cfs_apb_dir dir;
        rand cfs_apb_addr addr;
        rand cfs_apb_data data;
        
        function new(string inst = "");
            super.new(inst);
        endfunction

    endclass

`endif





