class apb_act_agent extends uvm_agent;
  `uvm_component_utils(apb_act_agent)

  apb_driver drv;
  apb_act_monitor act_mon;
  apb_sequencer seqr;

  function new(string name = "apb_act_agent", uvm_component parent);
    super.new(name,parent);
  endfunction: new 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //if(get_is_active == UVM_ACTIVE) begin
      drv = apb_driver::type_id::create("drv",this);
      seqr = apb_sequencer::type_id::create("seqr",this);
    //end
    act_mon = apb_act_monitor::type_id::create("act_mon",this);
  endfunction: build_phase 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction: connect_phase
endclass: apb_act_agent 


//passive agent //
class apb_pass_agent extends uvm_agent;
  `uvm_component_utils(apb_pass_agent)

//  apb_driver drv;
  apb_pass_monitor pass_mon;
  //apb_sequencer seqr;

  function new(string name = "apb_pass_agent", uvm_component parent);
    super.new(name,parent);
  endfunction: new 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

   /* if(get_is_active == UVM_ACTIVE) begin
      drv = apb_driver::type_id::create("drv",this);
      seqr = apb_sequencer::type_id::create("seqr",this);
    end*/
    pass_mon = apb_pass_monitor::type_id::create("pass_mon",this);
  endfunction: build_phase

endclass: apb_pass_agent
