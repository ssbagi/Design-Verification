/*
  This package is used for just inclusion of all the testcases file.  
*/

`ifndef CFS_ALGN_TEST_PACKAGE_SV
    `define CFS_ALGN_TEST_PACKAGE_SV

    `include "uvm_macros.svh";
    //Aligner DUT Package
    `include "cfs_algn_pkg.sv";
    

    package cfs_algn_test_package;
        import uvm_pkg::*;
        import cfs_algn_pkg::*;
        //APB Interface Package
        import cfs_apb_pkg::*;

        `include "cfs_algn_test_base.sv"
        //Testcase File : Different Scenarios
        `include "cfs_algn_test_reg_access.sv"
        //`include "cfs_algn_test_illegal_rx.sv"
        //`include "cfs_algn_test_random.sv"

    endpackage

`endif

