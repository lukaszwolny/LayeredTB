`include "transaction.sv"
class generator;
  	rand transaction trans;
    mailbox gen_mbx;
    int repeat_count;
    event gen_done;

  function new(mailbox gen_mbx, event gen_done);
        this.gen_mbx = gen_mbx;
//         repeat_count = 10;
    	this.gen_done = gen_done;
    endfunction

    task main();
      repeat (repeat_count) begin   
      	trans = new();
      	trans.randomize();    
      	gen_mbx.put(trans);
     end
     ->gen_done;
    endtask
endclass