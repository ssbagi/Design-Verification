/*
Generator Class : Type/Format 1
*/

`ifndef CFS_APB_SEQUENCE_SIMPLE_SV
    `define CFS_APB_SEQUENCE_SIMPLE_SV

    class cfs_apb_sequence_simple extends cfs_apb_sequence_base;
        `uvm_object_utils(cfs_apb_sequence_simple)

        //Transaction class handle
        rand cfs_apb_item_drv item;

        function new(string inst = "")
            super.new(inst);
            item = cfs_apb_item_drv::type_id::create("item");
        endfunction

        /*
        start_item(item);
        finish_item(item);
        */
        virtual task body();
            `uvm_send(item);
        endtask

    endclass

`endif 





