class apb_seq_item extends uvm_sequence_item;
  `uvm_object_utils(apb_seq_item)

  rand bit [31:0]PWDATA;
  rand bit [7:0]PADDR;
  rand bit PSELx;
  rand bit PENABLE;
  rand bit PWRITE;
  rand bit [3:0] PSTRB;
  
  logic PREADY;
  logic [31:0] PRDATA;
  logic PSLVERR;

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction
endclass
