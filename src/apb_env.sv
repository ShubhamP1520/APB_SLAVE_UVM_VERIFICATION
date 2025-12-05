class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)

  apb_act_agent act_agt;
  apb_pass_agent pass_agt;
  apb_scb scb;
  apb_coverage sub;

  function new(string name = "apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //uvm_config_db#(uvm_active_passive_enum)::set(this, "act_agt", "is_active", UVM_ACTIVE)
    //uvm_config_db#(uvm_active_passive_enum)::set(this, "pass_agt", "is_active", UVM_PASSIVE)

    act_agt = apb_act_agent::type_id::create("act_agt", this);
    pass_agt = apb_pass_agent::type_id::create("pass_agt", this);

    scb = apb_scb::type_id::create("scb", this);
    sub = apb_coverage::type_id::create("sub", this);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    act_agt.act_mon.analysis_act_port.connect(scb.analysis_act_imp);
    pass_agt.pass_mon.analysis_pass_port.connect(scb.analysis_pass_imp);
   
    act_agt.act_mon.analysis_act_port.connect(sub.analysis_act_imp);
    pass_agt.pass_mon.analysis_pass_port.connect(sub.analysis_pass_imp);
  endfunction: connect_phase
endclass: apb_env
