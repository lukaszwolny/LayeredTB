//scoreboard
class scoreboard;
  mailbox scb_mbx;
  int trans_cnt = 0;
  
  bit [7:0] acc_ref;//model akumulatora
  bit byl_reset;
  bit koniec;
  event rst_done; //sygnalizowanie koniec task z rst.
  
  //konstruktor
  function new(mailbox scb_mbx, event rst_done);
    this.scb_mbx = scb_mbx;
    this.rst_done = rst_done;
    acc_ref = '0;
    byl_reset = 0;
  endfunction
  
  task main();
    transaction item;
    trans_cnt = 0;
    byl_reset = 0;
    forever begin
      scb_mbx.get(item);
      
      if(koniec == 1) break;
      
      //z resetem
      if(item.rst) begin
        acc_ref <= '0;//reset
        byl_reset = 1;
        $display("[SCOREBOARD] RESET wykryty");
      end
      if (byl_reset) begin //sprawedzanie czy akumulator = 0
        if (item.out !== 0)
          $display("[SCOREBOARD][RESET] ERROR out=%0h", item.out);
        else
          $display("[SCOREBOARD][RESET] PASS out=0");
        -> rst_done;   // test z rst: koniec
         break;
      end else begin
        //zapis/odczyt
        if(item.ceAcu) begin //jesli jest zapis
          acc_ref <= item.in;
        end
        if(item.out != acc_ref) begin
          $display("[SCOREBOARD] ERROR. %0d. expected = %0h, actual = %0h",trans_cnt, acc_ref, item.out);
        end else begin
          $display("[SCOREBOARD] PASS. %0d. expected = %0h, actual = %0h", trans_cnt, acc_ref, item.out);
        end
        trans_cnt++;
      end

    end
  endtask

  
endclass