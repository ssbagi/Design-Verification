/*
Driver Class.
*/

`ifndef CFS_APB_DRIVER_SV
    `define CFS_APB_DRIVER_SV

    class cfs_apb_driver extends uvm_driver#(.REQ(cfs_apb_item_drv));
        `uvm_component_utils(cfs_apb_driver)
        cfs_apb_item_drv item;

        cfs_apb_agent_config agent_config;
        int addr = {`CFS_APB_MAX_ADDR_WIDTH-1{1'b0}};
        int data = {`CFS_APB_MAX_DATA_WIDTH-1{1'b0}};

        function new(string inst = "", uvm_component parent);
            super.new(inst, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            item = cfs_apb_item_drv :: type_id :: create("item", this);
        endfunction

        virtual task run_phase(uvm_phase);
            super.run_phase(phase);
            drive_transactions();
        endtask

        virtual function void reset_dut();
            vif.psel <= 1'b0;
            vif.penable <= 1'b0;
            vif.pwrite <= 1'b0;
            vif.paddr <= addr;
            vif.pwdata <= data;
        endfunction


        protected virtual task drive_transactions();
            cfs_apb_vif vif = agent_config.get_vif();
            //Before starting drive the reset first.
            reset_dut();

            //Hold for 3 clk cycles.
            repeat(3) begin
                @(posedge vif.pclk);
            end

            forever begin
                seq_item_port.get_next_item(item);
                //Apply to interface
                drive_transaction(item);
                seq_item_port.item_done();
            end
            
        endtask

        /*
        Here we are Manually Applying the Transactions like this flow :
        1. Pre_drive_delay  : Few clock cycles.
        2. Setup FSM
        3. Access FSM
        4. Idle FSM
        5. post_drive_delay : Few clock cycles.
        Then back again same cycle repeatition.
        We are generating in the defined sequence set of events. 

        Example : 
        PRE_DRIVE | SETUP | ACCESS | IDLE | POST_DRIVE | PRE_DRIVE | SETUP | ACCESS | IDLE | POST_DRIVE | PRE_DRIVE | ---- goes on sequence.
        */
        protected virtual task drive_transaction(cfs_apb_item_drv item);
            `uvm_info("DRIVER", $sformatf("Driving %s :: ", item.cobvert2string()), UVM_MEDIUM);
            
            //Before setup phase we are adding few clock cycles delays.
            for(int i = 0; i < item.pre_drive_delay; i++) begin
                @(posedge vif.pclk);
            end

            /*
            Applying my Transaction to Interface. 
            During the posedge of PCLK only apply.
            */

            //PSEL = 1; Setup Phase state.
            vif.psel <= 1'b1;
            vif.pwrite <= bit'(item.dir);
            vif.paddr <= item.addr;

            if(item.dir == CFS_APB_WRITE) begin
                vif.pwdata <= item.data;
            end

            //FSM is moving to Access Phase state.
            @(posedge vif.pclk);
            vif.penable <= 1'b1;

            @(posedge vif.pclk);
            
            //We will be in Access state unless pready becomes one.
            while (Vif.pready != 1) {
                @(posedge vif.pclk);
            }

            //Transfer to Idle state
            vif.psel <= 1'b0;
            vif.pready <= 1'b0;
            vif.penable <= 1'b0;
            vif.paddr <= 0;
            vif.pwrite <= 1'b0;
            vof.pwdata <= 1'b0;

            //After Access to Ideal transfer. We are adding few clock cycles delays. Before next transaction
            for(int i = 0; i < item.post_drive_delay; i++) begin
                @(posedge vif.pclk);
            end

        endtask

    endclass


`endif





