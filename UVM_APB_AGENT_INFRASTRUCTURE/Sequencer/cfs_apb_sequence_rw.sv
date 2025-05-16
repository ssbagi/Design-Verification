/*
Generator Class : Type 2 
*/

`ifndef CFS_APB_SEQUENCE_RW_SV
    `define CFS_APB_SEQUENCE_RW_SV

    class cfs_apb_sequence_rw extends cfs_apb_sequence_base;
        `uvm_object_utils(cfs_apb_sequence_rw)

        //Transaction class handle
        rand cfs_apb_addr addr;
        rand cfs_apb_data wr_data;
        rand cfs_apb_item_drv item;
        
        function new(string inst = "");
            super.new(inst);
            item = cfs_apb_item_drv::type_id::create("cfs_apb_item_drv");
        endfunction
        
        virtual task body();
            //Always generate Read transaction and addr is of rand type.
            void'(item.randomize() with {
                dir == CFS_APB_READ;
                //Use the current class randomization addr value.
                addr == local::addr;
            })

            `uvm_send(item);

            /*
            Method 2 : Easy One
            `uvm_do_with(item, {
                dir == CFS_APB_READ;
                addr == local::addr;
            })
            `uvm_do_with(item, {
                dir == CFS_APB_WRITE;
                addr == local::addr;
                data == local::wr_data;
            })
            */

        endtask

    endclass

`endif 




