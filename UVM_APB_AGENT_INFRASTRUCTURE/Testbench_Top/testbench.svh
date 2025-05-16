
`include "cfs_algn_test_pkg.sv"

module testbench();
  
  import uvm_pkg::*;
  import cfs_algn_test_pkg::*;
  
  //CLock signal
  reg clk;
  
  //Instance of the APB interface
  cfs_apb_if apb_if(.pclk(clk));
  
  //Instantiate the DUT
  cfs_aligner dut( .clk(    clk),
    .reset_n(apb_if.preset_n),
    .paddr(  apb_if.paddr),
    .pwrite( apb_if.pwrite),
    .psel(   apb_if.psel),
    .penable(apb_if.penable),
    .pwdata( apb_if.pwdata),
    .pready( apb_if.pready),
    .prdata( apb_if.prdata),
    .pslverr(apb_if.pslverr)
    );

  //Clock generator
  initial begin
    clk = 0;
    forever begin
      clk = #5ns ~clk;
    end
  end
  
  //Initial reset generator
  initial begin
    apb_if.preset_n = 1;
    #6ns;
    apb_if.preset_n = 0;
    #30ns;
    apb_if.preset_n = 1;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    uvm_config_db#(virtual cfs_apb_if)::set(null, "uvm_test_top.env.apb_agent", "vif", apb_if);
    /*
    Start UVM test and phases
    +UVM_TESTNAME=cfs_algn_test_reg_access ---- equivalent to ---- run_test("cfs_algn_test_reg_access")
    +UVM_MAX_QUIT_COUNT=1
    */
    run_test("");
  end
  
endmodule



