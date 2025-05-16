///////////////////////////////////////////////////////////////////////////////
// File:        cfs_apb_coverage.sv
// Author:      Cristian Florin Slav
// Date:        2023-10-13
// Description: APB coverage class.
///////////////////////////////////////////////////////////////////////////////
`ifndef CFS_APB_COVERAGE_SV
  `define CFS_APB_COVERAGE_SV

  `uvm_analysis_imp_decl(_item)

  virtual class cfs_apb_cover_index_wrapper_base extends uvm_component;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    //Function used to sample the information
    pure virtual function void sample(int unsigned value);
      
    //Function to print the coverage information.
    //This is only to be able to visualize some basic coverage information
    //in EDA Playground.
    //DON'T DO THIS IN A REAL PROJECT!!!
    pure virtual function string coverage2string();   
  endclass

  //Wrapper over the covergroup which covers indices.
  //The MAX_VALUE parameter is used to determine the maximum value to sample
  class cfs_apb_cover_index_wrapper#(int unsigned MAX_VALUE_PLUS_1 = 16) extends cfs_apb_cover_index_wrapper_base;
    
    `uvm_component_param_utils(cfs_apb_cover_index_wrapper#(MAX_VALUE_PLUS_1))
  
    covergroup cover_index with function sample(int unsigned value);
      option.per_instance = 1;
      
      index : coverpoint value {
        option.comment = "Index";
        bins values[MAX_VALUE_PLUS_1] = {[0:MAX_VALUE_PLUS_1-1]};
      }
      
    endgroup
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      cover_index = new();
	  cover_index.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_index"));
    endfunction
    
    //Function to print the coverage information.
    //This is only to be able to visualize some basic coverage information
    //in EDA Playground.
    //DON'T DO THIS IN A REAL PROJECT!!!
    virtual function string coverage2string();
      return {
        $sformatf("\n   cover_index:              %03.2f%%", cover_index.get_inst_coverage()),
        $sformatf("\n      index:                 %03.2f%%", cover_index.index.get_inst_coverage())
      };
    endfunction
    
    //Function used to sample the information
    virtual function void sample(int unsigned value);
      cover_index.sample(value);
    endfunction
      
  endclass

  class cfs_apb_coverage extends uvm_component;
    
    //Pointer to agent configuration
    cfs_apb_agent_config agent_config;
    
    //Port for sending the collected item
    uvm_analysis_imp_item#(cfs_apb_item_mon, cfs_apb_coverage) port_item;
    
    //Wrapper over the coverage group covering the indices in the PADDR signal
    //at which the bit of the PADDR was 0
    cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH) wrap_cover_addr_0;

    //Wrapper over the coverage group covering the indices in the PADDR signal
    //at which the bit of the PADDR was 1
    cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH) wrap_cover_addr_1;

    //Wrapper over the coverage group covering the indices in the PWDATA signal
    //at which the bit of the PWDATA was 0
    cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_wr_data_0;

    //Wrapper over the coverage group covering the indices in the PWDATA signal
    //at which the bit of the PWDATA was 1
    cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_wr_data_1;

    //Wrapper over the coverage group covering the indices in the PRDATA signal
    //at which the bit of the PRDATA was 0
    cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_rd_data_0;

    //Wrapper over the coverage group covering the indices in the PRDATA signal
    //at which the bit of the PRDATA was 1
    cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_rd_data_1;

    `uvm_component_utils(cfs_apb_coverage)
    
    covergroup cover_item with function sample(cfs_apb_item_mon item);
      option.per_instance = 1;
      
      direction : coverpoint item.dir {
        option.comment = "Direction of the APB access";
      }
      
      response : coverpoint item.response {
        option.comment = "Response of the APB access";
      }
      
      length : coverpoint item.length {
        option.comment = "Length of the APB access";
        bins length_eq_2     = {2};
        bins length_le_10[8] = {[3:10]};
        bins length_gt_10    = {[11:$]};
        
        illegal_bins length_lt_2 = {[$:1]};
      }
      
      prev_item_delay : coverpoint item.prev_item_delay {
        option.comment = "Delay, in clock cycles, between two consecutive APB accesses";
        bins back2back       = {0};
        bins delay_le_5[5]   = {[1:5]};
        bins delay_gt_5      = {[6:$]};
      }
      
      response_x_direction : cross response, direction;
      
      trans_direction : coverpoint item.dir {
        option.comment = "Transitions of APB direction";
        bins direction_trans[] = (CFS_APB_READ, CFS_APB_WRITE => CFS_APB_READ, CFS_APB_WRITE);
      }
      
    endgroup
    
    covergroup cover_reset with function sample(bit psel);
      option.per_instance = 1;
      
      access_ongoing : coverpoint psel {
        option.comment = "An APB access was ongoing at reset";
      }
    endgroup
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      port_item = new("port_item", this);
      
      cover_item = new();
	  cover_item.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_item"));
      
      cover_reset = new();
	  cover_reset.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_reset"));
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      wrap_cover_addr_0    = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_0",    this);
      wrap_cover_addr_1    = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_1",    this);
      wrap_cover_wr_data_0 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_wr_data_0", this);
      wrap_cover_wr_data_1 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_wr_data_1", this);
      wrap_cover_rd_data_0 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_rd_data_0", this);
      wrap_cover_rd_data_1 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_rd_data_1", this);
    endfunction
    
    //Port associated with port_item port
    virtual function void write_item(cfs_apb_item_mon item);
      cover_item.sample(item);
      
      for(int i = 0; i < `CFS_APB_MAX_ADDR_WIDTH; i++) begin
        if(item.addr[i]) begin
          wrap_cover_addr_1.sample(i);
        end
        else begin
          wrap_cover_addr_0.sample(i);
        end
      end
      
      for(int i = 0; i < `CFS_APB_MAX_DATA_WIDTH; i++) begin
        case(item.dir)
          CFS_APB_WRITE : begin
            if(item.data[i]) begin
              wrap_cover_wr_data_1.sample(i);
            end
            else begin
              wrap_cover_wr_data_0.sample(i);
            end
          end
          CFS_APB_READ : begin
            if(item.data[i]) begin
              wrap_cover_rd_data_1.sample(i);
            end
            else begin
              wrap_cover_rd_data_0.sample(i);
            end
          end
          default : begin
            `uvm_error("ALGORITHM_ISSUE", $sformatf("Current version of the code does not support item.dir: %0s", item.dir.name()))
          end
        endcase
      end
      
      //IMPORTANT: DON'T DO THIS IN A REAL PROJECT!!!
      `uvm_info("DEBUG", $sformatf("Coverage: %0s", coverage2string()), UVM_NONE)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      cfs_apb_vif vif = agent_config.get_vif();
      
      forever begin
        @(negedge vif.preset_n);
        
        cover_reset.sample(vif.psel);
      end
    endtask
    
    //Function to print the coverage information.
    //This is only to be able to visualize some basic coverage information
    //in EDA Playground.
    //DON'T DO THIS IN A REAL PROJECT!!!
    virtual function string coverage2string();
      string result = {
        $sformatf("\n   cover_item:              %03.2f%%", cover_item.get_inst_coverage()),
        $sformatf("\n      direction:            %03.2f%%", cover_item.direction.get_inst_coverage()),
        $sformatf("\n      trans_direction:      %03.2f%%", cover_item.trans_direction.get_inst_coverage()),
        $sformatf("\n      response:             %03.2f%%", cover_item.response.get_inst_coverage()),
        $sformatf("\n      response_x_direction: %03.2f%%", cover_item.response_x_direction.get_inst_coverage()),
        $sformatf("\n      length:               %03.2f%%", cover_item.length.get_inst_coverage()),
        $sformatf("\n      prev_item_delay:      %03.2f%%", cover_item.prev_item_delay.get_inst_coverage()),
        $sformatf("\n                                    "),
        $sformatf("\n   cover_reset:             %03.2f%%", cover_reset.get_inst_coverage()),
        $sformatf("\n      access_ongoing:       %03.2f%%", cover_reset.access_ongoing.get_inst_coverage())
      };
      
      uvm_component children[$];
      
      get_children(children);
      
      foreach(children[idx]) begin
        cfs_apb_cover_index_wrapper_base wrapper;
        
        if($cast(wrapper, children[idx])) begin
          result = $sformatf("%s\n\nChild component: %0s%0s", result, wrapper.get_name(), wrapper.coverage2string());
        end
      end
      
      return result;
    endfunction
    
  endclass

`endif