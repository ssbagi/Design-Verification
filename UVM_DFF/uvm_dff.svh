`include "uvm_macros.svh"
import uvm_pkg::*;

// Interface 
interface dff_vif;
    logic clk;
    logic rst;
    logic din;
    logic dout;

    //Modport defining the direction of Signals w.r.t to the Driver.
    modport DRV (
      input clk, rst, din,
      output dout
    );

    //Modport defining the direction of Signals w.r.t to the Monitor.
    modport MON (
    output clk, rst, din,
    input dout
    );
endinterface

// Transaction Class dervied from uvm_sequence_item a dynamic class object
class transaction extends uvm_sequence_item;
    // For our D Flip-Flop we are generating 1 bit random input value. It can be either 1 or 0 at any given point of time.
    rand bit din;
    bit dout;

    function new(input string path = "transaction");
        super.new(path);
    endfunction

    //UVM Factory Registration 
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(din, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

/*
Generator Class derived from uvm_sequence.
The uvm_sequence class provides the interfaces necessary in order to create streams of sequence items and/or other sequences.
uvm_sequence#(REQ,RSP)
*/
class generator extends uvm_sequence #(transaction);
    //Register to UVM Factory 
    `uvm_object_utils(generator);
    //Transaction handle
    transaction tr;

    //Constructor
    function new(input string path = "generator");
        super.new(path);
    endfunction

    //Body for genefrating the Sequences and sending to Driver using TLM port (internal implementation) 
    virtual task body();
        tr = transaction::type_id::create("tr");
        // Generate 5 sequences
        repeat(5)
            begin 
                start_item(tr);
                assert(tr.randomize());
                `uvm_info("GEN", $sformatf("Random Transaction Generated :: din=%0b", tr.din), UVM_MEDIUM)
                #10;
                finish_item(tr);  
            end
    endtask
endclass

/*
Driver Class derived from uvm_driver a static class.
*/
class drv extends uvm_driver #(transaction);
    //Registering to the UVM Factory.
    `uvm_component_utils(drv);
  
    transaction data;
    virtual dff_vif vif;
    
    //TLM Port for reference data sending to Scoreboard.
    uvm_analysis_port #(transaction) send;

    function new(input string inst="drv", uvm_component c);
        super.new(inst, c);
        send  = new("send", this);
    endfunction
   
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual dff_vif)::get(this, "", "vif", vif))
            `uvm_error("DRV", "ERROR in get port");
    endfunction

    //Reset Sequence Applying 
    task reset_dut();
        vif.din <= 0;
        vif.dout <= 0;
        `uvm_info("DRV", "Reset Done", UVM_NONE);
    endtask

    //In Run Phase : Time consuming drive the transactions to DUT through Interface.
    virtual task run_phase(uvm_phase phase);
        data = transaction::type_id::create("data");
        reset_dut();
        forever
            begin
                //seq_item_port : TLM Port internal implentation present in the uvm_driver in built class method.
                seq_item_port.get_next_item(data);
                `uvm_info("DRV", $sformatf("Transaction DRV --> INTERFACE :: din = %0b", data.din), UVM_MEDIUM)
                vif.din <= data.din;
                // Send the data to Scoreboard for reference. 
                send.write(data);
                #10;
                seq_item_port.item_done();
            end
    endtask

endclass

/*
Monitor Class derived from uvm_monitor a Static Class.
*/
class mon extends uvm_monitor;
    //Registering to the UVM Factory.
    `uvm_component_utils(mon);
    transaction tr;
  
    //TLM Port for reference data sending to Scoreboard.
    uvm_analysis_port #(transaction) send;
    virtual dff_vif vif;

    function new(input string inst="mon", uvm_component c);
        super.new(inst, c);
        send = new("send", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db #(virtual dff_vif)::get(this, "", "vif", vif))
            `uvm_error("MON", "ERROR in get port");
    endfunction

    //Collect the Responses from the DUT through Interface.  
    virtual task run_phase(uvm_phase phase);
    begin
        forever
            begin
                tr.din   <= vif.din;
                send.write(tr);
                `uvm_info("MON", $sformatf("Transaction INTERFACE --> MON :: din=%0d", vif.din), UVM_MEDIUM)
                #10;
            end
    end
    endtask
endclass

/*
Scoreboard class derived from uvm_scoreboard a static class. 
*/
class sco extends uvm_scoreboard;
    `uvm_component_utils(sco);
  
    //TLM Port collecting from Driver and Monitor. 
    uvm_analysis_imp #(transaction, sco) drv_sco;
    uvm_analysis_imp #(transaction, sco) mon_sco;

    virtual dff_vif vif;
    transaction data;

    function new(input string path = "sco", uvm_component parent = null);
        super.new(path, parent);
        drv_sco = new("DRV_SCO", this);
        mon_sco = new("MON_SCO", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        data = transaction::type_id::create("tr");
        if(!uvm_config_db #(virtual dff_vif)::get(this, "", "vif", vif))
            `uvm_error("SCO", "ERROR in get port");
    endfunction

    function void write(transaction tx);
        `uvm_info("CONSUMER", $sformatf("Consumer received transaction: %s", tx.convert2string()), UVM_MEDIUM)
         if(tx.source == "DRV") begin
           drv_data = tx;
         end
         else begin
           mon_data = tx;
         end
           
         if(drv_data != null && mon_data != null) begin
           assert(drv_data == mon_data) else `uvm_error("SCO", "Driver and Monitor transactions do not match!");
         end
    endfunction
endclass

/*
Agent
  - Driver
  - Monitor
  - uvm_sequencer
  Connect the TLM port connection of driver and uvm_sequencer in connect_phase
*/
class agent extends uvm_agent;
    `uvm_component_utils(agent);

    function new(input string inst="agent", uvm_component c);
        super.new(inst, c);
    endfunction

    drv d;
    mon m;
    uvm_sequencer #(transaction) seq;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m   = mon::type_id::create("MON", this);
        d   = drv::type_id::create("DRV", this);
        seq = uvm_sequencer#(transaction)::type_id::create("SEQ", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //driver getting data from sequencer. Connection the port. 
        //Generator/Sequencer (export port)----> (port) Driver
        d.seq_item_port.connect(seq.seq_item_export);
    endfunction
  
endclass

/*
Environment
  - Scoreboard
  - Agent
  In connect phase connect the TLM port Monitor to Scoreboard and Driver to Scoreboard. 
*/

class env extends uvm_env;
    `uvm_component_utils(env)
    
    function new(input string inst = "ENV", uvm_component c);
        super.new(inst, c);
    endfunction
    
    sco s;
    agent a;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s = sco::type_id::create("SCO",this);
        a = agent::type_id::create("AGENT",this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a.m.send.connect(s.mon_sco);
        a.d.send.connect(s.drv_sco);
    endfunction

endclass

/*
TEST
  - Environment
  - Generator/Sequencer
  In Run Phase invoke the transaction or sequences need to be generated. Start the execution. 
*/
class test extends uvm_test;
    `uvm_component_utils(test);

    env e;
    generator gen;

    function new(input string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        gen = generator::type_id::create("gen");
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        gen.start(e.a.seq);
        #60;
        phase.drop_objection(this);
    endtask
endclass

/*
UVM TB TOP
  - Interface
  - DUT
  - Configure DB     :: Sharing the Interface Reosurce across the Classes
  - run_test("test") :: To start the Test.
*/
module tb();
    //Interface
    dff_vif vif();
    
    //DUT
    dff dut (.din(vif.din), .dout(vif.dout), .rst(vif.rst), .clk(vif.clk));

    //Initial singals at time = 0.
    initial begin
        vif.din <= 0; vif.dout <= 0; vif.rst <= 0; vif.clk <= 0;
    end  

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    // Clock Generation
    initial begin
        forever #5 vif.clk = ~vif.clk; // 10-time unit clock period
    end

    initial begin
        vif.rst = 1;
        #20; // Hold reset for 20 time units
        vif.rst = 0;
    end

    initial begin  
        uvm_config_db #(virtual dff_vif)::set(null, "*", "vif", vif);
        run_test("test");
    end

    initial begin
        #1000;
        $finish;
    end

endmodule


