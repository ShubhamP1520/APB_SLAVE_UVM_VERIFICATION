`uvm_analysis_imp_decl(_0)
`uvm_analysis_imp_decl(_1)

class apb_scb extends uvm_scoreboard;
  `uvm_component_utils(apb_scb)

  uvm_analysis_imp_0 #(apb_seq_item, apb_scb) analysis_act_imp;
  uvm_analysis_imp_1 #(apb_seq_item, apb_scb) analysis_pass_imp;

  apb_seq_item act_q[$];
  apb_seq_item pass_q[$];

  bit [31:0]mem[256];
  bit expected_slave_err;

  int pass_count, fail_count;

  function new(string name = "apb_scb", uvm_component parent);
    super.new(name, parent);
    analysis_pass_imp = new("analysis_pass_imp", this);
    analysis_act_imp = new("analysis_act_imp", this);
  endfunction

  function void write_0(apb_seq_item req);
    act_q.push_back(req);
  endfunction

   function void write_1(apb_seq_item req);
     pass_q.push_back(req);
  endfunction

  task run_phase(uvm_phase phase);
    
    apb_seq_item act_item;
    apb_seq_item pass_item;
    forever begin
      fork
        begin
          wait(act_q.size() > 0);
          act_item = act_q.pop_front();
        end
        begin
          wait(pass_q.size() > 0);
          pass_item = pass_q.pop_front();
        end
      join
      compare_(act_item , pass_item);
    end
  endtask

  task compare_(input apb_seq_item act_item , input apb_seq_item pass_item);
    if(act_item.PADDR > 256)
      expected_slave_err = 1;

    if(act_item.PWRITE) begin
      for (int i = 0; i < `STRB_W; i = i + 1) begin
        if (act_item.PSTRB[i]) begin
          mem[act_item.PADDR][i*`BYTE_WIDTH +: `BYTE_WIDTH] = act_item.PWDATA[i*`BYTE_WIDTH +: `BYTE_WIDTH];
        end
      end
    end
    else if(act_item.PWRITE == 0)begin
      if(mem[act_item.PADDR] === pass_item.PRDATA) begin
        pass_count ++;
        `uvm_info("SCB", $sformatf("|--- MATCH   : ACTUAL RDATA = %0d ||| EXP RDATA = %0d",pass_item.PRDATA, mem[act_item.PADDR]), UVM_NONE)
      end
      else begin
        fail_count ++;
        `uvm_info("SCB", $sformatf("|--- MISMATCH: ACTUAL RDATA = %0d ||| EXP RDATA = %0d",pass_item.PRDATA, mem[act_item.PADDR]), UVM_NONE)
      end
    end
    if(pass_item.PSLVERR === expected_slave_err)
      `uvm_info("SCB", $sformatf("|--- MATCH  : ACTUAL SLVERR= %0d ||| EXP SLVERR= %0d",pass_item.PSLVERR, expected_slave_err), UVM_NONE)
    else
      `uvm_info("SCB", $sformatf("|--- MISMATCH : ACTUAL SLVERR= %0d ||| EXP SLVERR= %0d",pass_item.PSLVERR, expected_slave_err), UVM_NONE)
    $display("---------------------------------------------------------------------------------------------------------------------------------------");
  endtask

  function void report_phase(uvm_phase phase);
    `uvm_info("SCB", $sformatf("|| RDATA CHECKS : TOTAL MATCHES: %0d || TOTAL MISMATCHES = %0d", pass_count, fail_count),UVM_NONE)
    $display("---------------------------------------------------------------------------------------------------------------------------------------");
  endfunction

endclass
