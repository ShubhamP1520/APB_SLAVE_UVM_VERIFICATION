/*class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)

  apb_sequence seq;
  apb_env env;

  function new(string name = "apb_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = apb_sequence::type_id::create("seq", this);
    seq.start(env.act_agt.seqr);
    phase.drop_objection(this);
  endtask: run_phase

endclass: apb_test
*/

//Base test class (already provided)
class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  apb_sequence seq;
  apb_env env;

  function new(string name = "apb_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = apb_sequence::type_id::create("seq", this);
    seq.start(env.act_agt.seqr);
    phase.drop_objection(this);
  endtask: run_phase
endclass: apb_test

//Simple write test
class simple_write_test extends uvm_test;
  `uvm_component_utils(simple_write_test)
  simple_write_sequence seq;
  apb_env env;

  function new(string name = "simple_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = simple_write_sequence::type_id::create("seq", this);
    seq.start(env.act_agt.seqr);
    phase.drop_objection(this);
  endtask: run_phase
endclass: simple_write_test

//Simple read test
class simple_read_test extends uvm_test;
  `uvm_component_utils(simple_read_test)
  simple_read_sequence seq;
  apb_env env;

  function new(string name = "simple_read_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = simple_read_sequence::type_id::create("seq", this);
    seq.start(env.act_agt.seqr);
    phase.drop_objection(this);
  endtask: run_phase
endclass: simple_read_test

//Write-Read test
class apb_write_read_test extends uvm_test;
  `uvm_component_utils(apb_write_read_test)
  apb_write_read_sequence seq;
  apb_env env;

  function new(string name = "apb_write_read_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = apb_write_read_sequence::type_id::create("seq", this);
    seq.start(env.act_agt.seqr);
    phase.drop_objection(this);
  endtask: run_phase
endclass: apb_write_read_test

//Regression test
class apb_regression_test extends uvm_test;
  `uvm_component_utils(apb_regression_test)
  apb_regression_sequence reg_seq;
  apb_env env;

  function new(string name = "apb_regression_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("REGRESSION_TEST", "Starting APB Regression Test", UVM_LOW)
    reg_seq = apb_regression_sequence::type_id::create("reg_seq", this);
    reg_seq.start(env.act_agt.seqr);
    `uvm_info("REGRESSION_TEST", "APB Regression Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask: run_phase
endclass: apb_regression_test
