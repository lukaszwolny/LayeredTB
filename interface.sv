//interfejs
interface acc_if(
  input logic clk
//   input logic rst
);
  logic [7:0] in;
  logic ceAcu;
  logic [7:0] out;
  logic rst;
  
  //driver clocking block
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    //jako wyjscia (wejscia do DUT)
    output ceAcu;
    output in;
    output rst;
  endclocking
  
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    //tutaj jako wejscia
    input in;
    input out;
    input ceAcu;
    input rst;
  endclocking
  
  modport driver_mode (clocking driver_cb, input clk);//, output rst
    modport monitor_mode (clocking monitor_cb, input clk );//, input rst
      
endinterface