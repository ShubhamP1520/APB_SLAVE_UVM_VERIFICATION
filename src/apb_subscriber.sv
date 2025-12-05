//`uvm_analysis_imp_decl(_0)
class apb_coverage extends uvm_subscriber#(apb_seq_item);
  `uvm_component_utils(apb_coverage)
  `uvm_analysis_imp_decl(_0)
  uvm_analysis_imp_0#(apb_seq_item, apb_coverage) analysis_act_imp;
  uvm_analysis_imp#(apb_seq_item, apb_coverage) analysis_pass_imp;

  apb_seq_item mon_pass_seq, mon_act_seq;
  real mon_act_cov, mon_pass_cov;

  covergroup input_cvg;

    option.auto_bin_max = 4;

    SEL_CP: coverpoint mon_act_seq.PSELx{
      bins sel[] = {0, 1};
    }
    
    ENABLE_CP: coverpoint mon_act_seq.PENABLE{
      bins en[] = {0, 1};
    }

    STRB_CP: coverpoint mon_act_seq.PSTRB{
      bins strb[] = {[0:15]};
    }

    ADDR_CP: coverpoint mon_act_seq.PADDR{
      bins addr_low   = {[0:63]};
      bins addr_mid   = {[64:127]};
      bins addr_high  = {[128:191 ]};
      bins addr_upper = {[191:255]};
    }

    WDATA_CP: coverpoint mon_act_seq.PWDATA;

    READ_WRITE: coverpoint mon_act_seq.PWRITE{
      bins read  = {0};
      bins write = {1};
    }

    SEL_X_ENABLE: cross SEL_CP, ENABLE_CP;
    ADDR_X_WDATA: cross ADDR_CP, WDATA_CP;
  endgroup
  
  covergroup output_cvg;
    option.auto_bin_max = 4;
    RDATA_CP: coverpoint mon_pass_seq.PRDATA;
    PSLVERR_CP: coverpoint mon_pass_seq.PSLVERR {
      bins no_err = {0};
      bins err    = {1};
    }
    PREADY_CP:coverpoint mon_pass_seq.PREADY;
  endgroup
  
  function new(string name = "apb_coverage", uvm_component parent);
    super.new(name, parent);
    input_cvg = new;
    output_cvg = new;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_act_imp = new("analysis_act_imp", this);
    analysis_pass_imp = new("analysis_pass_imp", this);
  endfunction

  function void write(apb_seq_item t);
    mon_pass_seq = t;
    output_cvg.sample();
  endfunction

  function void write_0(apb_seq_item t);
    mon_act_seq = t;
    input_cvg.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    mon_act_cov = input_cvg.get_coverage();
    mon_pass_cov = output_cvg.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name, $sformatf("Input Coverage ------> %0.2f%%,", mon_act_cov), UVM_MEDIUM);
    `uvm_info(get_type_name, $sformatf("Output Coverage ------> %0.2f%%", mon_pass_cov), UVM_MEDIUM);
  endfunction

endclass
