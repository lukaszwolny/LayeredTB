`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  generator gen;
  driver    driv;
  monitor   mon;
  scoreboard scb;
  
  mailbox   env_mbx_drv;
  mailbox   env_mbx_mon;
  
  event gen_done;
  event rst_done;
  
  virtual acc_if vif;
  
  //constructor
  function new(virtual acc_if vif);
    this.vif = vif;
    env_mbx_drv = new();
    env_mbx_mon = new();
    gen = new(env_mbx_drv, gen_done);
    driv = new(vif, env_mbx_drv);
    mon  = new(vif, env_mbx_mon);
    scb  = new(env_mbx_mon, rst_done);
  endfunction

  //
  task pre_test();//taki initial
    driv.reset();
  endtask
  
  // test acc - zapis/odczyt 
  task test();
    fork 
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask

  //Task dla resetu
  task test_reset();
    scb.koniec = 0;
    fork 
      driv.reset_task();
      mon.main();
      scb.main();
    join_any
    wait(rst_done.triggered);
    scb.koniec = 1;
    $display("koniec here");
  endtask
  
  task post_test();
    wait(gen_done.triggered);
    wait(gen.repeat_count == driv.trans_cnt);
    wait(mon.trans_cnt == scb.trans_cnt);
  endtask  
  
  //run task
  task run;
    pre_test(); //reset drivera

    #10;
    driv.trans_cnt = 0;
    mon.trans_cnt = 0;
    scb.trans_cnt = 0;
    
    $display("Test Acc");
    test();
    post_test();
    #30;
    $display("Test Reset");
    test_reset();

    #10 $finish;
  endtask
  
endclass