interface apb_intf(input bit PCLK, input bit PRESET_n);
  //Signals 
  logic PWRITE;
  logic PSELx;
  logic PENABLE;
  logic [7:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  logic PREADY;
  logic PSLVERR;
  logic [3:0] PSTRB;

  //Driver clocking block
  clocking drv_cb @(posedge PCLK);
    default input #0 output #0;
    output PWRITE, PSELx, PENABLE, PADDR, PWDATA, PSTRB;
    input PREADY;
  endclocking

  //Monitor clocking block
  clocking mon_cb @(posedge PCLK);
    default input #0 output #0;
    input PREADY, PRDATA, PSLVERR, PSTRB, PWRITE, PSELx, PENABLE, PADDR, PWDATA;
  endclocking

endinterface: apb_intf
