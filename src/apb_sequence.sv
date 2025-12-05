`define DEPTH 256

//Default randomized sequence/////
class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence" );
    super.new(name);
  endfunction: new

  task body();
    req = apb_seq_item::type_id::create("req");
    repeat(`DEPTH) begin
      start_item(req);
      void'(req.randomize());
      `uvm_info("SEQ", $sformatf("PWRITE = %0d || PWDATA = %0d || PADDR = %0d|| PSTRB = %0d", req.PWRITE, req.PWDATA, req.PADDR, req.PSTRB), UVM_NONE)
      finish_item(req);
    end
  endtask: body
endclass : apb_sequence


//Simple write sequence
class simple_write_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(simple_write_sequence)

  bit[7:0] count;
  function new(string name = "simple_write_sequence" );
    super.new(name);
  endfunction: new

  task body();
    req = apb_seq_item::type_id::create("req");
    repeat(`DEPTH) begin
      start_item(req);
      void'(req.randomize()with{req.PWRITE == 1; req.PADDR == count; req.PSTRB == 4'b1111; req.PSELx == 0; req.PENABLE == 0;});
      `uvm_info("SEQ", $sformatf("PWRITE = %0d || PWDATA = %0d || PADDR = %0d|| PSTRB = %0d", req.PWRITE, req.PWDATA, req.PADDR, req.PSTRB), UVM_NONE)
      count++;      
      finish_item(req);
    end
  endtask: body
endclass : simple_write_sequence


//Simple read sequence
class simple_read_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(simple_read_sequence)

  bit[7:0] count;
  function new(string name = "simple_read_sequence" );
    super.new(name);
  endfunction: new

  task body();
    req = apb_seq_item::type_id::create("req");
    repeat(`DEPTH) begin
      start_item(req);
      void'(req.randomize()with{req.PWRITE == 0; req.PADDR == count; req.PSELx == 0; req.PENABLE == 0;});
      `uvm_info("SEQ", $sformatf("PWRITE = %0d || PWDATA = %0d || PADDR = %0d|| PSTRB = %0d", req.PWRITE, req.PWDATA, req.PADDR, req.PSTRB), UVM_NONE)
      count++;      
      finish_item(req);
    end
  endtask: body
endclass : simple_read_sequence

//Continuous Write and read from the written memory locations
class apb_write_read_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_write_read_sequence)

  bit[7:0] count;
  function new(string name = "apb_write_read_sequence" );
    super.new(name);
  endfunction: new

  task body();
      req = apb_seq_item::type_id::create("req");
    repeat(`DEPTH) begin
      start_item(req);
      void'(req.randomize()with{req.PWRITE == 1; req.PADDR == count; req.PSTRB == 4'b1111; req.PSELx == 0; req.PENABLE == 0;});
      `uvm_info("SEQ", $sformatf("PWRITE = %0d || PWDATA = %0d || PADDR = %0d|| PSTRB = %0d", req.PWRITE, req.PWDATA, req.PADDR, req.PSTRB), UVM_NONE)
      count++;      
      finish_item(req);
    end
    count = 0;
    repeat(`DEPTH) begin
      req = apb_seq_item::type_id::create("req");
      start_item(req);
      void'(req.randomize()with{req.PWRITE == 0; req.PADDR == count; req.PSELx == 0; req.PENABLE == 0;});
      `uvm_info("SEQ", $sformatf("PWRITE = %0d || PADDR = %0d", req.PWRITE, req.PADDR), UVM_NONE)
      count++;      
      finish_item(req);
    end
    endtask: body
endclass : apb_write_read_sequence


//Regression sequence - runs all sequences
class apb_regression_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_regression_sequence)

  apb_sequence default_seq;
  simple_write_sequence wr_seq;
  simple_read_sequence rd_seq;
  apb_write_read_sequence wr_rd_seq;

  function new(string name = "apb_regression_sequence");
    super.new(name);
  endfunction: new

  task body();
    `uvm_info("REGRESSION_SEQ", "Starting Regression Sequence", UVM_LOW)

    // Run default randomized sequence
    `uvm_info("REGRESSION_SEQ", "Running Default Randomized Sequence", UVM_LOW)
    default_seq = apb_sequence::type_id::create("default_seq");
    default_seq.start(m_sequencer);

    // Run simple write sequence
    `uvm_info("REGRESSION_SEQ", "Running Simple Write Sequence", UVM_LOW)
    wr_seq = simple_write_sequence::type_id::create("wr_seq");
    wr_seq.start(m_sequencer);

    // Run simple read sequence
    `uvm_info("REGRESSION_SEQ", "Running Simple Read Sequence", UVM_LOW)
    rd_seq = simple_read_sequence::type_id::create("rd_seq");
    rd_seq.start(m_sequencer);

    // Run write-read sequence
    `uvm_info("REGRESSION_SEQ", "Running Write-Read Sequence", UVM_LOW)
    wr_rd_seq = apb_write_read_sequence::type_id::create("wr_rd_seq");
    wr_rd_seq.start(m_sequencer);

    `uvm_info("REGRESSION_SEQ", "Regression Sequence Completed", UVM_LOW)
  endtask: body
endclass: apb_regression_sequence


