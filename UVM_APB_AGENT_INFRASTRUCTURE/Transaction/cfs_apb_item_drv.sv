`ifndef CFS_APB_ITEM_DRV_SV
    `define CFS_APB_ITEM_DRV_SV

    /*
    Dynamic Object Class 
    This is like Transaction class of Kumar class. 
    */
    class cfs_apb_item_drv extends uvm_apb_item_base;
        `uvm_object_utils(cfs_apb_item_drv)

        rand int unsigned pre_drive_delay;
        rand int unsigned post_drive_delay;

        /*
        soft used to override from the anywhere if there are any conflicts.
        //APB Direction
        typedef enum bit{CFS_APB_READ = 0; CFS_APB_WRITE = 1} cfs_apb_dir;
        */

        //soft used to override from the anywhere if there are any conflicts.
        constraint pre_drive_delay_default {
            soft pre_drive_delay <= 5;
        }

        constraint post_drive_delay_default {
            soft post_drive_delay <= 5;
        }

        function new(string inst = "");
            super.new(inst);
        endfunction

        //t.display() of transaction class.
        virtual function string convert2string();
            string result = super.convert2string();
            if(dir == CFS_APB_WRITE) begin
                result = $sformatf("%s, data: %0d", result, data);
            end
            result = $sformatf("%s, pre_drive_delay: %0d, post_drive_delay: %0d", result, pre_drive_delay, post_drive_delay);
            return result;
        endfunction

    endclass

`endif





