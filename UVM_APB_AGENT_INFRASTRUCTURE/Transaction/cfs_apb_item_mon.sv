`ifndef CFS_APB_ITEM_MON_SV
    `define CFS_APB_ITEM_MON_SV

    //Dynamic Object Class
    class cfs_apb_item_mon extends uvm_apb_item_base;
        `uvm_object_utils(cfs_apb_item_mon)

        cfs_apb_response response;
        int unsigned length;
        int unsigned prev_item_delay;

        function new(string inst = "");
            super.new(inst);
        endfunction

        virtual function string convert2string();
            string result = super.convert2string();
            result = $sformatf("%s  response : %s, length : %0d   prev_item_delay : %0d", result, response.name(), length, prev_item_delay);
        endfunction

    endclass

`endif





