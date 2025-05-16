`ifndef CFS_APB_IF_SV
    `define CFS_APB_IF_SV

    `ifndef CFS_APB_MAX_ADDR_WIDTH
        `define CFS_APB_MAX_ADDR_WIDTH 32
    `endif

    `ifndef CFS_APB_MAX_DATA_WIDTH
        `define CFS_APB_MAX_DATA_WIDTH 16
    `endif 

    interface cfs_apb_if(input logic pclk);
        logic preset_n;
        logic psel;
        logic penable;
        logic pwrite;
        logic [`CFS_APB_MAX_ADDR_WIDTH:0] paddr;
        logic [`CFS_APB_MAX_DATA_WIDTH:0] pwdata;
        logic [`CFS_APB_MAX_DATA_WIDTH:0] prdata;
        logic pready;
        logic pslverr;

        /*
        Protocol Checks
        */

        bit has_checks;

        //Default Enabled.
        initial begin
            has_checks = 1;
        end

        //SETUP PHASE
        sequence setup_phase_s
            //True setup phase or Transfer from Idle to setup or Previous was Access.
            (psel == 1) && (($past(psel == 0) || ($past(psel) == 1 && $past(pready) == 1)));
        endsequence

        property penable_at_setup_phase_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            setup_phase_s |-> penable == 0;
        endproperty

        PENABLE_AT_SETUP_PHASE_A : assert property(penable_at_setup_phase_p) else $error("PENABLE at Setup Phase is 1. Error the FSM is state is wrong.");

        //Entering the ACCESS PHASE
        sequence access_phase_s
            (psel == 1) && (penable == 1);
        endsequence

        //#RULE 1 : PENABLE must be asserted in the second cycle of the transfer.
        property penable_entering_access_phase_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            //Same clk edge. Non Overlapping
            setup_phase_s |=> penable == 1;
        endproperty

        PENABLE_ENTERING_ACCESS_PHASE_A : assert property(penable_entering_access_phase_p) else $error("PENABLE when entering Access Phase is not equal to 1");

        //#RULE 2 : PENABLE must be desserted at the end of the transfer.
        //Exiting the ACCESS PHASE
        property penable_exiting_access_phase_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            access_phase_s and (pready == 1) |=> penable == 0;
        endproperty

        PENABLE_EXITING_ACCESS_PHASE_A : assert property(penable_exiting_access_phase_p) else $error("PENABLE when exiting the Access Phase is not equal to 0");

        /*
        #RULE 3 : Master Driven Signals must remain constant throughout the transfer.
        1. PENABLE
        2. PADDR
        3. PWDATA
        */

        //PENABLE STABLE at the ACCESS PHASE
        property pwrite_stable_at_access_phase_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            access_phase_s |-> $stable(pwrite);
        endproperty

        PWRITE_STABLE_ACCESS_PHASE_A : assert property(pwrite_stable_at_access_phase_p) else $error("PWRITE is not stable during the Access phase");

        //PADDR STABLE at the ACCESS PHASE
        property paddr_stable_at_access_phase_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            access_phase_s |-> $stable(paddr);
        endproperty

        PADDR_STABLE_ACCESS_PHASE_A : assert property(paddr_stable_at_access_phase_p) else $error("PADDR is not stable during the Access phase");

        //PWDATA STABLE at the ACCESS PHASE : Check for only write operation
        property pwdata_stable_at_access_phase_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            access_phase_s and (pwrite == 1) |-> $stable(pwdata);
        endproperty

        PWDATA_STABLE_ACCESS_PHASE_A : assert property(pwdata_stable_at_access_phase_p) else $error("PWDATA is not stable during the Access phase");

        /*
        #RULE 4 : APB Signals cannot have unknown values
        Is there any way we can write a generalized since all we need to is $isunknown(signal_name). The signal names : APB signals
        PADDR, PWDATA, PWRITE, PENABLE, PRESET_N, PSEL, PRDATA, PREADY, PSLVERR
        */

        property unknown_value_psel_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            $isunknown(psel) == 0;
        endproperty

        PSEL_UNKNOWN_STATE : assert property(unknown_value_psel_p) else $error("PSEL is in Unknown state");

        property unknown_value_paddr_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            (psel == 1) |-> $isunknown(paddr) == 0;
        endproperty

        PADDR_UNKNOWN_STATE : assert property(unknown_value_paddr_p) else $error("PSEL is in Unknown state");

        property unknown_value_pwdata_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            (psel == 1) && (pwrite == 1) |-> $isunknown(pwdata) == 0;
        endproperty

        PWDATA_UNKNOWN_STATE : assert property(unknown_value_pwdata_p) else $error("PSEL is in Unknown state");

        property unknown_value_pwrite_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            (psel == 1) |-> $isunknown(pwrite) == 0;
        endproperty

        PWRITE_UNKNOWN_STATE : assert property(unknown_value_pwrite_p) else $error("PSEL is in Unknown state");

        property unknown_value_penable_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            $isunknown(penable) == 0;
        endproperty

        PENABLE_UNKNOWN_STATE : assert property(unknown_value_penable_p) else $error("PENABLE is in Unknown state");

        property unknown_value_presetn_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            $isunknown(preset_n) == 0;
        endproperty

        PRESETN_UNKNOWN_STATE : assert property(unknown_value_presetn_p) else $error("PRESETN is in Unknown state");

        property unknown_value_prdata_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            (psel == 1) && (pwrite == 0) && (penable == 1) && (pready == 1) |-> $isunknown(prdata) == 0;
        endproperty

        PRDATA_UNKNOWN_STATE : assert property(unknown_value_prdata_p) else $error("PRDATA is in Unknown state");

        property unknown_value_pready_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            (psel == 1) && (penable == 1) |-> $isunknown(pready) == 0;
        endproperty

        PREADY_UNKNOWN_STATE : assert property(unknown_value_pready_p) else $error("PREADY is in Unknown state");

        property unknown_value_pslverr_p;
            @(posedge pclk) disable iff(!preset_n || !has_checks)
            (psel == 1) && (penable == 1) && (pready == 1) |-> $isunknown(pslverr) == 0;
        endproperty

        PSLVERR_UNKNOWN_STATE : assert property(unknown_value_pslverr_p) else $error("PSLVERR is in Unknown state");

    endinterface

`endif 



