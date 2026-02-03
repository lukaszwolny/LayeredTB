//Driver
class driver;
  virtual acc_if.driver_mode vif;
  mailbox drv_mbx;
  int trans_cnt=0;
  
  function new(virtual acc_if.driver_mode vif, mailbox drv_mbx);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from environment 
    this.drv_mbx = drv_mbx;
  endfunction
  
  //reset task
  task reset;
//     wait(!vif.rst);
    vif.driver_cb.rst <= 1'b1;
    
    vif.driver_cb.in <= '0;
    vif.driver_cb.ceAcu <= 1'b0;
    @(posedge vif.clk);
    $display("[DRIVER] reset");
    vif.driver_cb.rst <= 1'b0;
//     wait(vif.rst);
//     $display("[DRIVER] reset done");
  endtask
  
  //main task
  task main();
    forever begin
      
      transaction item;
      drv_mbx.get(item);
//       $display("[DRIVER] nowa tranzakcja start");
      vif.driver_cb.in <= item.in;
      vif.driver_cb.ceAcu <= item.ceAcu;
//       $display("[DRIVER] transfer %0d generated: %0h, %0h", trans_cnt, item.in,  item.ceAcu);
      @(posedge vif.clk);
      trans_cnt++;
      
    end
  endtask
  
  //task dla resetu
  task reset_task();  //reset_check();

    $display("[DRIVER] reset task start - zapisz");
    vif.driver_cb.ceAcu <= 1'b0;
    vif.driver_cb.in <= '0;
    vif.driver_cb.rst <= 1'b1;
    @(posedge vif.clk);
    vif.driver_cb.rst <= 1'b0;
    @(posedge vif.clk);

  endtask
  
endclass