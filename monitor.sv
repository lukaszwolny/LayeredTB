//Monitor
class monitor;
  virtual acc_if.monitor_mode vif;
  mailbox scb_mbx;//mailbox monitor-scoreboard
  int trans_cnt=0;
  
  //konstruktor
  function new(virtual acc_if.monitor_mode vif, mailbox scb_mbx);
    this.vif = vif;
    this.scb_mbx = scb_mbx;
  endfunction
  
  task main();
    trans_cnt=0;
    forever begin
      transaction item;
      item = new();
      @(posedge vif.clk);
      item.in = vif.monitor_cb.in;
      item.ceAcu = vif.monitor_cb.ceAcu;
      item.out = vif.monitor_cb.out;
      item.rst = vif.monitor_cb.rst;
      scb_mbx.put(item); //do mailboxa
//       $display("[MONITOR] transfer: %0h, %0h, %0h, %0h", trans_cnt, item.in, item.ceAcu, item.out);
      trans_cnt++;
    end
  endtask
  

endclass