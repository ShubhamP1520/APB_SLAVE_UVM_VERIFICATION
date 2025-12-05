class apb_driver extends uvm_driver#(apb_seq_item);
  `uvm_component_utils(apb_driver)

  virtual apb_intf vif;

  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_intf)::get(this, "", "apb_intf", vif))
      `uvm_error("DRV", "The set failed")
  endfunction

  task run_phase(uvm_phase phase);
    vif.drv_cb.PSELx   <= 0;
    vif.drv_cb.PENABLE <= 0;

    forever begin
      @(vif.drv_cb);
      seq_item_port.get_next_item(req);
      drive_dut();
      seq_item_port.item_done();
    end
  endtask

  task drive_dut();

    //SETUP PHASE
    vif.drv_cb.PSELx   <= 1;
    vif.drv_cb.PWRITE  <= req.PWRITE;
    if (req.PWRITE) begin
      vif.drv_cb.PWDATA <= req.PWDATA;
      vif.drv_cb.PSTRB <= req.PSTRB;
    end
    else begin
      vif.drv_cb.PWDATA <= 0;
      vif.drv_cb.PSTRB <= 0;
    end
    vif.drv_cb.PADDR   <= req.PADDR;
    vif.drv_cb.PENABLE <= 0;

    
    //ACCESS PHASE
    @(vif.drv_cb);
    vif.drv_cb.PSELx   <= 1;
    vif.drv_cb.PENABLE <= 1;
    wait(vif.drv_cb.PREADY);
    if(!req.PWRITE)
      req.PRDATA = vif.PRDATA;
   
    @(vif.drv_cb);
    vif.drv_cb.PSELx   <= req.PSELx;
    vif.drv_cb.PENABLE <= req.PENABLE;
  endtask

endclass

