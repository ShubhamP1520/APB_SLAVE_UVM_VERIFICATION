program apb_assertion(PCLK, PRESETn, PSEL, PENABLE, PWRITE, PSTRB, PWDATA, PADDR, PRDATA, PREADY, PSLVERR);
  input PCLK;
  input PRESETn;
  input [3:0]PSTRB;
  input PSEL;
  input PENABLE;
  input PWRITE;
  input [31:0]PWDATA;
  input [7:0]PADDR;
  input [31:0]PRDATA;
  input PREADY;
  input PSLVERR;

  //RESET CHECK
  property reset_check;
    @(posedge PCLK) !PRESETn |=> (PRDATA == 0 && PSLVERR == 0);
  endproperty
  assert property(reset_check)
  $info("PRESETn Assertion Passed");
  else
    $error("PRESETn Assertion Failed");

  //FUNCTIONALITY CHECK
  ///1
  property functionality_1;
    @(posedge PCLK) disable iff(!PRESETn) (PSEL && !PENABLE) |=> (PSEL && PENABLE);
  endproperty 
  assert property(functionality_1)
  $info("FUNC1 Assertion Passed");
  else
    $error("FUNC1 Assertion Failed");
  ///2
  property functionality_2;
    @(posedge PCLK) disable iff(!PRESETn) (PREADY && PSEL && PENABLE)|=> !PENABLE;
  endproperty 

  assert property(functionality_2)
  $info("FUNC2 Assertion Passed");
  else
    $error("FUNC2 Assertion Failed");
  ///3
  property functionality_3;
    @(posedge PCLK) disable iff(!PRESETn) (PSEL && !PENABLE) |=> 
      ($stable(PWDATA) && $stable(PWRITE) &&$stable(PADDR)) until (PSEL && PENABLE && PREADY);
  endproperty 

  assert property(functionality_3)
  $info("FUNC3 Assertion Passed");
  else
    $error("FUNC3 Assertion Failed");

  //SLVERR CHECK
  property slave_err;
    @(posedge PCLK) disable iff(!PRESETn) (PADDR > 256) |-> PSLVERR;
  endproperty

  //SLVERR VALIDITY
  assert property(slave_err)
  $info("SLVERR Assertion Passed");
  else
    $error("SLVERR Assertion Failed");

  property slave_err_validity;
    @(posedge PCLK) disable iff(!PRESETn) PSLVERR |-> (PSEL && PENABLE && PREADY);
  endproperty

  assert property(slave_err_validity)
  $info("SLVERR VALID Assertion Passed");
  else
    $error("SLVERR VALID Assertion Failed");

endprogram
