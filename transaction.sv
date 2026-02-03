//Transaction
class transaction;
  rand bit [7:0] in;
  rand bit ceAcu;
  bit [7:0] out;
  bit rst;
  
  constraint ce {
    ceAcu dist {1 := 50, 0 := 50};//50 na 50
  }
  
//   function void print();
//     $display("[%0t] in=%0h ceAcu=%0b out=%0h", $time, in, ceAcu, out);
//   endfunction
  
endclass