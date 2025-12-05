class apb_pass_monitor extends uvm_monitor;
  `uvm_component_utils(apb_pass_monitor)

  uvm_analysis_port#(apb_seq_item) analysis_pass_port;

  virtual apb_intf vif;
  apb_seq_item req;

  function new(string name = "apb_pass_monitor", uvm_component parent);
    super.new(name, parent);
    analysis_pass_port = new("analysis_pass_port", this);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_intf)::get(this, "", "apb_intf", vif))
      `uvm_error("MON", "The set failed")
    
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    forever begin
      req = apb_seq_item::type_id::create("req");
      wait(vif.drv_cb.PREADY && vif.drv_cb.PSELx && vif.drv_cb.PENABLE);
      sample_op();
    end
  endtask

  task sample_op();
    @(vif.mon_cb);
    req.PRDATA = vif.mon_cb.PRDATA;
    req.PREADY = vif.mon_cb.PREADY;
    req.PSLVERR = vif.mon_cb.PSLVERR;
    `uvm_info("PASS_MON", $sformatf("PRDATA = %0d", req.PRDATA), UVM_NONE)
    //`uvm_info("PASS_MON", "----------------------Captured outputs------------------------", UVM_NONE)
    analysis_pass_port.write(req);
  endtask
endclass: apb_pass_monitor

//////////////

class apb_act_monitor extends uvm_monitor;
  `uvm_component_utils(apb_act_monitor)

  uvm_analysis_port#(apb_seq_item) analysis_act_port;

  virtual apb_intf vif;
  apb_seq_item req;

  function new(string name = "apb_act_monitor", uvm_component parent);
    super.new(name, parent);
    analysis_act_port = new("analysis_act_port", this);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_intf)::get(this, "", "apb_intf", vif))
      `uvm_error("MON", "The set failed")
    
  endfunction: build_phase

  task run_phase(uvm_phase phase);
  
    forever begin
      req = apb_seq_item::type_id::create("req");
      wait(vif.drv_cb.PREADY && vif.drv_cb.PSELx && vif.drv_cb.PENABLE);
      sample_op();
    end
  endtask

  task sample_op();
    @(vif.mon_cb);
    req.PSELx = vif.mon_cb.PSELx;
    req.PENABLE = vif.mon_cb.PENABLE;
    req.PSTRB = vif.mon_cb.PSTRB;
    req.PADDR = vif.mon_cb.PADDR;
    req.PWRITE = vif.mon_cb.PWRITE;
    req.PWDATA = vif.mon_cb.PWDATA;
    //`uvm_info("ACT_MON", "----------------------Captured inputs------------------------", UVM_NONE)
    analysis_act_port.write(req);
  endtask
endclass: apb_act_monitor
