/*
Ackonwledge signal getting high after 1 or 3 cycles once Request signal is enabled.
Req is followed by Ack within 3 cycles.
*/
property ack_req_condition;
  @(posedge clk) req |-> ##[1:3] ack;
endproperty
ACKNOWLEDGEMENT: assert property(ack_req_condition);

/*
AXI Handshake : Write Address Channel
AWREADY was not asserted within MAXWAITS (16 cycles) after AWVALID.  
[|->num] : The number of times specified not necessarily on continuous clock cycles.
*/
property awready_within_maxwaits;
  @(posedge clk) AWVALID |=> AWREADY [->16];
endproperty
AWREADY_ASSERTION : assert property(awready_within_maxwaits) else $error("AWREADY was not asserted within MAXWAITS (16 cycles) after AWVALID!");
  
/*
Reset is deasserted within 5 cycles of power-up  
*/
property reset_deassert;
  @(posedge clk) power_up |-> ##[1:5] !(rst);
endproperty
  RESET_DEASSERT : assert property(reset_deassert) else $error("Reset Deasserted after 5 clock cyles or before 1 clock cycles");












  
