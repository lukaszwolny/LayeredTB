//Driver
class driver;
  virtual acc_if.driver_mode vif;
  mailbox drv_mbx;
  int trans_cnt=0;
  
  //konstruktor
  function new(virtual acc_if.driver_mode vif, mailbox drv_mbx);
    this.vif = vif;
    this.drv_mbx = drv_mbx;
  endfunction
  
  //reset task - taki initial
  task reset;
    vif.driver_cb.rst <= 1'b1;
    vif.driver_cb.in <= '0;
    vif.driver_cb.ceAcu <= 1'b0;
    @(posedge vif.clk);
    $display("[DRIVER] initial");
    vif.driver_cb.rst <= 1'b0;
  endtask
  
  //main task
  task main();
    forever begin
      transaction item;
      drv_mbx.get(item);//nowe dane
      vif.driver_cb.in <= item.in;
      vif.driver_cb.ceAcu <= item.ceAcu;
      @(posedge vif.clk);
      trans_cnt++;
      
    end
  endtask
  
  //task dla resetu
  task reset_task();
    $display("[DRIVER] reset task start");
    vif.driver_cb.ceAcu <= 1'b0;
    vif.driver_cb.in <= '0;
    vif.driver_cb.rst <= 1'b1;
    @(posedge vif.clk);
    vif.driver_cb.rst <= 1'b0;
    @(posedge vif.clk);
  endtask
  
endclass