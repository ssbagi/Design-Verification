/*
This file is main package. 
Aligner DUT Package
*/

`ifndef CFS_ALGN_TEST_PKG_SV 
    `define CFS_ALGN_TEST_PKG_SV
    `include "uvm_macros.svh"
    `include "cfs_apb_pkg.sv"

    package cfs_algn_pkg;
        import uvm_pkg::*;
        import uvm_apb_pkg::*;
        
        `include "cfs_algn_env.sv"

    endpackage

`endif    