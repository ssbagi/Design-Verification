/*
The AXI VIP is not implementing AXI FullMode. Dropped few signals 
Write Address Channel  : AWLOCK  | AWCACHE  |  AWPROT  |  AWUSER  |  AWQOS  |  AWREGION  |  AWUSER
Write Data Channel     : WUSER   | WDATA Count
Response Channel       : 
Read Address Channel   : ARLOCK  |  ARCACHE  |  ARPROT  |  ARUSER  |  ARQOS  |  ARREGION 
Read Data Channel      : RUSER
*/

interface axi(input bit ACLK);

  //write_address_channel
  logic [3:0] AWID;    
  logic [31:0] AWADDR;
  logic [3:0] AWLEN;
  logic [2:0] AWSIZE;
  logic [1:0] AWBURST;
  logic AWVALID,AWREADY;

  //write_data channel
  logic [3:0] WID;
  logic [31:0]WDATA;
  logic [3:0]WSTRB;
  logic WREADY,WLAST,WVALID;

  //write_response channel
  logic [3:0] BID;
  logic [1:0] BRESP;
  logic BVALID,BREADY;

  //read_address_channel
  logic [3:0] ARID;
  logic [31:0] ARADDR;
  logic [3:0] ARLEN;
  logic [2:0] ARSIZE;
  logic [1:0] ARBURST;
  logic ARVALID,ARREADY;

  //read_data/response channel
  logic [3:0] RID;
  logic [31:0]RDATA;
  logic [1:0] RRESP;
  logic RREADY,RLAST,RVALID;

  //---------------------Master Driver -----------------------------------------------------------------------
  clocking m_drv @(posedge ACLK);
    default input #1 output #1;
     
    //write_address_channel
    output AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    input AWREADY;
    
    //write_data channel
    output WID,WDATA,WLAST,WVALID,WSTRB;
    input WREADY;
    
    //write_response channel
    input BID,BRESP,BVALID;
    output BREADY;
    
    //read_address_channel
    output ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    input ARREADY;
    
    //read_data/response channel
    input RID,RDATA,RRESP,RLAST,RVALID;
    output RREADY;
  endclocking
  //-----------------Master Monitor ----------------------------------------------------------------------------
  
  clocking m_mon @(posedge ACLK);
    default input #1 output #1;
    
    input AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    input AWREADY;
    
    //write_data channel
    input WID,WDATA,WLAST,WVALID,WSTRB;
    input WREADY;
    
    //write_response channel
    input BID,BRESP,BVALID;
    input BREADY;
    
    //read_address_channel
    input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    input ARREADY;
    
    //read_data/response channel
    input RID,RDATA,RRESP,RLAST,RVALID;
    input RREADY;
    
  endclocking
  //------------------- Slave Driver --------------------------------------------------------------------------

  clocking s_drv @(posedge ACLK);
    default input #1 output #1;
    
    //write_address_channel
    input AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    output AWREADY;
    
    //write_data channel
    input WID,WDATA,WSTRB,WLAST,WVALID;
    output WREADY;
    
    //write_response channel
    output BID,BRESP,BVALID;
    input BREADY;
    //read_address_channel
    input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    output ARREADY;
    
    //read_data/response channel
    output RID,RDATA,RRESP,RLAST,RVALID;
    input RREADY;
    
  endclocking
//------------------- Slave Monitor --------------------------------------------------------------------------

  clocking s_mon @(posedge ACLK);
    default input #1 output #1;
    input AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    input AWREADY;
    
    //write_data channel
    input WID,WDATA,WLAST,WVALID,WSTRB;
    input WREADY;
    
    //write_response channel
    input BID,BRESP,BVALID;
    input BREADY;
    //read_address_channel
    input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    input ARREADY;
    
    //read_data/response channel
    input RID,RDATA,RRESP,RLAST,RVALID;
    input RREADY;
    
  endclocking

//---------------------------------------------------------------------------------------------

// Modport used to define the direction of the signals and for reusablility
// Modport Master Driver and Monitor
modport M_DRV(clocking m_drv);
modport M_MON(clocking m_mon);

// Modport Slave Driver and Monitor
modport S_DRV(clocking s_drv);
modport S_MON(clocking s_mon);


/*----------------------------------------------------------------------------------------------
------------------------ ASSERTIONS : AXI Protocol Verification --------------------------------
Noting down few points : 
|->       :: Overlapping Assertion on same clk edge.
|=>       :: Non-Overlapping Assertion. The check happens on next clk edge [ |-> #1  ------> |=> ].
[->n]     :: Event must happen exactly n cycles later.
A[->1]    :: Means that A must become high exactly 1 cycle after it starts being monitored.

AXI Rules Links :
1. ARM : https://developer.arm.com/documentation/dui0534/b/Protocol-Assertions-Descriptions/AXI4-and-AXI4-Lite-protocol-assertion-descriptions/Write-address-channel-checks?lang=en
2. AMD : https://docs.amd.com/r/en-US/pg101-axi-protocol-checker/AXI-Protocol-Checks-and-Descriptions
------------------------------------------------------------------------------------------------
*/

endinterface
