/*
APB Package 
*/
`ifndef CFS_APB_PKG_SV
    `define CDS_APB_PKG_SV

    `include "uvm_macros.svh"
    `include "cfs_apb_if.sv"

    package cfs_apb_pkg;
        import uvm_pkg::*;

        `include "cfs_apb_types.sv"
        /*
        Creating different Transaction class for Monitor and Driver Class to capture different stuff.
        */
        `include "cfs_apb_item_base.sv"
        `include "cfs_apb_item_drv.sv"
        `include "cfs_apb_item_mon.sv"
        `include "cfs_apb_coverage.sv"
        
        `include "cfs_apb_agent_config.sv"

        `include "Cfs_apb_monitor.sv"
        `include "cfs_apb_driver.sv"

        `include "cfs_apb_sequencer.sv"
        `include "cfs_apb_sequence_base.sv"
        `include "cfs_apb_sequence_simple.sv"
        `include "cfs_apb_sequence_rw.sv"
        `include "cfs_apb_sequence_random.sv"

        `include "cfs_apb_agent.sv"
    endpackage

`endif










