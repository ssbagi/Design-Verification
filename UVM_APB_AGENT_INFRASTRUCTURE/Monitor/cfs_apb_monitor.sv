`ifndef CFS_APB_MONITOR_SV
    `define CFS_APB_MONITOR_SV

    class cfs_apb_monitor extends uvm_monitor;
        `uvm_component_utils(cfs_apb_monitor)

        cfs_apb_agent_config agent_config;
        cfs_apb_vif vif;
        //This is like transaction class.
        cfs_apb_item_mon item;

        //TLM Port : Changed the TLM port name to different name below.
        uvm_analysis_port#(cfs_apb_item_mon) send;

        function new(string inst = "", uvm_component parent);
            super.new(inst, parent);
            send = new("send", this);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            item = cfs_apb_item_mon::type_id::create("item", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            collect_transactions();
        endtask

        protected virtual task collect_transactions();
            forever begin
                collect_transaction();
            end
        endtask

        protected virtual task collect_transaction();
            //Check for Setup State. Wait till we enter into this state.
            while(vif.psel != 1) begin
                @(posedge vif.clk)
                item.prev_item_delay++;
            end

            //In Setup FSM state collect the addr, direction.
            item.addr = vif.paddr;
            item.dir = cfs_apb_dir'(vif.pwrite);

            //For Write transaction collect the write data.
            if(item.dir == CFS_APB_WRITE) begin
                item.data = vif.pwdata;
            end

            //Single beat is only possible in APB Interface.
            item.length = 1;

            //Increment the length
            @(posedge vif.pclk);
            item.length++;

            //Unless slave send pready = 1. Be in Access state
            while(vif.pready != 1) begin
                @(posedge vif.pclk);
                item.length++;

                if(agent_config.get_has_checks()) begin
                    if(item.length >= agent_config.get_stuck_threshold) begin
                        `uvm_error("PROTOCOL_ERROR", $sformatf("The Length is crossing the Threshold values : %0d clock cycles", item.length));
                    end
                end
            end

            //Collect the response
            item.response = cfs_apb_response'(vif.pslverr);

            //For read put the data from slave to this.
            if(item.dir == CFS_APB_READ) begin
                item.data = vif.prdata;
            end

            send.write(item);

            `uvm_info("DEBUG", $sformatf("Montiored item : %0s", item.convert2string()), UVM_MEDUIM)

            @(posedge vif.pclk);

        endtask
    endclass

`endif

