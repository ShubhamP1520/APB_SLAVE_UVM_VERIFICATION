`include "apb_interface.sv"
`include "apb_assertion.sv"
`include "uvm_macros.svh"
`include "slave_design.v"
module top;
  import uvm_pkg::*;
  import apb_pkg::*;

  bit clk;
  bit rst_n;

  initial begin
    clk= 0;
    forever #5 clk = ~clk;
  end

  apb_intf vif(clk, rst_n);
  apb_slave DUT(.PCLK(clk), .PRESETn(rst_n),
          .PSEL(vif.PSELx),
          .PENABLE(vif.PENABLE),
          .PWRITE(vif.PWRITE),
          .PADDR(vif.PADDR),
          .PWDATA(vif.PWDATA),
          .PSLVERR(vif.PSLVERR),
          .PRDATA(vif.PRDATA),
          .PSTRB(vif.PSTRB),
          .PREADY(vif.PREADY)
  );
  bind DUT apb_assertion ASSERT(.*);
  
  initial begin
    rst_n = 0;
    //#3 rst_n = 0;
    #15 rst_n = 1;
  end

  initial begin
    uvm_config_db#(virtual apb_intf)::set(null, "*", "apb_intf", vif);
    run_test("apb_regression_test");
  end
endmodule: top
